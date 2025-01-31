module SKID_BUFF(
    input clk,
    input rst,
    input [7:0] data_i,
    output wire [7:0] data_o,

    input valid_in,
    output wire ready_in,
    input ready_out,
    output wire valid_out
);

    reg [7:0] buffer;
    reg hv_data;
    wire handshake_in = valid_in & ready_in;

    assign ready_in = ~hv_data;
    assign valid_out = hv_data;
    assign data_o = buffer;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
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

    always @(posedge clk) begin
        if(~hv_data) begin
            buffer <= data_i;
        end
    end

endmodule