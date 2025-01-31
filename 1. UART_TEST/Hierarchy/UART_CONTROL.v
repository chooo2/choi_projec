module uart_control#(
    parameter DATA_LENGTH = 8
)(
    input clk,
    input rst,
    input button_mux,
    input button_rx,
    input [DATA_LENGTH-1:0] mux_data,
    input [DATA_LENGTH-1:0] rx_data,
    output wire [DATA_LENGTH-1:0] data,
    output wire start
);
    reg sel_mux, sel_rx;
    wire mux_start, rx_start;
    reg [DATA_LENGTH-1:0] data_out;

    // Determine Data 
    assign data = data_out;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            data_out <= 0;
        end
        else begin 
            if(mux_start) begin
                data_out <= mux_data;
            end
            else if(rx_start) begin
                data_out <= rx_data;
            end
            else begin
                data_out <= data_out;
            end
        end
    end

    always @(*) begin
        if(mux_start) begin
            data_out = mux_data;
        end
        else if(rx_start) begin
            data_out = rx_data;
        end
        else begin
            data_out = data_out;
        end    
    end


    // Determine Start
    assign mux_start = button_mux & (~sel_mux);
    assign rx_start = button_rx & (~sel_rx);
    assign start = mux_start || rx_start;

    always @(posedge clk or posedge rst) begin
        if(rst) begin
            sel_mux <= 0;
            sel_rx <= 0;
        end
        else begin
            sel_mux <= button_mux;
            sel_rx <= button_rx;
        end
    end
endmodule