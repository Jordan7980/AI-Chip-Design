module traffic_light_fsm(
    input clk,
    input reset_n,
    input enable,
    output reg red,
    output reg yellow,
    output reg green
);

    typedef enum reg [1:0] {RED = 2'b00, GREEN = 2'b01, YELLOW = 2'b10} state_t;
    state_t state, next_state;
    reg [5:0] counter; // 6 bits to count up to 32

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= RED;
            counter <= 0; // Reset counter
        end else if (enable) begin
            if (counter > 0) begin
                counter <= counter - 1;
            end else begin
                state <= next_state; // Transition to the next state
                case (next_state)
                    RED: begin
                        counter <= 32; // Set counter for RED to GREEN transition
                    end
                    GREEN: begin
                        counter <= 20; // Set counter for GREEN to YELLOW transition
                    end
                    YELLOW: begin
                        counter <= 7; // Set counter for YELLOW to RED transition
                    end
                endcase
            end
        end
    end

    always @(*) begin // Change to combinational block
        // Default outputs
        red = 0;
        yellow = 0;
        green = 0;
        case (state)
            RED: begin
                red = 1;
                next_state = GREEN; // Move to GREEN after RED
            end
            GREEN: begin
                green = 1;
                next_state = YELLOW; // Move to YELLOW after GREEN
            end
            YELLOW: begin
                yellow = 1;
                next_state = RED; // Move to RED after YELLOW
            end
            default: begin
                next_state = RED; // Safe default
            end
        endcase
    end

endmodule
