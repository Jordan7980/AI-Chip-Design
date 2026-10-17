module tb_binary_to_bcd_converter;

    // Declare testbench signals
    reg [4:0] binary_input;
    wire [7:0] bcd_output;

    // Instantiate the module under test
    binary_to_bcd_converter uut (
        .binary_input(binary_input),
        .bcd_output(bcd_output)
    );

    integer passed_tests;
    integer failed_tests;

    initial begin
        passed_tests = 0;
        failed_tests = 0;

        // Test case 1: Minimum input value
        binary_input = 5'b00000;
        #10;
        $display("Test 1: binary_input = %b, bcd_output = %b", binary_input, bcd_output);
        #10;
        if (bcd_output === 8'b00000000) begin
            $display("✓ Test 1 passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 1 failed: expected 00000000, got %b", bcd_output);
            failed_tests = failed_tests + 1;
        end

        // Test case 2: Maximum input value
        binary_input = 5'b11111;
        #10;
        $display("Test 2: binary_input = %b, bcd_output = %b", binary_input, bcd_output);
        #10;
        if (bcd_output === 8'b00110001) begin
            $display("✓ Test 2 passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 2 failed: expected 00110001, got %b", bcd_output);
            failed_tests = failed_tests + 1;
        end

        // Test case 3: Boundary value (just before 10 in decimal)
        binary_input = 5'b01001;
        #10;
        $display("Test 3: binary_input = %b, bcd_output = %b", binary_input, bcd_output);
        #10;
        if (bcd_output === 8'b00001001) begin
            $display("✓ Test 3 passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 3 failed: expected 00001001, got %b", bcd_output);
            failed_tests = failed_tests + 1;
        end

        // Test case 4: Boundary value (10 in decimal)
        binary_input = 5'b01010;
        #10;
        $display("Test 4: binary_input = %b, bcd_output = %b", binary_input, bcd_output);
        #10;
        if (bcd_output === 8'b00010000) begin
            $display("✓ Test 4 passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 4 failed: expected 00010000, got %b", bcd_output);
            failed_tests = failed_tests + 1;
        end

        // Test case 5: Typical use case (13 in decimal)
        binary_input = 5'b01101;
        #10;
        $display("Test 5: binary_input = %b, bcd_output = %b", binary_input, bcd_output);
        #10;
        if (bcd_output === 8'b00010011) begin
            $display("✓ Test 5 passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 5 failed: expected 00010011, got %b", bcd_output);
            failed_tests = failed_tests + 1;
        end

        // Test case 6: Edge case (1 in decimal)
        binary_input = 5'b00001;
        #10;
        $display("Test 6: binary_input = %b, bcd_output = %b", binary_input, bcd_output);
        #10;
        if (bcd_output === 8'b00000001) begin
            $display("✓ Test 6 passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 6 failed: expected 00000001, got %b", bcd_output);
            failed_tests = failed_tests + 1;
        end

        // Test case 7: Random value
        binary_input = 5'b00111;
        #10;
        $display("Test 7: binary_input = %b, bcd_output = %b", binary_input, bcd_output);
        #10;
        if (bcd_output === 8'b00000111) begin
            $display("✓ Test 7 passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 7 failed: expected 00000111, got %b", bcd_output);
            failed_tests = failed_tests + 1;
        end

        // Test case 8: Random value
        binary_input = 5'b10100;
        #10;
        $display("Test 8: binary_input = %b, bcd_output = %b", binary_input, bcd_output);
        #10;
        if (bcd_output === 8'b00100000) begin
            $display("✓ Test 8 passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 8 failed: expected 00100000, got %b", bcd_output);
            failed_tests = failed_tests + 1;
        end

        // Test case 9: Random value
        binary_input = 5'b10001;
        #10;
        $display("Test 9: binary_input = %b, bcd_output = %b", binary_input, bcd_output);
        #10;
        if (bcd_output === 8'b00100011) begin
            $display("✓ Test 9 passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 9 failed: expected 00100011, got %b", bcd_output);
            failed_tests = failed_tests + 1;
        end

        // Test case 10: Random value
        binary_input = 5'b01011;
        #10;
        $display("Test 10: binary_input = %b, bcd_output = %b", binary_input, bcd_output);
        #10;
        if (bcd_output === 8'b00010001) begin
            $display("✓ Test 10 passed");
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 10 failed: expected 00010001, got %b", bcd_output);
            failed_tests = failed_tests + 1;
        end

        $display("Test Summary: Total = %0d, Passed = %0d, Failed = %0d", 10, passed_tests, failed_tests);

        $finish;
    end

endmodule