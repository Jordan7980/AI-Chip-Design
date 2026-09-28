module traffic_light_fsm(
    input clk,
    input reset_n,
    input enable,
    output reg red,
    output reg yellow,
    output reg green
);
    
    typedef enum reg [1:0] {
        RED = 2'b00,
        GREEN = 2'b01,
        YELLOW = 2'b10
    } state_t;

    state_t current_state, next_state;
    reg [5:0] counter; // 6 bits to count up to 32 (max)

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= RED;
            counter <= 0;
        end else if (enable) begin
            current_state <= next_state;
            if (current_state == RED)
                counter <= counter + 1;
            else
                counter <= 0; // Reset counter for other states
        end
    end

    always @(*) begin
        case (current_state)
            RED: begin
                red = 1'b1;
                yellow = 1'b0;
                green = 1'b0;
                if (counter >= 32) next_state = GREEN;
                else next_state = RED;
            end
            
            GREEN: begin
                red = 1'b0;
                yellow = 1'b0;
                green = 1'b1;
                if (counter >= 20) next_state = YELLOW;
                else next_state = GREEN;
            end
            
            YELLOW: begin
                red = 1'b0;
                yellow = 1'b1;
                green = 1'b0;
                if (counter >= 7) next_state = RED;
                else next_state = YELLOW;
            end

            default: begin
                red = 1'b0;
                yellow = 1'b0;
                green = 1'b0;
                next_state = RED;
            end
        endcase
    end
    
endmodule
