// TX_WRITE.v : (UART_TX.v, TX_FIFO.v, WRITE_BUFF.v)
module TX_WRITE#(
    parameter ADDR_WIDTH            = 32,
    parameter DATA_WIDTH            = 8,
    parameter BAUDRATE              = 9600,
    parameter CLK_FREQ_MHZ          = 125
)(
    input                           clk,
    input                           rstn,
    input                           valid_in,
    output wire                     ready_in,
    input [DATA_WIDTH-1:0]          tx_data,
    output wire                     tx
);
    wire [DATA_WIDTH-1:0] n_fifo_uart, n_buff_fifo;
    wire not_fifo_empty = ~fifo_empty;
    wire n_wr_en;
    wire tx_busy;
    wire not_tx_busy = ~tx_busy;
    wire tx_start = ((not_fifo_empty) && (not_tx_busy));

    WRITE_BUFF#(
        .DATA_WIDTH                 (DATA_WIDTH     )
    )TX0(
        .clk                        (clk            ),
        .rstn                       (rstn           ),
        .data_i                     (tx_data        ),
        .data_o                     (n_buff_fifo    ),
        .valid_in                   (valid_in       ),
        .ready_in                   (ready_in       ),
        .ready_out                  (not_fifo_empty ),
        .valid_out                  (n_wr_en        )
    );

    TX_FIFO#(
        .ADDR_WIDTH                 (ADDR_WIDTH     ),
        .DATA_WIDTH                 (DATA_WIDTH     )
    )TX1(
        .clk                        (clk            ),
        .rstn                       (rstn           ),
        .wr_en                      (n_wr_en        ),
        .rd_en                      (not_tx_busy    ),
        .wr_data                    (n_buff_fifo    ),
        .rd_data                    (n_fifo_uart    ),
        .full                       (/* nc */       ),
        .empty                      (fifo_empty     )
    );

    UART_TX#(
        .DATA_WIDTH                 (DATA_WIDTH     ),
        .BAUDRATE                   (BAUDRATE       ),
        .CLK_FREQ_MHZ               (CLK_FREQ_MHZ   )
    )TX2(
        .clk                        (clk            ),
        .rstn                       (rstn           ),
        .start                      (tx_start       ),
        .data_i                     (n_fifo_uart    ),
        .tx                         (tx             ),
        .tx_busy                    (tx_busy        ),
        .tx_done                    (/* nc */       )
    );

endmodule
