module DATA_MUX(
    input [3:0] sel,
    output wire [7:0] dout
);
    reg [7:0] data;
    assign dout = data;
    always @(*) begin
        case(sel)
        4'b0000:
            begin
                data = 8'b0100_0001;  // ASCII(A)
            end
        4'b0001:
            begin
                data = 8'b0100_0010;  // ASCII(B)
            end
        4'b0010:
            begin
                data = 8'b0100_0011;  // ASCII(C)
            end
        4'b0011:
            begin
                data = 8'b0100_0100;  // ASCII(D)
            end
        4'b0100:
            begin
                data = 8'b0100_0101;  // ASCII(E)
            end
        4'b0101:
            begin
                data = 8'b0100_0110;  // ASCII(F)
            end
        4'b0110:
            begin
                data = 8'b0100_0111;  // ASCII(G)
            end
        4'b0111:
            begin
                data = 8'b0100_1000;  // ASCII(H)
            end
        4'b1000:
            begin
                data = 8'b0100_1001;  // ASCII(I)
            end
        4'b1001:
            begin
                data = 8'b0100_1010;  // ASCII(J)
            end
        4'b1010:
            begin
                data = 8'b0100_1011;  // ASCII(K)
            end
        4'b1011:
            begin
                data = 8'b0100_1100;  // ASCII(L)
            end
        4'b1100:
            begin
                data = 8'b0100_1101;  // ASCII(M)
            end
        4'b1101:
            begin
                data = 8'b0100_1110;  // ASCII(N)
            end
        4'b1110:
            begin
                data = 8'b0100_1111;  // ASCII(O)
            end
        4'b1111:
            begin
                data = 8'b0101_0000;  // ASCII(P)
            end
        endcase
    end
endmodule