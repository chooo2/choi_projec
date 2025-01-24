module TOP(
    input clk,
    input rstn,
    input rx,

    output wire [7:0] data_o,
    output wire valid_out,
    input ready_out
);
    wire rx_done;
    wire rx_busy;
    wire rx_en;
    wire n_valid_in;
    wire n_ready_in;
    wire [7:0] data;

    assign n_valid_in = rx_done;
    assign rx_en = rx_ready;

    UART_RX U0(
        .clk(clk),
        .rstn(rstn),
        .rx(rx),
        .en(rx_en),
        .data_o(data),
        .rx_done(rx_done),
        .rx_busy()
    );

    BUFF U1(
        .clk(clk),
        .rstn(rstn),
        .data_i(data),
        .data_o(data_o),
        .valid_in(n_valid_in),
        .ready_in(rx_ready),
        .valid_out(valid_out),
        .ready_out(ready_out)
    );

endmodule
