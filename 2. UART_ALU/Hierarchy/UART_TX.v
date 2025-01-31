module UART_TX(
    input clk,
    input rst,
    input [7:0] data_i,
    input start,
    output wire tx,
    output wire busy,
    output wire done
);
    localparam IDLE = 2'b00;
    localparam START = 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;

    reg [1:0] current_state;
    reg [1:0] next_state;
    reg [2:0] tx_cnt;
    reg r_done;
    reg r_busy;
    reg r_tx;
    reg [7:0] tx_byte;

    // Determine Done/Busy signal
    
    wire w_busy = (current_state != IDLE);
    assign busy = w_busy;
    assign done = r_done;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            r_done <= 0;
            r_busy <= 0;
        end
        else begin
            case(current_state)
            IDLE:
                begin
                    r_done <= 0;
                    r_busy <= 0;
                end
            START:
                begin
                    r_done <= 0;
                    r_busy <= 1;
                end
            DATA:
                begin
                    r_done <= 0;
                    r_busy <= 1;
                end
            STOP:
                begin
                    if(next_state == IDLE)
                        r_done <= 1;
                    r_busy <= 1;
                end
            endcase
        end
    end

    // Determine State
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        case(current_state)
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
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            tx_cnt <= 0;
        end else begin
            if (current_state == DATA | current_state == STOP)begin
                tx_cnt <= tx_cnt + 1;
            end
            else begin
                tx_cnt <= 0;
            end
        end
    end

        always @(posedge clk or posedge rst) begin
        if(rst) begin
            tx_byte <= 0;
        end else begin
            if (current_state == START)begin
                tx_byte <= data_i;
            end
        end
    end

    // Determine output data
    assign tx = r_tx;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            r_tx <= 0;
        end
        else begin
            case(current_state)
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
                    r_tx <= tx_byte[tx_cnt];
                end
            STOP:
                begin
                    r_tx <= 1;
                end
            endcase
        end
    end
endmodule