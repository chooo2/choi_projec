module uart_tx #(
    parameter DATA_LENGTH = 8,
    parameter DATA_LENGTH_WIDTH = $clog2(DATA_LENGTH),
    parameter MAX_CNT = 4'd8
)(
    input clk,                          // clock
    input rst,                          // reset
    input [DATA_LENGTH-1:0] din,        // input data
    input start_bit,
    output wire tx,                      // transmit data
    output wire tx_busy,
    output wire tx_done
);

    localparam IDLE = 2'b00;
    localparam START= 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;
    reg [DATA_LENGTH_WIDTH:0] tx_cnt;
    reg out;
    reg r_tx_busy;
    reg r_tx_done;

    assign tx = out;
    assign tx_busy = r_tx_busy;
    assign tx_done = r_tx_done; 
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end
    
    always @(*) begin
        next_state = current_state;
        case (current_state)
            IDLE: 
            begin
                if(start_bit) begin
                    next_state = START;
                end
            end
            START: 
            begin
                if(!out) begin
                    next_state = DATA;
                end
            end
            DATA: 
            begin
                if (&tx_cnt) begin
                    next_state = STOP;
                end
            end
            STOP: 
            begin
                if(out) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            out <= 1'b1;
            r_tx_busy <= 0;
            r_tx_done <= 0;
        end
        else begin
            case (current_state)
                IDLE: 
                    begin
                        out <= 1'b1;
                        r_tx_busy <= 0;
                        r_tx_done <= 0;
                    end
                START: 
                    begin
                        out <= 1'b0;
                        r_tx_busy <= 1;
                        r_tx_done <= 0;
                    end
                DATA: 
                    begin
                        out <= din[tx_cnt];
                        r_tx_busy <= 1;
                        r_tx_done <= 0;
                    end
                STOP: 
                    begin
                        out <= 1'b1;
                        r_tx_busy <= 0;
                        r_tx_done <= 1;
                    end
            endcase
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_cnt <= 0;
        end
        else begin
            if(current_state == DATA) begin
                tx_cnt <= tx_cnt + 1;
            end
            else begin
                tx_cnt <= 0;
            end
        end
    end
endmodule