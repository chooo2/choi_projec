module B2ASC(
    input enable,
    input [7:0] data_i,
    output wire [7:0] data_o
);
    // number
    localparam zero = 8'd48;             // 0
    localparam one = 8'd49;              // 1
    localparam two = 8'd50;              // 2
    localparam three = 8'd51;            // 3
    localparam four = 8'd52;             // 4
    localparam five = 8'd53;             // 5
    localparam six = 8'd54;              // 6
    localparam seven = 8'd55;            // 7
    localparam eigth = 8'd56;            // 8
    localparam nine = 8'd57;             // 9

    reg [7:0] B2ASC_num;
    assign data_o = B2ASC_num;
    always @(*) begin
        if(enable) begin
        case(data_i)
            8'd0:
                begin
                    B2ASC_num = zero;
                end
            8'd1:
                begin
                    B2ASC_num = one;
                end
            8'd2:
                begin
                    B2ASC_num = two;
                end
            8'd3:
                begin
                    B2ASC_num = three;
                end
            8'd4:
                begin
                    B2ASC_num = four;
                end
            8'd5:
                begin
                    B2ASC_num = five;
                end
            8'd6:
                begin
                    B2ASC_num = six;
                end
            8'd7:
                begin
                    B2ASC_num = seven;
                end
            8'd8:
                begin
                    B2ASC_num = eigth;
                end
            8'd9:
                begin
                    B2ASC_num = nine;
                end
        endcase
        end
    end
endmodule