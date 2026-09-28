module traffic_light_fsm(
    input clk,
    input reset_n,
    input enable,
    output reg red,
    output reg yellow,
    output reg green
);
    
    // State encoding
    typedef enum reg [1:0] {
        RED    = 2'b00,
        GREEN  = 2'b01,
        YELLOW = 2'b10
    } state_t;

    state_t current_state, next_state;
    reg [5:0] counter; // Counter for timing

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            current_state <= RED;
            counter <= 0;
        end else if (enable) begin
            current_state <= next_state;
            if (next_state != current_state) // Reset counter on state change
                counter <= 0;
            else // Increment counter
                counter <= counter + 1;
        end
    end

    always @* begin
        // Default outputs
        red = 0;
        yellow = 0;
        green = 0;
        next_state = current_state; // Default to stay in the current state

        case (current_state)
            RED: begin
                red = 1;
                if (counter == 32) // After 32 clock cycles
                    next_state = GREEN;
            end
            GREEN: begin
                green = 1;
                if (counter == 20) // After 20 clock cycles
                    next_state = YELLOW;
            end
            YELLOW: begin
                yellow = 1;
                if (counter == 7) // After 7 clock cycles
                    next_state = RED;
            end
        endcase
    end
endmodule
