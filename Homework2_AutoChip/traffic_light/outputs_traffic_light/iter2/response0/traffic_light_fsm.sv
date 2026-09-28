module traffic_light_fsm(
    input clk,
    input reset_n,
    input enable,
    output reg red,
    output reg yellow,
    output reg green
);

    parameter RED = 2'b00, GREEN = 2'b01, YELLOW = 2'b10;
    reg [1:0] state, next_state;
    reg [5:0] counter; // 6 bits to count to 32

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= RED;
            counter <= 0;
        end else if (enable) begin
            if (counter > 0) begin
                counter <= counter - 1;
            end else begin
                state <= next_state;

                // Set the counter based on the next state
                case (next_state)
                    RED: counter <= 32;       // Set counter for RED to GREEN transition
                    GREEN: counter <= 20;     // Set counter for GREEN to YELLOW transition
                    YELLOW: counter <= 7;      // Set counter for YELLOW to RED transition
                endcase
            end
        end
    end

    always @(*) begin
        // Default outputs
        red = 0;
        yellow = 0;
        green = 0;

        case (state)
            RED: begin
                red = 1;
                next_state = GREEN; // Transition to GREEN next
            end
            GREEN: begin
                green = 1;
                next_state = YELLOW; // Transition to YELLOW next
            end
            YELLOW: begin
                yellow = 1;
                next_state = RED; // Transition to RED next
            end
            default: next_state = RED;
        endcase
    end
endmodule
