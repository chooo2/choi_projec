module UART#(
    parameter CLK_FREQ_MHZ = 125,
    parameter BAUDRATE = 9600,
    parameter DATA_LENGTH = 8
)(
    input clk,
    input rst,
    input button_mux,
    input button_rx,
    input rx,
    input [3:0] sel_data,
    output wire tx,
    output wire tx_busy,
    output wire tx_done,
    output wire rx_busy,
    output wire rx_done
);
    
    wire [7:0] rx_data_o, mux_data_o, data_o;
    wire tx_clk, rx_clk;
    wire start_bit;

    UART_RX#(
        .DATA_LENGTH    (   DATA_LENGTH     )
    )U0(
        .clk            (   rx_clk          ),
        .rst            (   rst             ),
        .rx             (   rx              ),
        .data           (   rx_data_o       ),
        .done           (   rx_busy         ),
        .busy           (   rx_done         )
    );

    UART_TX #(
        .DATA_LENGTH    (   DATA_LENGTH     )
    )U1(
    .clk                (   tx_clk          ),  // clock
    .rst                (   rst             ),  // reset
    .din                (   data_o          ),
    .start_bit          (   start_bit       ),
    .tx                 (   tx              ),
    .tx_busy            (   tx_busy         ),
    .tx_done            (   tx_done         )
    );

    DATA_MUX U2(
    .sel                (   sel_data        ),
    .dout               (   mux_data_o      )
    );
    
    BAUD_GENERATOR #(
        .CLK_FREQ_MHZ   (   CLK_FREQ_MHZ    ),
        .BAUDRATE       (   BAUDRATE        )
    )U3(
    .clk                (   clk             ),
    .rst                (   rst             ),
    .tx_clk             (   tx_clk          ),
    .rx_clk             (   rx_clk          )
    );

    uart_control #(
        .DATA_LENGTH    (   DATA_LENGTH     )
    )U4(
        .clk            (   tx_clk          ),
        .rst            (   rst             ),
        .button_mux     (   button_mux      ),
        .button_rx      (   button_rx       ),
        .mux_data       (   mux_data_o      ),
        .rx_data        (   rx_data_o       ),
        .data           (   data_o          ),
        .start          (   start_bit       )
    );

endmodule