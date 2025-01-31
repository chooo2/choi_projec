// APB_UART.v : Most TOP Module
module APB_UART #(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8
)(
    input pclk,
    input prstn,
    input [ADDR_WIDTH-1:0] paddr,
    input penable,
    input pselx,
    input pwrite,
    input [DATA_WIDTH-1:0] pwdata,
    output wire pready,
    output wire [DATA_WIDTH-1:0] prdata,
    output wire pslverr,
    input rx,
    output wire tx
);
    wire rx_ready_out;
    wire rx_valid_out;
    wire tx_valid_in;
    wire tx_ready_in;

    wire ready_out;
    wire valid_out;
    wire ready_in;
    wire valid_in;

    assign rx_valid_out = valid_out;
    assign ready_out = rx_ready_out;
    assign valid_in = tx_valid_in;
    assign tx_ready_in = ready_in;

    wire [DATA_WIDTH-1:0] rx_data;
    wire [DATA_WIDTH-1:0] rx_out;
    wire [DATA_WIDTH-1:0] tx_data;
    wire [DATA_WIDTH-1:0] tx_in;

    assign rx_data = rx_out;
    assign tx_in = tx_data;

    APB#(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    )S0(
        .pclk(pclk),
        .prstn(prstn),
        .paddr(paddr),
        .penable(penable),
        .pselx(pselx),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .pready(pready),
        .prdata(prdata),
        .pslverr(pslverr),
        .rx_valid(rx_valid_out),
        .rx_ready(rx_ready_out),
        .rx_data(rx_data),
        .tx_ready(tx_ready_in),
        .tx_valid(tx_valid_in),
        .tx_data(tx_data)
    );

    RX U0(
        .clk(pclk),
        .rstn(prstn),
        .rx(rx),
        .data_o(rx_out),
        .valid_out(valid_out),
        .ready_out(ready_out)
    );

    TX U1(
        .clk(pclk),
        .rstn(prstn),
        .tx(tx),
        .data_i(tx_in),
        .valid_in(valid_in),
        .ready_in(ready_in)
    );
endmodule