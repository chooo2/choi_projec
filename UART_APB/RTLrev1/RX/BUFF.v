module BUFF#(
    parameter DATA_WIDTH = 8,
    parameter ADDR_WIDTH = 32,
    parameter PTR_WIDTH = 2//$clog2(ADDR_WIDTH)
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
    // Determine paramter /
    // BUFF
    wire handshake_in;
    wire handshake_out;

    // FIFO
    wire wr_en;
    wire rd_en;
    reg [DATA_WIDTH-1:0] wr_data;
    reg [DATA_WIDTH-1:0] rd_data;
    wire full;
    wire empty;
    reg [PTR_WIDTH:0] wr_ptr;
    reg [PTR_WIDTH:0] rd_ptr;
//    reg [DATA_WIDTH-1:0] memory [ADDR_WIDTH-1:0];
    reg [DATA_WIDTH-1:0] memory [3:0];
    
    assign wr_en = ((!full) & ready_in & valid_in); // 미정의됨
    assign rd_en = handshake_out;        // 미정의됨
    assign full = wr_ptr == {~rd_ptr[PTR_WIDTH], rd_ptr[PTR_WIDTH-1:0]};
    assign empty = (wr_ptr == rd_ptr);
    assign ready_in = !full; // full 이니까 데이터 못 받아요
    assign valid_out = !empty; // 비어있지 않은디 -> 데이터 있는디
    assign handshake_in = valid_in & ready_in;
    assign handshake_out = valid_out & ready_out;
    assign data_o = rd_data;
    // Determine pointer
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            wr_ptr <= 0;
        end
        else begin
            if(wr_en && (!full)) begin
                wr_ptr <= wr_ptr + 1;
            end
            else begin
                wr_ptr <= wr_ptr;
            end
        end
    end
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            rd_ptr <= 0;
        end
        else begin
            if(rd_en && (!empty)) begin
                rd_ptr <= rd_ptr + 1;
            end
            else begin
                rd_ptr <= rd_ptr;
            end
        end
    end
    // Determine Operation (Write, Read)
    always @(posedge clk) begin
        if(wr_en && (!full)) begin
            memory[wr_ptr[PTR_WIDTH-1:0]] <= data_i;
        end
    end
    always @(posedge clk) begin
        if(rd_en && (!empty)) begin
            rd_data = memory[rd_ptr[PTR_WIDTH-1:0]];
        end
    end

endmodule
