module lfsr(
    input clk,
    input reset_n,
    output reg [7:0] data
);

    reg [7:0] lfsr_reg;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            lfsr_reg <= 8'b10001010; // Initial state
        end else begin
            // Correct feedback polynomial for taps at locations 1, 4, 6, and 7
            lfsr_reg <= {lfsr_reg[6:0], lfsr_reg[7] ^ lfsr_reg[3] ^ lfsr_reg[1] ^ lfsr_reg[0]};
        end
    end

    assign data = lfsr_reg;

endmodule
