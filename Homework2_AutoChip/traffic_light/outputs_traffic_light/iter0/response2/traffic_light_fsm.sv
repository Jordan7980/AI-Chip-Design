module traffic_light_fsm(
    input clk,
    input reset_n,
    input enable,
    output reg red,
    output reg yellow,
    output reg green
);
    
    // State encoding
    typedef enum logic [1:0] {
        RED = 2'b00, 
        GREEN = 2'b01, 
        YELLOW = 2'b10
    } state_t;

    state_t current_state, next_state;

    // Counter for state timing
    reg [5:0] counter; // Counter wide enough to hold the maximum value needed

    // State transition logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= RED;
            counter <= 0;
        end else if (enable) begin
            current_state <= next_state;
            if (current_state == RED) begin
                counter <= (counter == 31) ? 0 : counter + 1; // 32 cycles for red
            end else if (current_state == GREEN) begin
                counter <= (counter == 19) ? 0 : counter + 1; // 20 cycles for green
            end else if (current_state == YELLOW) begin
                counter <= (counter == 6) ? 0 : counter + 1; // 7 cycles for yellow
            end
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            RED: begin
                if (counter == 31) 
                    next_state = GREEN;
                else
                    next_state = RED;
            end
            GREEN: begin
                if (counter == 19) 
                    next_state = YELLOW;
                else
                    next_state = GREEN;
            end
            YELLOW: begin
                if (counter == 6)
                    next_state = RED;
                else
                    next_state = YELLOW;
            end
            default: next_state = RED; // Default state
        endcase
    end

    // Output logic
    always_comb begin
        red = (current_state == RED);
        yellow = (current_state == YELLOW);
        green = (current_state == GREEN);
    end

endmodule
