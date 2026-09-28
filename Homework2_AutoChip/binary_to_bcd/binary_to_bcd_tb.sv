`timescale 1ns / 1ps

module tb;                       // renamed from tb_binary_to_bcd_converter
integer errors = 0;              // count errors instead of stopping

reg [4:0] binary_input;
wire [7:0] bcd_output;

binary_to_bcd_converter uut (
    .binary_input(binary_input),
    .bcd_output(bcd_output)
);

integer i;
reg [7:0] expected_bcd;

initial begin
    for (i = 0; i < 32; i = i + 1) begin
        binary_input = i;
        expected_bcd[3:0] = i % 10;
        expected_bcd[7:4] = i / 10;
        #10;
        if (bcd_output !== expected_bcd) begin
            $display("Error: Input %0d. Expected BCD: 8'b%08b, Got: 8'b%08b", i,
             expected_bcd, bcd_output);

            errors = errors + 1;     // was: $finish;

        end
    end
    $finish;
end


final begin
    $display("Mismatches: %0d in %0d samples", errors, 32);
end

endmodule
