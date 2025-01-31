module FRAME_1_ROW#(
    parameter V_FRONT_PULSE_WTDTH  = 4'd2,  // rate : 3
    parameter V_ACTIVE_PULSE_WIDTH = 4'd9,  // rate : 10
    parameter V_BACK_PULSE_WIDTH   = 4'd2,

    parameter H_FRONT_PULSE_WTDTH  = 4'd1,   // rate : 2
    parameter H_ACTIVE_PULSE_WIDTH = 4'd4,   // rate : 5
    parameter H_BACK_PULSE_WIDTH   = 4'd1
)(
    input       clk,
    input       rst,
    input       en,
    output wire frame
);

    localparam IDLE   = 2'b00;
    localparam FRONT  = 2'b01;
    localparam ACTIVE = 2'b10;
    localparam BACK   = 2'b11;

    reg [3:0] sync_cnt;
    reg [3:0] v_cnt;
    
    reg [1:0] current_state;
    reg [1:0] next_state;
    
    wire v_out;
    reg h_out;

    assign frame = v_out & h_out;

    // Determine Vsync
    assign v_out = (v_cnt > V_FRONT_PULSE_WTDTH) && (v_cnt <= (V_FRONT_PULSE_WTDTH + V_ACTIVE_PULSE_WIDTH + 1));

    // Determine State
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end

    always @(*) begin
        next_state = current_state;
        case(current_state)
            IDLE:
                if(en) begin
                    next_state = FRONT;
                end
            FRONT:
                begin
                    if(en && (sync_cnt == H_FRONT_PULSE_WTDTH)) begin
                        next_state = ACTIVE;
                    end
                    else begin
                        next_state = FRONT;
                    end
                end
            ACTIVE:
                begin
                    if(en && (sync_cnt == H_ACTIVE_PULSE_WIDTH)) begin
                        next_state = BACK;
                    end
                    else if(!en)begin
                        next_state = FRONT;
                    end
                end
            BACK:
                begin
                    if(en && (sync_cnt == 4'd1)) begin
                        next_state = FRONT;
                    end
                    else if(!en)begin
                        next_state = FRONT;
                    end
                end
        endcase
    end

    // Determine count
    always @(posedge clk or posedge rst) begin
        if(rst || (!en)) begin
            sync_cnt <= 0;
            v_cnt <= 0;
        end
        else begin
            case(current_state)
            IDLE:
                begin
                    sync_cnt <= 0;
//                    v_cnt <= 0;
                end
            FRONT:
                begin
                    if(sync_cnt == H_FRONT_PULSE_WTDTH) begin
                        sync_cnt <= 0;
//                        v_cnt <= 0;
                    end
                    else begin
                        sync_cnt <= sync_cnt + 1;
                    end
                end
            ACTIVE:
                begin
                    if(sync_cnt == H_ACTIVE_PULSE_WIDTH) begin
                        sync_cnt <= 0;
                    end
                    else begin
                        sync_cnt <= sync_cnt + 1;
                    end
                end
            BACK:
                begin
                    if(sync_cnt == 4'd1) begin
                        sync_cnt <= 0;
                        v_cnt <= v_cnt + 1;
                    end
                    else begin
                        sync_cnt <= sync_cnt + 1;
                    end
                end
            endcase
        end
    end

    // Determine out
    always @(*) begin
        case(current_state)
            FRONT:
                begin
                    h_out = 0;
                end
            ACTIVE:
                begin
                    h_out = 1;
                end
            BACK:
                begin
                    h_out = 0;
                end
        endcase
    end
endmodule
