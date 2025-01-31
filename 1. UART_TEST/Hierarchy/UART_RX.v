module uart_rx#(
    parameter DATA_LENGTH = 8,
    parameter DATA_LENGTH_WIDTH = $clog2(DATA_LENGTH),
    parameter MAX_CNT = 4'd8
)(
    input clk,
    input rst,
    input rx,
    output wire [DATA_LENGTH-1:0] data,
    output wire rx_done,
    output wire rx_busy
);
    localparam IDLE = 2'b00;
    localparam START= 2'b01;
    localparam DATA = 2'b10;
    localparam STOP = 2'b11;

    reg [DATA_LENGTH-1:0] memory;
    reg [1:0] current_state;
    reg [1:0] next_state;
    reg [DATA_LENGTH_WIDTH-1:0] rx_cnt;
    reg [3:0] catch_cnt;
    wire catch;
    assign data = memory;

    reg r_rx_done;
    reg r_rx_busy;

    assign rx_done = r_rx_done;
    assign rx_busy = r_rx_busy;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            r_rx_done <= 0;
            r_rx_busy <= 0;
        end
        else begin
            case(current_state)
            IDLE:
                begin
                    r_rx_done <= 0;
                    r_rx_busy <= 0;
                end
            START:
                begin
                    r_rx_done <= 0;
                    r_rx_busy <= 1;
                end
            DATA:
                begin
                    r_rx_done <= 0;
                    r_rx_busy <= 1;
                end
            STOP:
                begin
                    r_rx_done <= 1;
                    r_rx_busy <= 0;
                end
            endcase
        end
    end

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
            if(!rx) begin
                next_state = START;
            end
        end
        START:
        begin
            if((!rx) && (&catch_cnt)) begin
                next_state = DATA;
            end
        end
        DATA:
        begin
            if((&rx_cnt) && (&catch_cnt)) begin
                next_state = STOP;
            end
        end
        STOP:
        begin
            if((rx) && (&catch_cnt)) begin
                next_state = IDLE;
            end
        end
        endcase
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            memory <= 0;
        end
        else if((current_state == DATA) && (catch)) begin
            memory[rx_cnt] <= rx;
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            rx_cnt <= 0;
        end
        else begin
            if(current_state == DATA) begin
                if(&catch_cnt) begin
                    rx_cnt <= rx_cnt + 1;
                end
                else begin
                    rx_cnt <= rx_cnt;
                end
            end
            else begin
                rx_cnt <= 0;
            end
        end
    end

    assign catch = (catch_cnt == 4'd8) ? 1'b1 : 1'b0;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            catch_cnt <= 0;
        end
        else begin
            if ((&catch_cnt) || (current_state != next_state))begin
                catch_cnt <= 0;
            end            
            else if(!(current_state == IDLE)) begin
                catch_cnt <= catch_cnt + 1;
            end
        end
    end
endmodule