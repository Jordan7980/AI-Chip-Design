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
    reg [5:0] counter; // 6 bits to count for maximum 32

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= RED;
            counter <= 32; // Start with counter for RED
        end else if (enable) begin
            if (counter > 0) begin
                counter <= counter - 1;
            end else begin
                state <= next_state; // Transition to the next state
                case (next_state)
                    RED: counter <= 32;       // Counter for transition from RED to GREEN
                    GREEN: counter <= 20;     // Counter for transition from GREEN to YELLOW
                    YELLOW: counter <= 7;      // Counter for transition from YELLOW to RED
                endcase
            end
        end
    end

    always @(*) begin // Combinational block for outputs and next state logic
        // Default outputs
        red = 0;
        yellow = 0;
        green = 0;
        
        case (state)
            RED: begin
                red = 1;
                next_state = GREEN; // Next state will be GREEN
            end
            GREEN: begin
                green = 1;
                next_state = YELLOW; // Next state will be YELLOW
            end
            YELLOW: begin
                yellow = 1;
                next_state = RED; // Next state will be RED
            end
        endcase
    end

    // Counter reset logic based on current state
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            counter <= 32; // Reset counter
        end else if (state == RED && counter == 0) begin
            counter <= 32; // Reset counter for RED
        end else if (state == GREEN && counter == 0) begin
            counter <= 20; // Reset counter for GREEN
        end else if (state == YELLOW && counter == 0) begin
            counter <= 7; // Reset counter for YELLOW
        end
    end

endmodule
