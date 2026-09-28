module Eight_bit_CPU(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg [7:0] address,
    output reg mem_read,
    output reg mem_write
);
    reg [7:0] RAM [0:255]; // Program and data memory
    reg [7:0] PC;          // Program Counter
    reg [7:0] ACC;         // Accumulator
    reg [2:0] state;       // State variable for sequential logic

    // State Encoding
    localparam FETCH = 3'b000, DECODE = 3'b001, EXECUTE = 3'b010;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 8'b0;
            ACC <= 8'b0;
            mem_read <= 0;
            mem_write <= 0;
            data_out <= 8'b0;
            state <= FETCH;
        end else begin
            case (state)
                FETCH: begin
                    address <= PC; 
                    mem_read <= 1;
                    state <= DECODE;
                end

                DECODE: begin
                    data_out <= RAM[address];
                    mem_read <= 0; 
                    // Decoding logic could be added here based on instruction set
                    state <= EXECUTE; // Example: direct to execute
                end

                EXECUTE: begin
                    // Example execute logic to modify ACC
                    ACC <= ACC + data_out; // Example arithmetic operation
                    // Update PC after execution
                    PC <= PC + 1;
                    mem_write <= 1; // Example: write back if needed
                    state <= FETCH; // Return to fetch next instruction
                end

                default: state <= FETCH; // Safety fallback
            endcase
        end
    end
endmodule
