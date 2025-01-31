module BAUD_GENERATOR#(
    parameter CLK_FREQ_MHZ = 125,
    parameter BAUDRATE = 9600, //115200;
    parameter TX_BAUD_COUNT = CLK_FREQ_MHZ * 1_000_000 / (BAUDRATE),
    parameter RX_BAUD_COUNT = CLK_FREQ_MHZ * 1_000_000 / (BAUDRATE * 16),
    parameter TX_BAUD_COUNT_WIDTH = $clog2(TX_BAUD_COUNT),
    parameter RX_BAUD_COUNT_WIDTH = $clog2(RX_BAUD_COUNT)
)(
    input clk,
    input rst,
    output wire tx_clk,
    output wire rx_clk
);
    reg [TX_BAUD_COUNT_WIDTH:0] tx_cnt;
    reg [RX_BAUD_COUNT_WIDTH:0] rx_cnt;
    reg tx_sys_clk;
    reg rx_sys_clk; 
    
    assign tx_clk = tx_sys_clk;
    assign rx_clk = rx_sys_clk;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            tx_cnt <= 0;
            rx_cnt <= 0;
            tx_sys_clk <= 0;
            rx_sys_clk <= 0;
        end
        else begin
            // TX
            if(tx_cnt == ((TX_BAUD_COUNT/2)-1)) begin
                tx_cnt <= 0;
                tx_sys_clk <= ~tx_sys_clk;
            end
            else begin
                tx_cnt <= tx_cnt + 1'b1;
            end
            // RX
            if(rx_cnt == ((RX_BAUD_COUNT/2)-1)) begin
                rx_cnt <= 0;
                rx_sys_clk <= ~rx_sys_clk;
            end
            else begin
                rx_cnt <= rx_cnt + 1'b1;
            end
        end
    end
endmodule
