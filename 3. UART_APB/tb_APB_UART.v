`timescale 1ns / 1ps
module tb_TOP;

    reg pclk;
    reg prstn;
    reg [7:0] paddr;
    reg penable;
    reg pselx;
    reg pwrite;
    reg [7:0] pwdata;
    wire [7:0] prdata;
    reg rx;
    wire tx;

    wire baud = DUT.T0.U0.U0.baudx16;

    TEST_TOP DUT(
        .pclk(pclk),
        .prstn(prstn),
        .paddr(paddr),
        .penable(penable),
        .pselx(pselx),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .prdata(prdata),
        .rx(rx),
        .tx(tx)
    );

    initial begin
        pclk = 0;
        prstn = 0;
        pwrite = 0;
        pwdata = 8'b1000_1011;
        // IDLE
        pselx = 0;
        penable = 0;
        paddr = 8'b1011_0100;
        // Reset
        #5
        prstn = 1;

        #200
        uart_rx(8'ha1);


        // SETUP
        #200
        pselx = 1;

        // ACCESS
        #200
        penable = 1;
        
        // Delay
        #5000
        // ACCESS to SETUP
        penable = 0;
        paddr = 8'b1011_0000;
        pwrite = 1;

        // ACCESS
        #200
        penable = 1;
        
        #500
         $finish;
    end
task uart_rx;
        input [7:0]data;
        begin
            @(posedge pclk);
            rx = 0;
            while(!baud) begin
                @(posedge pclk);
            end
            @(posedge pclk);
            rx = data[0];
            while(!baud) begin
                @(posedge pclk);
            end
            @(posedge pclk);
            rx = data[1];
            while(!baud) begin
                @(posedge pclk);
            end
            @(posedge pclk);
            rx = data[2];
            while(!baud) begin
                @(posedge pclk);
            end
            @(posedge pclk);
            rx = data[3];
            while(!baud) begin
                @(posedge pclk);
            end
            @(posedge pclk);
            rx = data[4];
            while(!baud) begin
                @(posedge pclk);
            end
            @(posedge pclk);
            rx = data[5];
            while(!baud) begin
                @(posedge pclk);
            end
            @(posedge pclk);
            rx = data[6];
            while(!baud) begin
                @(posedge pclk);
            end
            @(posedge pclk);
            rx = data[7];
            while(!baud) begin
                @(posedge pclk);
            end
            @(posedge pclk);
            rx = 1;
            while(!baud) begin
                @(posedge pclk);
            end
        end
     endtask

    always #5 pclk = ~pclk;
endmodule
