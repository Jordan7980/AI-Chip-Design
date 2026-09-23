
module dice_roller (
    input wire clk,               // Clock
    input wire rst_n,             // Active-low reset (changed name)
    input wire [1:0] die_select,  // Die select
    input wire roll,              // Roll signal
    output reg [7:0] rolled_number // Rolled number (up to 8-bits)
);

    reg [7:0] max_value;          // Maximum value for the selected die
    reg rolling;                  // Rolling state flag

    // Pseudo-Random Number Generator (XOR Shift)
    reg [7:0] rand_state = 8'hA5; // Initial state

    // Pseudo-Random Number generation procedure
    function [7:0] get_random;
        input [7:0] state;
        get_random = {state[6:0], state[7] ^ state[5] ^ state[3] ^ state[2]};
    endfunction

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            rolled_number <= 8'b0;    // Reset rolled number
            rolling <= 1'b0;          // Reset rolling state
            rand_state <= 8'hA5;      // Reset random state
        end else begin
            // Set the max_value based on die_select
            case (die_select)
                2'b00: max_value <= 4;  // 4-sided die
                2'b01: max_value <= 6;  // 6-sided die
                2'b10: max_value <= 8;  // 8-sided die
                2'b11: max_value <= 20; // 20-sided die
                default: max_value <= 4; // Default to 4-sided die
            endcase

            // Roll the die when the roll signal goes high
            if (roll && !rolling) begin
                rolling <= 1'b1; // Enter rolling state
                // Generate pseudo-random number
                rand_state <= get_random(rand_state);
                // Generate a number in the range [1, max_value]
                rolled_number <= (rand_state % max_value) + 1;
            end

            if (!roll) begin
                rolling <= 1'b0; // Exit rolling state
            end
        end
    end
endmodule
