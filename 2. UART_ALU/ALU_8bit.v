module ALU_8bit(
    input clk,
    input rst,
    input rx,
    output wire tx
);
    wire [7:0] rx_data_o;
    wire tx_clk, rx_clk;
    wire RX_done, PRE_done;
    wire [7:0] ASC2B_num_o;
    wire [3:0] ASC2B_oper_o;
    wire ASC2B_num_done, ASC2B_oper_done;
    wire [7:0] PRE_num1_o, PRE_num2_o;
    wire [3:0] PRE_oper_o;
    wire [7:0] ALU_o;
    wire [7:0] POST_o;
    wire [7:0] B2ASC_o;
    wire tx_done;
    wire [7:0] BUFF_o;
    wire n_valid_o, n_valid_i, n_ready_o, n_ready_i;
    wire tx_busy;

    BAUD_GENERATOR B0(
        .clk(clk),
        .rst(rst),
        .tx_clk(tx_clk),
        .rx_clk(rx_clk)
    );
    
    UART_RX U0(
        .clk        (rx_clk),
        .rst        (rst),
        .rx         (rx),
        .data_o     (rx_data_o),
        .done       (RX_done),
        .busy       ()
    );

    ASC2B U1(
        .clk        (tx_clk),
        .rst        (rst),
        .done       (RX_done),
        .num_done   (ASC2B_num_done),
        .oper_done  (ASC2B_oper_done),
        .data_i     (rx_data_o),
        .num_o      (ASC2B_num_o),
        .oper_o     (ASC2B_oper_o)
    );

    PRE_PROCESSOR U2(
        .clk        (tx_clk),
        .rst        (rst),
        .num_i      (ASC2B_num_o),
        .oper_i     (ASC2B_oper_o),
        .num_in     (ASC2B_num_done),
        .oper_in    (ASC2B_oper_done),
        .number_1   (PRE_num1_o),
        .number_2   (PRE_num2_o),
        .operation  (PRE_oper_o),
        .done       (PRE_done)
    );
// ###  PRE_done  ### //
    ALU U3(
        .clk        (tx_clk),
        .rst        (rst),
        .num1       (PRE_num1_o),
        .num2       (PRE_num2_o),
        .oper       (PRE_oper_o),
        .num_out    (ALU_o)
    );
    
    POST_PROCESSOR U4(
        .clk        (tx_clk),
        .rst        (rst),
        .data_i     (ALU_o),
        .catch      (PRE_done),
        .ready      (n_ready_i),
        .valid      (n_valid_i),
        .data_o     (POST_o)
    );


    reg tx_busy_1d, tx_busy_2d ;
    assign n_ready_o = ~tx_busy;
    
    wire tx_start = n_valid_o & n_ready_o;

    always @(posedge clk) begin 
        if (rst) begin
            tx_busy_1d <= 0;
            tx_busy_2d <= 0;
         end else begin
            tx_busy_1d <= tx_busy;
            tx_busy_2d <= tx_busy_1d;
         end
    end
    
    
    SKID_BUFF U5(
        .clk        (tx_clk),
        .rst        (rst),
        .data_i     (POST_o),
        .data_o     (BUFF_o),
        .valid_in   (n_valid_i),
        .ready_in   (n_ready_i),
        .ready_out  (n_ready_o),
        .valid_out  (n_valid_o)
    );

    B2ASC U6(
        .enable(tx_start),
        .data_i(BUFF_o),
        .data_o(B2ASC_o)
    );

    UART_TX U7(
        .clk        (tx_clk),
        .rst        (rst),
        .data_i     (B2ASC_o),
        .start      (tx_start),
        .tx         (tx),
        .busy       (tx_busy),
        .done       (tx_done)
    );
    
endmodule