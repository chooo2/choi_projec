module APB_SLAVEx#(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 8,
    parameter PTR_WIDTH = $clog2(ADDR_WIDTH)
)(
    // & MASTER
    input                           pclk,
    input                           prstn,
    input [ADDR_WIDTH-1:0]          paddr,
    input                           penable,
    input                           pselx,
    input                           pwrite,
    input [DATA_WIDTH-1:0]          pwdata,
    output wire                     pready,
    output wire [DATA_WIDTH-1:0]    prdata,
    output wire                     pslverr,
    // & SLAVE - UART rx
    input                           rx_valid,
    output wire                     rx_ready,
    input [DATA_WIDTH-1:0]          rx_data,
    // & SLAVE - UART tx
    input                           tx_ready,
    output wire                     tx_valid,
    output wire [DATA_WIDTH-1:0]    tx_data
);
    // Dertmine parameter
    reg [DATA_WIDTH-1:0] memory [(1<<ADDR_WIDTH)-1:1];
    reg r_pready;
    reg [DATA_WIDTH-1:0] rd_buff;
    reg r_rx_ready;
    reg r_tx_valid;
    reg [DATA_WIDTH-1:0] r_rx_data;
    reg [DATA_WIDTH-1:0] r_tx_data;
    reg [PTR_WIDTH:0] rx_ptr;
    reg [PTR_WIDTH:0] tx_ptr;
    reg apb_memory_empty;
    reg [DATA_WIDTH-1:0] wr_buff;

    assign pready = r_pready;
    assign prdata = rd_buff;
    assign pslverr = 1'b1;  // default for a while
    assign rx_ready = r_rx_ready;
    assign tx_valid = r_tx_valid;
    assign rx_data = r_rx_data;
    assign tx_data = r_tx_data;

    // Opertion with Master //
    // Determine Ready
    always @(*) begin
        if(pselx) begin
            r_pready = penable;
        end
        else begin
            r_pready = 0;
        end
    end
    // Write operation
    always @(*) begin
        wr_buff = pwdata;
    end
    always @(posedge pclk) begin
        if((pwrite) && (r_pready)) begin
            memory[paddr] <= wr_buff;
        end
    end
    // Read operation
    always @(posedge pclk or negedge prstn) begin
        if(!prstn) begin
            rd_buff <= 0;
        end
        else begin
            if((!pwrite) && (r_pready)) begin
                rd_buff <= memory[paddr];
            end
        end
    end

    // Operation with UART //
    // Determine the state in which Uart Rx data can be received
    always @(posedge pclk or negedge prstn) begin
        if(!prstn) begin
            r_rx_ready <= 0;
        end
        else begin
            if((rx_valid) && (!pselx)) begin
                r_rx_ready <= 1;
            end
            else begin
                r_rx_ready <= 0;
            end
        end
    end
    // Determine UART RX data storage location: FIFO
    always @(posedge pclk or negedge prstn) begin
        if(!prstn) begin
            rx_ptr <= 0;
        end
        else begin
            if((r_rx_valid) && (!pselx)) begin
                rx_ptr <= rx_ptr + 1;
                memory[rx_ptr[PTR_WIDTH-1:0]] <= rx_data;
            end
            else begin
                rx_ptr <= rx_ptr;
            end
        end
    end

    // Determine the state in which Uart tx data can be transmitted
    always @(posedge pclk or negedge prstn) begin
        if(!prstn) begin
            r_tx_valid <= 0;
        end
        else begin
            if((!pselx) && (!apb_memory_empty)) begin
                r_tx_valid <= 1;
            end
            else begin
                r_tx_valid <= 0;
            end
        end
    end
    // Determine UART TX data storage location: FIFO
    always @(posedge pclk or negedge prstn) begin
        if(!prstn) begin
            tx_ptr <= 0;
        end
        else begin
            if((r_tx_valid) && (!pselx) && (!apb_memory_empty)) begin
                tx_ptr <= tx_ptr + 1;
                r_tx_data <= memory[tx_ptr[PTR_WIDTH-1:0]];
            end
            else begin
                tx_ptr <= tx_ptr;
            end
        end
    end
    // Determine memoey state
    always @(posedge pclk or negedge prstn) begin
        if(!prstn) begin
            apb_memory_empty <= 1;
        end
        else begin
            if(!(wr_ptr == rd_ptr)) begin
                apb_memory_empty <= 0;
            end
            else begin
                apb_memory_empty <= 1;
            end
        end
    end
endmodule
