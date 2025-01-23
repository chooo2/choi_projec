`timescale 1ns / 1ps
module test;

    reg clk;
    reg rstn;
    reg rx;
    reg pselx;
    wire uart_irq;
    wire tx;
    
    wire baudx16 = DUT.U0.RX0.baudx16;

    APB_UART DUT(
        .pclk(clk),
        .prstn(rstn),
        .pselx(pselx),
        .rx(rx),
        .uart_irq(uart_irq),
        .tx(tx)
    );

    initial begin
        clk = 0;
        rstn = 1;
        pselx = 1;
        #2
        rstn = 0;
        #3
        rstn = 1;
        
        uart_rx(8'ha0);
        #20
        uart_rx(8'hb1);
        #20
        uart_rx(8'hc2);
        #20
        uart_rx(8'hd3);
        #20
        uart_rx(8'he4);
        #20
        uart_rx(8'hf5);
        pselx = 0;
        #20
        uart_rx(8'ha6);
        #20
        uart_rx(8'hb7);
        #20
        uart_rx(8'hc8);
        #20
        uart_rx(8'hd9);
        #20
        uart_rx(8'hea);
        pselx = 1;
        #20
        uart_rx(8'hfb);
        #20
        uart_rx(8'hac);
        #20
        uart_rx(8'hbd);
        #20
        uart_rx(8'hce);
                pselx = 0;
        
        #500
        $finish;
    end
    
    task uart_rx;
        input [7:0]data;
        begin
        @(posedge clk);
        rx = 0;
        while(!baudx16) begin
            @(posedge clk);
        end
        @(posedge clk);
        rx = data[0];
        while(!baudx16) begin
            @(posedge clk);
        end
        @(posedge clk);
        rx = data[1];
        while(!baudx16) begin
            @(posedge clk);
        end
        @(posedge clk);
        rx = data[2];
        while(!baudx16) begin
            @(posedge clk);
        end
        @(posedge clk);
        rx = data[3];
        while(!baudx16) begin
            @(posedge clk);
        end
        @(posedge clk);
        rx = data[4];
        while(!baudx16) begin
            @(posedge clk);
        end
        @(posedge clk);
        rx = data[5];
        while(!baudx16) begin
            @(posedge clk);
        end
        @(posedge clk);
        rx = data[6];
        while(!baudx16) begin
            @(posedge clk);
        end
        @(posedge clk);
        rx = data[7];
        while(!baudx16) begin
            @(posedge clk);
        end
        @(posedge clk);
        rx = 1;
        while(!baudx16) begin
            @(posedge clk);
        end
        
        
        end
     endtask


    always #5 clk =~clk;

endmodule
