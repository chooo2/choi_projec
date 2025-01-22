module APB_UART#(
    parameter ADDR_WIDTH            = 32,
    parameter DATA_WIDTH            = 8,
    parameter BAUDRATE              = 9600,
    parameter CLK_FREQ_MHZ          = 125
)(
    // & APB
    input                           pclk,
    input                           prstn,
    input [ADDR_WIDTH-1:0]          paddr,
    input                           penable,
    input                           pselx,
    input                           pwrite,
    input [DATA_WIDTH-1:0]          pwdata,
    output wire                     pready,
    output wire [DATA_WIDTH-1:0]    prdata,
    output wire                     pslverr,
    // UART
    input                           rx,
    output wire                     uart_irq,
    output wire                     tx
);
    wire [7:0] tx_data;
    wire [7:0] rx_data;
    wire n_rx_v;
    wire n_rx_r;
    wire n_tx_v;
    wire n_tx_r;

    APB_SLAVEx#(
        .ADDR_WIDTH                 (ADDR_WIDTH     ),
        .DATA_WIDTH                 (DATA_WIDTH     )
    )S0(
        // & MASTER
        .pclk                       (pclk           ),
        .prstn                      (prstn          ),
        .paddr                      (paddr          ),
        .penable                    (penable        ),
        .pselx                      (pselx          ),
        .pwrite                     (pwrite         ),
        .pwdata                     (pwdata         ),
        .pready                     (pready         ),
        .prdata                     (prdata         ),
        .pslverr                    (pslverr        ),
        // & SLAVE - UART rx
        .rx_valid                   (n_rx_v         ),
        .rx_ready                   (n_rx_r         ),
        .rx_data                    (rx_data        ),
        // & SLAVE - UART tx
        .tx_ready                   (n_tx_r         ),
        .tx_valid                   (n_tx_v         ),
        .tx_data                    (tx_data        )
    );

    RX_READ#(
        .ADDR_WIDTH                 (ADDR_WIDTH     ),
        .DATA_WIDTH                 (DATA_WIDTH     ),
        .BAUDRATE                   (BAUDRATE       ),
        .CLK_FREQ_MHZ               (CLK_FREQ_MHZ   )
    )U0(
        .clk                        (pclk           ),
        .rstn                       (prstn          ),
        .rx                         (rx             ),
        .ready_out                  (n_rx_r         ),
        .valid_out                  (n_rx_v         ),
        .uart_irq                   (uart_irq       ),
        .rx_data                    (rx_data        )
    );

    TX_WRITE#(
        .ADDR_WIDTH                 (ADDR_WIDTH     ),
        .DATA_WIDTH                 (DATA_WIDTH     ),
        .BAUDRATE                   (BAUDRATE       ),
        .CLK_FREQ_MHZ               (CLK_FREQ_MHZ   )
    )U1(
        .clk                        (pclk           ),
        .rstn                       (prstn          ),
        .valid_in                   (n_tx_v         ),
        .ready_in                   (n_tx_r         ),
        .tx_data                    (tx_data        ),
        .tx                         (tx             )
    );

endmodule
