// APB.v : APB Bridge
module APB#(
    parameter ADDR_WIDTH = 8,
    parameter DATA_WIDTH = 8,
    parameter PTR_WIDTH = $clog2(ADDR_WIDTH)
)(
    // AMBA
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
    // UART
    input                           rx_valid,
    output wire                     rx_ready,
    input [DATA_WIDTH-1:0]          rx_data,
    input                           tx_ready,
    output wire                     tx_valid,
    output wire [DATA_WIDTH-1:0]    tx_data
);
    localparam IDLE = 2'b00;
    localparam SETUP = 2'b01;
    localparam ACCESS = 2'b10;
    localparam READY = 2'b11;

    reg [DATA_WIDTH-1:0] RAM [14:0];
    reg [3:0] SEL_ADDR;
    reg [3:0] CMD;

    wire full;
    wire empty;
    reg [PTR_WIDTH:0] rd_ptr;
    reg [PTR_WIDTH:0] wr_ptr;
    reg r_rx_ready;
    reg r_tx_valid;
    reg [1:0] curr_state;
    reg [1:0] next_state;
    reg [2:0] acc_cnt;
    reg r_pready;
    reg [DATA_WIDTH-1:0] r_prdata;
    reg [DATA_WIDTH-1:0] r_tx_data;

    assign rx_ready = r_rx_ready;
    assign tx_valid = r_tx_valid;
    assign prdata = r_prdata;
    assign tx_data = r_tx_data;
    
    // Determine CMD
    always @(posedge pclk) begin
        CMD <= paddr[3:0];
    end
    // Determine SEL_ADDR
    always @(posedge pclk) begin
        SEL_ADDR <= paddr[7:4];
    end
    // Determine Operation
    always @(posedge pclk) begin
        // with UART
        if(curr_state == ACCESS) begin
            if(r_rx_ready && (!pwrite)) begin
                // SV_DATA <= rx_data;
                RAM[SEL_ADDR] <= rx_data;
            end
            else if(r_tx_valid && pwrite) begin
                r_tx_data <= RAM[SEL_ADDR];
            end
        end
        // with MASTER
        else if(r_pready) begin
            if(pwrite) begin
                // SV_DATA <= pwdata;
                RAM[SEL_ADDR] <= pwdata;
            end
            else begin
                r_prdata <= RAM[SEL_ADDR];
            end
        end
        else begin
            RAM[SEL_ADDR] <= RAM[SEL_ADDR];
        end
    end
    // Determine State
    always @(posedge pclk or negedge prstn) begin
        if(!prstn) begin
            curr_state <= IDLE;
        end
        else begin
            curr_state <= next_state;
        end
    end
    always @(*) begin
        next_state = curr_state;
        case(curr_state)
            IDLE:
                begin
                    if(pselx) begin
                        next_state = SETUP;
                    end
                end
            SETUP:
                begin
                    if(penable) begin
                        next_state = ACCESS;
                    end
                end
            ACCESS:
                begin
                    if(&acc_cnt) begin
                        next_state = READY;
                    end
                end
            READY:
                begin
                    if(!penable) begin
                        next_state = SETUP;
                    end
                    else if(!pselx) begin
                        next_state = IDLE;
                    end
                end
        endcase
    end
    // Determine ACCESS Count
    always @(posedge pclk or negedge prstn) begin
        if(!prstn) begin
            acc_cnt <= 0;
        end
        else begin
            if(curr_state == ACCESS) begin
                acc_cnt <= acc_cnt + 1;
            end
            else begin
                acc_cnt <= 0;
            end
        end
    end
    // Determine Operation in ACCESS state - UART CMD
    always @(posedge pclk or negedge prstn) begin
        if(!prstn) begin
            r_rx_ready <= 0;
            r_tx_valid <= 0;
        end
        else begin
            if(curr_state == ACCESS) begin
                if(CMD == 4'b0100) begin // Rx Read
                    r_rx_ready <= 1;
                end
                else if(CMD == 4'b0000) begin // Tx Start
                    r_tx_valid <= 1;
                end
                else begin
                    r_rx_ready <= 0;
                    r_tx_valid <= 0;
                end
            end
        end
    end
    // Determine Operation in READY state
    always @(posedge pclk or negedge prstn) begin
        if(!prstn) begin
            r_pready <= 0;
        end
        else begin
            if(curr_state == READY) begin
                r_pready <= 1;
            end
        end
    end
endmodule