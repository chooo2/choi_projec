// RX_READ.v : (UART_RX.v, RX_FIFO.v, READ_BUFF.v)
module RX_READ#(
    parameter ADDR_WIDTH            = 32,
    parameter DATA_WIDTH            = 8,
    parameter BAUDRATE              = 9600,
    parameter CLK_FREQ_MHZ          = 125
)(
    input                           clk,
    input                           rstn,
    input                           rx,
    input                           ready_out,
    output wire                     valid_out
    output wire                     uart_irq,
    output wire [DATA_WIDTH-1:0]    rx_data,
);
    wire [DATA_WIDTH-1:0] n_uart_fifo, n_fifo_buff;
    wire n_empty;
    wire not_empty = ~n_empty;
    wire n_rd_en;

    UART_RX#(
        .ADDR_WIDTH                 (ADDR_WIDTH     ),
        .DATA_WIDTH                 (DATA_WIDTH     ),
        .BAUDRATE                   (BAUDRATE       ),
        .CLK_FREQ_MHZ               (CLK_FREQ_MHZ   )
    )RX0(
        .clk                        (clk            ),
        .rstn                       (rstn           ),
        .rx                         (rx             ),
        .data_o                     (n_uart_fifo    ),
        .rx_done                    (uart_irq       ),
        .rx_busy                    (/* nc */       )
    );

    RX_FIFO#(
        .ADDR_WIDTH                 (ADDR_WIDTH     ),
        .DATA_WIDTH                 (DATA_WIDTH     )
    )RX1(
        .clk                        (clk            ),
        .rstn                       (rstn           ),
        .wr_en                      (uart_irq       ),
        .rd_en                      (n_rd_en        ),
        .wr_data                    (n_uart_fifo    ),
        .rd_data                    (n_fifo_buff    ),
        .full                       (/* nc */       ),
        .empty                      (n_empty        )
    );

    READ_BUFF#(
        .DATA_WIDTH                 (DATA_WIDTH     )
    )RX2(
        .clk                        (clk            ),
        .rstn                       (rstn           ),
        .data_i                     (n_fifo_buff    ),
        .data_o                     (rx_data        ),
        .valid_in                   (not_empty      ),
        .ready_in                   (n_rd_en        ),
        .ready_out                  (ready_out      ),
        .valid_out                  (valid_out      )
    );

endmodule
