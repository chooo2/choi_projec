module UART_TX#(
    parameter DATA_WIDTH = 8,
    parameter DATA_WIDTH_WIDTH = $clog2(DATA_WIDTH),
    parameter BAUDRATE = 9600,
    parameter CLK_FREQ_MHZ = 125,
    parameter BAUDRATE_COUNT = CLK_FREQ_MHZ * 1_000_000 / BAUDRATE,
    parameter BAUDRATE_WIDTH = $clog2(BAUDRATE_COUNT)
)(
    input clk,
    input rstn,
    input start,
    input [7:0] data_i,
    output wire tx,
    output wire tx_busy,
    output wire tx_done
);
    // Define parameter //
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;
    
    reg [1:0] curr_state;
    reg [1:0] next_state;
    reg [2:0] tx_cnt;
    reg [7:0] memory;
    reg [BAUDRATE_WIDTH:0] baud_cnt;
    reg sys_clk;
    reg r_tx_done;
    reg r_tx_busy;
    reg r_tx;

    wire w_tx_busy = (curr_state != IDLE);
    
    assign tx_busy = w_tx_busy;
    assign tx_done = r_tx_done;
    assign tx = r_tx;

    // BAUDRATE part //
    // Determine baud count
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            baud_cnt <= 0;
        end
        else begin
            if(baud_cnt == ((BAUDRATE_COUNT/2)-1)) begin
                baud_cnt <= 0;
            end
            else begin
                baud_cnt <= baud_cnt + 1;
            end
        end
    end
    // Determine clock generate
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            sys_clk <= 0;
        end
        else begin
            if(baud_cnt == ((BAUDRATE_COUNT/2) - 1)) begin
                sys_clk <= ~sys_clk;
            end
        end
    end

    // UART TX part //
    // Determine state
    always @(posedge sys_clk or negedge rstn) begin
        if(!rstn) begin
            curr_state <= IDLE;
        end
        else begin
            curr_state <= next_state;
        end
    end
    always @(*) begin
        next_state = curr_state;
        case(curr_state)
            IDLE:
                begin
                    if(start) begin
                        next_state = START;
                    end
                end
            START:
                begin
                    next_state = DATA;
                end
            DATA:
                begin
                    if(&tx_cnt) begin
                        next_state = STOP;
                    end
                end
            STOP:
                begin
                    if(tx_cnt == 3) begin
                        next_state = IDLE;
                    end
                end
        endcase
    end
    // Determine tx count
    always @(posedge sys_clk or negedge rstn) begin
        if(!rstn) begin
            tx_cnt <= 0;
        end
        else begin
            if((curr_state == DATA) || (curr_state == STOP)) begin
                tx_cnt <= tx_cnt + 1;
            end
            else begin
                tx_cnt <= 0;
            end
        end
    end
    // Determine tx data
    always @(posedge sys_clk or negedge rstn) begin
        if(!rstn) begin
            memory <= 0;
        end
        else begin
            if(curr_state == START) begin
                memory <= data_i;
            end
        end
    end
    // Determine output data
    always @(posedge sys_clk or negedge rstn) begin
        if(!rstn) begin
            r_tx <= 1;
        end
        else begin
            case(curr_state)
                IDLE:
                    begin
                        r_tx <= 1;
                    end
                START:
                    begin
                        r_tx <= 0;
                    end
                DATA:
                    begin
                        r_tx <= memory[tx_cnt];
                    end
                STOP:
                    begin
                        r_tx <= 1;
                    end
            endcase
        end
    end
    // Determine tx done
    always @(posedge sys_clk or negedge rstn) begin
        if(!rstn) begin
            r_tx_done <= 0;
        end
        else begin
            case(curr_state)
                IDLE:
                    begin
                        r_tx_done <= 0;
                    end
                STOP:
                    begin
                        r_tx_done <= 1;
                    end
            endcase
        end
    end
endmodule