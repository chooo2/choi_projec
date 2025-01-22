`timescale 1ns / 1ps

module test_bench;
    // & APB
    reg pclk;
    reg prstn;
    reg paddr;
    reg penable;
    reg pselx;
    reg pwrite;
    reg pwdata;
    wire pready;
    wire prdata;
    wire pslverr;
    // UART
    reg rx;
    wire uart_irq;
    wire tx;

    wire next_bit = DUT.U0.RX0.baud;
    
    // & APB
    APB_UART DUT(
        .pclk(pclk),
        .prstn(prstn),
        .paddr(paddr),
        .penable(penable),
        .pselx(pselx),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .pready(pready),
        .prdata(prdata),
        .pslverr(pslverr),
        // UART
        .rx(rx),
        .uart_irq(uart_irq),
        .tx(tx)
    );
    
    initial begin
        rx = 1;
        pclk = 0;
        prstn = 1;
        pselx = 0;
        #2
        prstn = 0;
        #3
        prstn = 1;

        #100
        uart_rx(8'b1100_0101); // 8'hc5
        #200
        uart_rx(8'b0000_1101); // 8'h0d
        #200
        uart_rx(8'b1110_1001); // 8'he9
        #200
        uart_rx(8'b1010_0001); // 8'ha1
        #200
        uart_rx(8'b1111_0000); // 8'hf0
        #200
        uart_rx(8'b0000_1111); // 8'h0f
        #200
        uart_rx(8'b1111_1111); // 8'hff
        #200
        uart_rx(8'b0000_0000); // 8'h00
        #500
        $finish;

    end
    task uart_rx;
        input [7:0]data;
        begin
        @(posedge pclk);
        rx = 0;
        while(!next_bit) begin
            @(posedge pclk);
        end
        @(posedge pclk);
        rx = data[0];
        while(!next_bit) begin
            @(posedge pclk);
        end
        @(posedge pclk);
        rx = data[1];
        while(!next_bit) begin
            @(posedge pclk);
        end
        @(posedge pclk);
        rx = data[2];
        while(!next_bit) begin
            @(posedge pclk);
        end
        @(posedge pclk);
        rx = data[3];
        while(!next_bit) begin
            @(posedge pclk);
        end
        @(posedge pclk);
        rx = data[4];
        while(!next_bit) begin
            @(posedge pclk);
        end
        @(posedge pclk);
        rx = data[5];
        while(!next_bit) begin
            @(posedge pclk);
        end
        @(posedge pclk);
        rx = data[6];
        while(!next_bit) begin
            @(posedge pclk);
        end
        @(posedge pclk);
        rx = data[7];
        while(!next_bit) begin
            @(posedge pclk);
        end
        @(posedge pclk);
        rx = 1;
        while(!next_bit) begin
            @(posedge pclk);
        end
        
        
        end
     endtask
    always #5 pclk = ~pclk;

endmodule
