module ASC2B(
    input clk,
    input rst,
    input done,
    output wire num_done,
    output wire oper_done,

    input [7:0] data_i,
    output wire [7:0] num_o,
    output wire [3:0] oper_o
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
    // operator
    localparam equal = 8'd61;            // =
    localparam plus = 8'd43;             // +
    localparam minus = 8'd45;            // -
    localparam multiple = 8'd42;         // *
    localparam remain = 8'd37;           // % 나머지지
    localparam divide = 8'd47;           // / 몫

    reg lock;
    reg r_num_done;
    reg r_oper_done;
    reg [7:0] ASC2B_num;
    reg [7:0] ASC2B_op;
    assign num_o = ASC2B_num;
    assign oper_o = ASC2B_op;
    assign num_done = r_num_done;
    assign oper_done = r_oper_done;
    
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            ASC2B_num <= 0;
            ASC2B_op <= 0;
            r_num_done <= 0;
            r_oper_done <= 0;
            lock <= 0;
        end
        else begin
            if(r_num_done || r_oper_done) begin
//            if((r_num_done || r_oper_done) && (!done)) begin
                r_num_done <= 0;
                r_oper_done <= 0;
                lock <= 1;
            end
            else begin
                if(done && !lock) begin
                    case(data_i)
                        // Number
                        zero:
                            begin
                                ASC2B_num <= 8'd0;
                                r_num_done <= 1;
                            end
                        one:
                            begin
                                ASC2B_num <= 8'd1;
                                r_num_done <= 1;
                            end
                        two:
                            begin
                                ASC2B_num <= 8'd2;
                                r_num_done <= 1;
                            end
                        three:
                            begin
                                ASC2B_num <= 8'd3;
                                r_num_done <= 1;
                            end
                        four:
                            begin
                                ASC2B_num <= 8'd4;
                                r_num_done <= 1;
                            end
                        five:
                            begin
                                ASC2B_num <= 8'd5;
                                r_num_done <= 1;
                            end
                        six:
                            begin
                                ASC2B_num <= 8'd6;
                                r_num_done <= 1;
                            end
                        seven:
                            begin
                                ASC2B_num <= 8'd7;
                                r_num_done <= 1;
                            end
                        eigth:
                            begin
                                ASC2B_num <= 8'd8;
                                r_num_done <= 1;
                            end
                        nine:
                            begin
                                ASC2B_num <= 8'd9;
                                r_num_done <= 1;
                            end
                        // Operator
                        plus:
                            begin
                                ASC2B_op <= 4'b0000;
                                r_oper_done <= 1;
                            end
                        minus:
                            begin
                                ASC2B_op <= 4'b0001;
                                r_oper_done <= 1;
                            end
                        multiple:
                            begin
                                ASC2B_op <= 4'b0010;
                                r_oper_done <= 1;
                            end
                        remain:
                            begin
                                ASC2B_op <= 4'b0100;
                                r_oper_done <= 1;
                            end
                        divide:
                            begin
                                ASC2B_op <= 4'b1000;
                                r_oper_done <= 1;
                            end
                        equal:
                            begin
                                ASC2B_op = 4'b1111;
                                r_oper_done <= 1;
                            end
                    endcase
                end
                if(!done) begin
                    lock <= 0;
                end
            end 
        end
        end
endmodule