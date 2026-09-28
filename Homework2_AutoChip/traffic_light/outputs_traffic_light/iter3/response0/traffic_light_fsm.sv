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
            counter <= 0;
        end else if (enable) begin
            if (counter > 0) begin
                counter <= counter - 1;
            end else begin
                state <= next_state;
                case (next_state)
                    RED: begin
                        counter <= 32; // Prepare for the duration of RED to GREEN transition
                        next_state <= GREEN;
                    end
                    GREEN: begin
                        counter <= 20; // Prepare for the duration of GREEN to YELLOW transition
                        next_state <= YELLOW;
                    end
                    YELLOW: begin
                        counter <= 7; // Prepare for the duration of YELLOW to RED transition
                        next_state <= RED;
                    end
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
                next_state = GREEN;
            end
            GREEN: begin
                green = 1;
                next_state = YELLOW;
            end
            YELLOW: begin
                yellow = 1;
                next_state = RED;
            end
        endcase
    end

endmodule
