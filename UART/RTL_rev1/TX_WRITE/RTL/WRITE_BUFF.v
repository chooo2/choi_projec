module WRITE_BUFF#(
    parameter DATA_WIDTH = 8
)(
    input clk,
    input rstn,
    input [DATA_WIDTH-1:0] data_i,
    output wire [DATA_WIDTH-1:0] data_o,
    input valid_in,
    output wire ready_in,
    input ready_out,
    output wire valid_out
);
    // Determine paramter //
    wire handshake_in = valid_in & ready_in;

    reg [7:0] buffer;
    reg hv_data;

    assign ready_in = ~hv_data;
    assign valid_out = hv_data;
    assign data_o = buffer;
    assign start = valid_out & ready_out;

    // Ready to process data
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            hv_data <= 0;
        end
        else begin
            if(~hv_data) begin
                hv_data <= handshake_in;
            end
            else if(ready_out) begin
                hv_data <= 0;
            end
        end
    end
    // Determine data transmitt
    always @(posedge clk) begin
        if(~hv_data) begin
            buffer <= data_i;
        end
    end
endmodule
