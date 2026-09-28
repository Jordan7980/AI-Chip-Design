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
            red <= 1;
            yellow <= 0;
            green <= 0;
        end else if (enable) begin
            if (counter == 0) begin
                state <= next_state;
                case(state)
                    RED: begin
                        next_state = GREEN;
                        counter <= 32; // Set counter for next state duration
                    end
                    GREEN: begin
                        next_state = YELLOW;
                        counter <= 20; // Set counter for next state duration
                    end
                    YELLOW: begin
                        next_state = RED;
                        counter <= 7;  // Set counter for next state duration
                    end
                    default: begin
                        next_state = RED;
                        counter <= 32;
                    end
                endcase
            end else begin
                counter <= counter - 1;
            end
        end
    end

    always @(*) begin
        // Default output values
        red = 0;
        yellow = 0;
        green = 0;
        
        case (state)
            RED: begin
                red = 1;
            end
            GREEN: begin
                green = 1;
            end
            YELLOW: begin
                yellow = 1;
            end
        endcase
    end
endmodule
