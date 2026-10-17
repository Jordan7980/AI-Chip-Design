`timescale 1ns / 1ps

module adder4bit_tb;

    // Declare signals
    reg [3:0] a;
    reg [3:0] b;
    wire [3:0] sum;
    wire carry;
    integer passed_tests, failed_tests;

    // Instantiate the adder4bit module
    adder4bit uut (
        .a(a),
        .b(b),
        .sum(sum),
        .carry(carry)
    );

    initial begin
        passed_tests = 0;
        failed_tests = 0;

        // Test 1: Both inputs are zero
        a = 4'b0000; b = 4'b0000;
        #10 $display("Test 1: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b0000 && carry === 1'b0) begin
            $display("Test 1: ✓");
            passed_tests = passed_tests + 2;
        end else begin
            if (sum !== 4'b0000) begin
                $display("Test 1 Sum: ✗ (Expected 0000, Got %b)", sum);
                failed_tests = failed_tests + 1;
            end
            if (carry !== 1'b0) begin
                $display("Test 1 Carry: ✗ (Expected 0, Got %b)", carry);
                failed_tests = failed_tests + 1;
            end
        end

        // Test 2: Maximum values without overflow
        a = 4'b0111; b = 4'b0111;
        #10 $display("Test 2: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1110 && carry === 1'b0) begin
            $display("Test 2: ✓");
            passed_tests = passed_tests + 2;
        end else begin
            if (sum !== 4'b1110) begin
                $display("Test 2 Sum: ✗ (Expected 1110, Got %b)", sum);
                failed_tests = failed_tests + 1;
            end
            if (carry !== 1'b0) begin
                $display("Test 2 Carry: ✗ (Expected 0, Got %b)", carry);
                failed_tests = failed_tests + 1;
            end
        end

        // Test 3: Maximum value for a, zero for b
        a = 4'b1111; b = 4'b0000;
        #10 $display("Test 3: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1111 && carry === 1'b0) begin
            $display("Test 3: ✓");
            passed_tests = passed_tests + 2;
        end else begin
            if (sum !== 4'b1111) begin
                $display("Test 3 Sum: ✗ (Expected 1111, Got %b)", sum);
                failed_tests = failed_tests + 1;
            end
            if (carry !== 1'b0) begin
                $display("Test 3 Carry: ✗ (Expected 0, Got %b)", carry);
                failed_tests = failed_tests + 1;
            end
        end

        // Test 4: Zero for a, maximum value for b
        a = 4'b0000; b = 4'b1111;
        #10 $display("Test 4: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1111 && carry === 1'b0) begin
            $display("Test 4: ✓");
            passed_tests = passed_tests + 2;
        end else begin
            if (sum !== 4'b1111) begin
                $display("Test 4 Sum: ✗ (Expected 1111, Got %b)", sum);
                failed_tests = failed_tests + 1;
            end
            if (carry !== 1'b0) begin
                $display("Test 4 Carry: ✗ (Expected 0, Got %b)", carry);
                failed_tests = failed_tests + 1;
            end
        end

        // Test 5: Both maximum values, should cause overflow
        a = 4'b1111; b = 4'b1111;
        #10 $display("Test 5: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1110 && carry === 1'b1) begin
            $display("Test 5: ✓");
            passed_tests = passed_tests + 2;
        end else begin
            if (sum !== 4'b1110) begin
                $display("Test 5 Sum: ✗ (Expected 1110, Got %b)", sum);
                failed_tests = failed_tests + 1;
            end
            if (carry !== 1'b1) begin
                $display("Test 5 Carry: ✗ (Expected 1, Got %b)", carry);
                failed_tests = failed_tests + 1;
            end
        end

        // Test 6: One less than maximum without overflow
        a = 4'b1000; b = 4'b0111;
        #10 $display("Test 6: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1111 && carry === 1'b0) begin
            $display("Test 6: ✓");
            passed_tests = passed_tests + 2;
        end else begin
            if (sum !== 4'b1111) begin
                $display("Test 6 Sum: ✗ (Expected 1111, Got %b)", sum);
                failed_tests = failed_tests + 1;
            end
            if (carry !== 1'b0) begin
                $display("Test 6 Carry: ✗ (Expected 0, Got %b)", carry);
                failed_tests = failed_tests + 1;
            end
        end

        // Test 7: Edge case of carry generation
        a = 4'b1001; b = 4'b0110;
        #10 $display("Test 7: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1111 && carry === 1'b0) begin
            $display("Test 7: ✓");
            passed_tests = passed_tests + 2;
        end else begin
            if (sum !== 4'b1111) begin
                $display("Test 7 Sum: ✗ (Expected 1111, Got %b)", sum);
                failed_tests = failed_tests + 1;
            end
            if (carry !== 1'b0) begin
                $display("Test 7 Carry: ✗ (Expected 0, Got %b)", carry);
                failed_tests = failed_tests + 1;
            end
        end

        // Test 8: Random values
        a = 4'b0101; b = 4'b1010;
        #10 $display("Test 8: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1111 && carry === 1'b0) begin
            $display("Test 8: ✓");
            passed_tests = passed_tests + 2;
        end else begin
            if (sum !== 4'b1111) begin
                $display("Test 8 Sum: ✗ (Expected 1111, Got %b)", sum);
                failed_tests = failed_tests + 1;
            end
            if (carry !== 1'b0) begin
                $display("Test 8 Carry: ✗ (Expected 0, Got %b)", carry);
                failed_tests = failed_tests + 1;
            end
        end

        // Test 9: Random values
        a = 4'b0011; b = 4'b1100;
        #10 $display("Test 9: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b1111 && carry === 1'b0) begin
            $display("Test 9: ✓");
            passed_tests = passed_tests + 2;
        end else begin
            if (sum !== 4'b1111) begin
                $display("Test 9 Sum: ✗ (Expected 1111, Got %b)", sum);
                failed_tests = failed_tests + 1;
            end
            if (carry !== 1'b0) begin
                $display("Test 9 Carry: ✗ (Expected 0, Got %b)", carry);
                failed_tests = failed_tests + 1;
            end
        end

        // Test 10: Random values
        a = 4'b1110; b = 4'b0010;
        #10 $display("Test 10: a=%b b=%b | sum=%b carry=%b", a, b, sum, carry);
        #10;
        if (sum === 4'b0000 && carry === 1'b1) begin
            $display("Test 10: ✓");
            passed_tests = passed_tests + 2;
        end else begin
            if (sum !== 4'b0000) begin
                $display("Test 10 Sum: ✗ (Expected 0000, Got %b)", sum);
                failed_tests = failed_tests + 1;
            end
            if (carry !== 1'b1) begin
                $display("Test 10 Carry: ✗ (Expected 1, Got %b)", carry);
                failed_tests = failed_tests + 1;
            end
        end

        // Test summary
        $display("Test Summary: Total Tests Run = %d, Passed = %d, Failed = %d", 20, passed_tests, failed_tests);

        // Finish simulation
        $finish;
    end

endmodule