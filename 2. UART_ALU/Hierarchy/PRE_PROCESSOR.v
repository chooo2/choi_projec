module PRE_PROCESSOR(
    input clk,
    input rst,
    input [7:0] num_i,
    input [3:0] oper_i,
    input num_in,
    input oper_in,
    output wire [7:0] number_1,
    output wire [7:0] number_2,
    output wire [3:0] operation,
    output wire done
);

    reg en_num1;
    reg en_num2;
    reg en_op1;
    reg en_op2;
    reg r_done;

    reg [7:0] num1;
    reg [7:0] num2;
    reg [3:0] oper;
    reg [1:0] num_cnt;

    assign number_1 = num1;
    assign number_2 = num2;
    assign operation = oper;
    assign done = r_done;
    // Determine enable / done
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            en_num1 <= 1;
            en_num2 <= 0;
            en_op1 <= 0;
            en_op2 <= 0;
            r_done <= 0;
            num_cnt <= 0;
        end
        else begin
// number 1
            if(en_num1) begin
                if(num_in) begin
                    en_op1 <= 1;
                    num_cnt <= num_cnt + 1;
                end
                else if((num_cnt == 2'b10) || (oper_in)) begin
                    en_num1 <= 0;
                    num_cnt <= 0;
                end
            end
// operator
            if(en_op1) begin
                if(oper_in) begin
                    en_num2 <= 1;
                    en_op1 <= 0;
                end  
            end
// number 2
            if(en_num2) begin
                if(num_in) begin
                    en_op2 <= 1;
                    num_cnt <= num_cnt + 1;
                end
                //else if(oper_i == 4'b1111) begin
                //    r_done <= 1;
                //end
                else if((num_cnt == 2'b10) || (oper_in))begin
                    num_cnt <= 0;
                    en_num2 <= 0;
                    // r_done <= 1;
                end
            end
// operator: equal
            if(en_op2) begin
                if(oper_in) begin
                    r_done <= 1;
                    en_op2 <= 0;
                end
            end
// Wait for initial state again
            if(r_done) begin
                r_done <= 0;
                en_num1 <= 1;
                en_num2 <= 0;
                en_op1 <= 0;
                en_op2 <= 0;
            end
        end
    end

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            num1 <= 0;
            num2 <= 0;
            oper <= 0;
        end
        else begin
// number 1
            if(en_num1 && num_in) begin
                if(num_cnt == 2'b00) begin
                    num1 <= num_i;
                end
                else if(num_cnt == 2'b01) begin
                    num1 <= num1 * 4'd10 + num_i;
                end
                else if(num_cnt == 2'b10) begin
                    num1 <= num1 * 4'd10 + num_i;
                end
            end
// operator
            if(en_op1) begin
                oper = oper_i;
            end
// number 2
            if(en_num2 && num_in) begin
                if(num_cnt == 2'b00) begin
                    num2 <= num_i;
                end
                else if(num_cnt == 2'b01) begin
                    num2 <= num2 * 4'd10 + num_i;
                end
                else if(num_cnt == 2'b10) begin
                    num2 <= num2 * 4'd10 + num_i;
                end
            end
        end
    end

endmodule