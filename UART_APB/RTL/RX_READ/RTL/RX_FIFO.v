module RX_FIFO#(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 8,
    parameter PTR_WIDTH = $clog2(ADDR_WIDTH)
)(
    input clk,
    input rstn,
    input wr_en,
    input rd_en,
    input [DATA_WIDTH -1:0] wr_data,
    output wire [DATA_WIDTH-1:0] rd_data,
    output wire full,
    output wire empty
);
    // Determine paramter //
    reg [DATA_WIDTH-1:0]            memory [ADDR_WIDTH-1:0];
    reg [PTR_WIDTH:0]               wr_ptr;
    reg [PTR_WIDTH:0]               rd_ptr;
    reg [DATA_WIDTH-1:0]            r_rd_data;

    assign rd_data = r_rd_data;
    assign full = ~(wr_ptr == (rd_ptr - 1));
    assign empty = (wr_ptr == rd_ptr);

    // Write
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            wr_ptr <= 0;
        end
        else begin
            if(wr_en) begin
                wr_ptr <= wr_ptr + 1;
            end
            else begin
                wr_ptr <= wr_ptr;
            end
        end
    end
    
    always @(posedge clk) begin
        if(wr_en) begin
            memory[wr_ptr[PTR_WIDTH-1:0]] <= wr_data;
        end
    end

    // Read
    always @(posedge clk or negedge rstn) begin
        if(!rstn) begin
            rd_ptr <= 0;
            r_rd_data <= 0;
        end
        else begin
            if(rd_en && (!empty)) begin
                rd_ptr <= rd_ptr + 1;
                r_rd_data <= memory[rd_ptr[PTR_WIDTH-1:0]];
            end
            else begin
                rd_ptr <= rd_ptr;
            end
        end
    end
endmodule
