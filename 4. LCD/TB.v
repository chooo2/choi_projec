`timescale 1ns / 1ps
module tb_FRAME_1_ROW;

    reg clk;
    reg rst;
    reg en;
    wire frame;

    FRAME_1_ROW DUT(
        .clk(clk),
        .rst(rst),
        .en(en),
        .frame(frame)
    );
    initial begin
        clk = 0;
        rst = 1;
        en = 0;

        #5
        rst = 0;
        en = 1;
    end

    always #5 clk = ~clk;

endmodule
