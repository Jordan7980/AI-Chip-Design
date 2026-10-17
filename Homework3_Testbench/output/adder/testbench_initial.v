`timescale 1ns / 1ps

module adder4bit_tb;

    // Declare signals
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] sum;
    wire carry;

    // Instantiate the adder4bit module
    adder4bit uut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    initial begin
        // Test 1: Both inputs are zero
        a = 4'b0000; b = 4'b0000;
        #10 $display("Test 1: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);

        // Test 2: Maximum values without overflow
        a = 4'b0111; b = 4'b0111;
        #10 $display("Test 2: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);

        // Test 3: Maximum value for a, zero for b
        a = 4'b1111; b = 4'b0000;
        #10 $display("Test 3: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);

        // Test 4: Zero for a, maximum value for b
        a = 4'b0000; b = 4'b1111;
        #10 $display("Test 4: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);

        // Test 5: Both maximum values, should cause overflow
        a = 4'b1111; b = 4'b1111;
        #10 $display("Test 5: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);

        // Test 6: One less than maximum without overflow
        a = 4'b1000; b = 4'b0111;
        #10 $display("Test 6: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);

        // Test 7: Edge case of carry generation
        a = 4'b1001; b = 4'b0110;
        #10 $display("Test 7: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);

        // Test 8: Random values
        a = 4'b0101; b = 4'b1010;
        #10 $display("Test 8: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);

        // Test 9: Random values
        a = 4'b0011; b = 4'b1100;
        #10 $display("Test 9: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);

        // Test 10: Random values
        a = 4'b1110; b = 4'b0010;
        #10 $display("Test 10: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);

        // Finish simulation
        $finish;
    end

endmodule