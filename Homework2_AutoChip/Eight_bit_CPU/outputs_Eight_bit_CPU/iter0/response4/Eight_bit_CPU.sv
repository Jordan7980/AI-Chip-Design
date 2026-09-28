module Eight_bit_CPU(
    input clk,
    input reset,
    input [7:0] data_in,
    output reg [7:0] data_out,
    output reg [7:0] address,
    output reg mem_read,
    output reg mem_write
);
    
    reg [7:0] RAM [0:255];
    reg [7:0] PC; // Program Counter
    reg [7:0] ACC; // Accumulator
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 8'b0;
            ACC <= 8'b0;
            mem_read <= 0;
            mem_write <= 0;
        end else begin
            // Example simple opcode handling (to be expanded)
            case (RAM[PC]) 
                // Assume RAM[PC] has instructions for read/write operations
                8'h01: begin // Hypothetical instruction for Load
                    ACC <= RAM[RAM[PC + 1]]; // Load from address in next RAM location
                    PC <= PC + 2; // Move to the next instruction
                end
                8'h02: begin // Hypothetical instruction for Store
                    RAM[RAM[PC + 1]] <= ACC; // Store ACC to address in next RAM location
                    PC <= PC + 2; // Move to the next instruction
                end
                // Other instructions would be handled here
                default: PC <= PC + 1; // Increment PC if unknown instruction
            endcase
            
            // Update address and control signals for memory
            address <= RAM[PC + 1]; // Latch address for memory access
            data_out <= ACC; // Output the ACC value
            mem_read <= (RAM[PC] == 8'h01); // Set read signal if Load instruction
            mem_write <= (RAM[PC] == 8'h02); // Set write signal if Store instruction
        end
    end
endmodule
