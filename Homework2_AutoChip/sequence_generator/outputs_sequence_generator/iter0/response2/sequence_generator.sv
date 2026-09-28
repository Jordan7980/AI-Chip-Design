module sequence_generator(
    input clk,
    input reset_n,
    input enable,
    output reg [7:0] data
);
    reg [2:0] state; // 3-bit state to hold the current index
    reg [7:0] sequence[0:7]; // Array of sequence values

    initial begin
        sequence[0] = 8'hAF;
        sequence[1] = 8'hBC;
        sequence[2] = 8'hE2;
        sequence[3] = 8'h78;
        sequence[4] = 8'hFF;
        sequence[5] = 8'hE2;
        sequence[6] = 8'h0B;
        sequence[7] = 8'h8D;
        state = 3'b000; // Initialize state
        data = 8'h00; // Initialize data output
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            state <= 3'b000; // Reset to first state
            data <= 8'h00;   // Reset output data
        end else if (enable) begin
            data <= sequence[state]; // Output current sequence value
            state <= (state + 1) % 8; // Move to the next state and wrap around
        end
    end
endmodule
