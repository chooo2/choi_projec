module ALU(
    input clk,
    input rst,
    input [7:0] num1,
    input [7:0] num2,
    input [3:0] oper,
    output wire [7:0] num_out
);
    reg [7:0] result;

    assign num_out = result;
    always @(*) begin
        case(oper)
            4'b0000: // Plus
                begin
                    result = num1 + num2;
                end
            4'b0001: // Minus
                begin
                    result = num1 - num2;
                end
            4'b0010: // Multiple
                begin
                    result = num1 * num2;
                end
            4'b0100: // Remain
                begin
                    result = num1 / num2;
                end
            4'b1000: // Divide
                begin
                    result = num1 % num2;
                end
        endcase
    end

endmodule