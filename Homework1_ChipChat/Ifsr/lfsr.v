
module LFSR(
    input wire clk,              // Clock input
    input wire reset_n,          // Active-low reset
    output reg [7:0] data        // 8-bit output data
);

// Initial state
initial begin
    data = 8'b10001010;         // Set the initial state
end

// Always block triggered on the rising edge of the clock or the falling edge of reset
always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        // Reset the LFSR to the initial state
        data <= 8'b10001010;
    end else begin
        // Compute the feedback based on taps at positions 1, 4, 6, and 7
        // The taps correspond to bits: [1, 4, 6, 7] (0-based index)

        // Calculate the new feedback
        data <= {data[6:0], (data[0] ^ data[3] ^ data[5] ^ data[6])};
    end
end

endmodule

module lfsr (
    input wire clk,
    input wire reset_n,
    output wire [7:0] data
);
    LFSR core (
        .clk(clk),
        .reset_n(reset_n),
        .data(data)
    );
endmodule
