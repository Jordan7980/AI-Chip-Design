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
    reg [5:0] counter; // 6 bits to count up to 32

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= RED;
            counter <= 0;
        end else if (enable) begin
            if (counter > 0) begin
                counter <= counter - 1;
            end else begin
                state <= next_state; // Move to the next state when counter reaches 0
                case (next_state)
                    RED: counter <= 32;       // Set counter for RED to GREEN transition
                    GREEN: counter <= 20;     // Set counter for GREEN to YELLOW transition
                    YELLOW: counter <= 7;      // Set counter for YELLOW to RED transition
                endcase
            end
        end
    end

    always @(posedge clk) begin
        // Update outputs based on current state
        case (state)
            RED: begin
                red = 1;
                yellow = 0;
                green = 0;
                next_state = GREEN; // Schedule next state
            end
            GREEN: begin
                red = 0;
                yellow = 0;
                green = 1;
                next_state = YELLOW; // Schedule next state
            end
            YELLOW: begin
                red = 0;
                yellow = 1;
                green = 0;
                next_state = RED; // Schedule next state
            end
            default: begin
                red = 0;
                yellow = 0;
                green = 0;
                next_state = RED;
            end
        endcase
    end
endmodule
