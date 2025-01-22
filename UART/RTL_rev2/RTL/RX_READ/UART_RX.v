module UART_RX#(
    parameter DATA_WIDTH = 8,
    parameter DATA_WIDTH_WIDTH = $clog2(DATA_WIDTH),
    parameter BAUDRATE = 9600,
    parameter CLK_FREQ_MHZ = 125,
    // parameter BAUDRATE_COUNT = CLK_FREQ_MHZ * 1_000_000 / (BAUDRATE * 16),
    parameter BAUDRATE_COUNT = CLK_FREQ_MHZ * 1_000_000 / (BAUDRATE * 2),
    parameter BAUDRATE_WIDTH = $clog2(BAUDRATE_COUNT)
)(
    input clk,
    input rstn,
    input rx,
    output wire [DATA_WIDTH-1:0] data_o,
    output wire rx_done,
    output wire rx_busy
);
    // Define parameter //
    localparam IDLE = 2'b00;
    localparam START= 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;
    
    reg [1:0] curr_state;
    reg [1:0] next_state;
    reg [DATA_WIDTH-1:0] memory;
    reg [DATA_WIDTH_WIDTH-1:0] rx_cnt;
    reg r_rx_done;
    reg [BAUDRATE_WIDTH:0] baud_cnt;
    reg r_rx_done_delay;

    wire w_rx_busy= (curr_state != IDLE);
    wire r_rx_done_edge = ((~r_rx_done_delay) & r_rx_done);
    
    assign data_o = memory;
    assign rx_done = r_rx_done_edge;
    assign rx_busy = w_rx_busy;
    assign baud = (baud_cnt == ((BAUDRATE_COUNT) - 1)) ? 1'b1 : 1'b0;

    // BAUDRATE part //
    // Determine baud count
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            baud_cnt <= 0;
        end
        else begin
            if((baud_cnt == ((BAUDRATE_COUNT) - 1))) begin
                baud_cnt <= 0;
            end
            else if (curr_state != IDLE) begin
                baud_cnt <= baud_cnt + 1;
            end
        end
    end

    // UART RX part //
    // Determine state
    always @(posedge clk or negedge rstn) begin
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
                    if(!rx) begin
                        next_state = START;
                    end
                end
            START:
                begin
                    if(baud) begin
                        next_state = DATA;
                    end
                end
            DATA:
                begin
                    if((&rx_cnt) && baud) begin
                        next_state = STOP;
                    end
                end
            STOP:
                begin
                    if(baud) begin
                        next_state = IDLE;
                    end
                end
        endcase
    end
    // Determine rx data
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            memory <= 0;
        end
        else begin
            if(curr_state == DATA) begin
                memory[rx_cnt] <= rx;
            end
        end
    end
    // Determine rx count
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            rx_cnt <= 0;
        end 
        else begin
            if((curr_state == DATA) && baud) begin
                rx_cnt <= rx_cnt + 1;
            end
            else if (curr_state != DATA) begin
                rx_cnt <= 0; 
            end
        end
    end
    // Determine done
    always @(*) begin
        if(curr_state == STOP) begin
            r_rx_done = 1;
        end
        else begin
            r_rx_done = 0;
        end
    end
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            r_rx_done_delay <= 0;
        end
        else begin
            r_rx_done_delay <= r_rx_done;
        end
    end
endmodule
