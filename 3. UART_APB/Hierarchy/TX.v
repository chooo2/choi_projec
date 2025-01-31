// TX.v : UART_TX.v + TX_BUFF.v
module TX(
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
    reg start_dly;
    wire tx_done;
    wire tx_busy;
    wire [7:0] data;
    
    assign tx_start = ((!tx_busy) && n_valid_out);
    assign n_ready_out = (!tx_busy);
    
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            start_dly <= 0;
        end
        else begin
            if(tx_start) begin
                start_dly <= 1;
            end
            else begin
                start_dly <= 0;
            end
        end
    end
    
    UART_TX U0(
        .clk(clk),
        .rstn(rstn),
        .tx(tx),
        .start(start_dly),
        .data_i(data),
        .tx_done(tx_done),
        .tx_busy(tx_busy)
    );
    TX_BUFF U1(
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