module POST_PROCESSOR(
    input clk,
    input rst,
    input [7:0] data_i,
    input catch,
//    output wire [7:0] data1,
//    output wire [7:0] data10,
//    output wire [7:0] data100,
    // input start,
    // output wire done,
    input ready,
    output valid,
    output wire [7:0] data_o
);
    reg r_done;
    reg [7:0] mem_1;
    reg [7:0] mem_10;
    reg [7:0] mem_100;
    
    reg [7:0] r_data1;
    reg [7:0] r_data10;
    reg [7:0] r_data100;
    reg [7:0] r_data_o;

    wire handshake = valid & ready;

    assign data_o = r_data_o;
    assign done = r_done;
    
    
    // reg hold;
    // Determine digit classification


    always @(*) begin
        // if(!hold) begin
            mem_100 = data_i / 8'b0110_0100;
            mem_10 = (data_i - mem_100 * 8'b0110_0100) / 4'b1010;
            mem_1 = (data_i - mem_10 * 4'b1010) - mem_100;
        // end
    end

    always @(*) begin
        if(catch) begin
            r_data1 = mem_1;
            r_data10 = mem_10;
            r_data100 = mem_100;
        end
        else begin
            r_data1 = r_data1;
            r_data10 = r_data10;
            r_data100 = r_data100;
        end
    end
    // MUX.
    reg [1:0] cnt;
    reg hold;
    // Data check
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            hold <= 0;
            cnt <= 0;
            r_done <= 0;
        end
        else begin
            if(~hold) begin
                if(catch) begin
                // xxx
                if(r_data100 == 0 ) begin
                    if(r_data10 ==0) begin
                        cnt <= 2'b01;
                    end else
                        cnt <= 2'b10;
                end else begin
                    cnt <= 2'b11;
                end
                hold <= 1;
                end
            end
            else if(handshake) begin
                if( cnt == 0) 
                    hold <= 0;
                else
                    cnt <= cnt - 1;
            end



            // else if(start) begin
            //     if(cnt == 2'b11) begin
            //         r_data_o <= r_data100;
            //         cnt <= cnt - 1;
            //         r_done <= 1;
            //     end
            //     else if(cnt == 2'b10) begin
            //         r_data_o <= r_data10;
            //         cnt <= cnt - 1;
            //         r_done <= 1;
            //     end
            //     else if(cnt == 2'b01) begin
            //         r_data_o <= r_data1;
            //         cnt <= cnt - 1;
            //         r_done <= 1;
            //     end
            //     else begin
            //         hold <= 0;
            //     end
            // end
            // else begin
            //     r_done <= 0;
            // end
        end
    end

       always @(posedge clk or posedge rst) begin
        if(rst) begin
               r_data_o <= 0;
        end else begin
            case(cnt)
                2'b11 : r_data_o <=r_data100;
                2'b10 : r_data_o <=r_data10;
                2'b01 : r_data_o <=r_data1;
                2'b00 : r_data_o <= 0;
            endcase
        end
       end


        reg r_valid;
        always @(posedge clk or posedge rst) begin
        if(rst) begin
            r_valid <= 0;
        end else begin
            r_valid <= (cnt !=0);
        end
        end

       assign valid = r_valid;//(cnt!=0);

endmodule