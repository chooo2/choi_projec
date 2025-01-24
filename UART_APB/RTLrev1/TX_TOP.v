module TOP(
    input clk,
    input rstn,
    output wire tx,
    input [7:0] data_i,
    input valid_in,
    output wire ready_in
);
    wire n_valid_out;
    wire n_ready_out;
    wire tx_start;
    wire tx_done;
    wire tx_busy;
    wire [7:0] data;
    
    assign tx_start = ((!tx_busy) && n_valid_out);
    assign n_ready_out = (!tx_busy);

    UART_TX U0(
        .clk(clk),
        .rstn(rstn),
        .tx(tx),
        .start(tx_start),
        .data_i(data),
        .tx_done(tx_done),
        .tx_busy(tx_busy)
    );

    BUFF U1(
        .clk(clk),
        .rstn(rstn),
        .data_i(data_i),
        .data_o(data),
        .valid_in(valid_in),
        .ready_in(ready_in),
        .valid_out(n_valid_out),
        .ready_out(n_ready_out)
    );

endmodule
