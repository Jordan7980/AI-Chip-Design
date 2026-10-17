module tb_mux2to1;
    // Declare signals
    reg a;
    reg b;
    reg sel;
    wire y;
    
    // Instantiate the module under test
    mux2to1 uut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );

    integer passed_tests = 0;
    integer failed_tests = 0;
    integer total_tests = 0;
    
    initial begin
        // Test case 1: sel = 0, a = 0, b = 0
        a = 0; b = 0; sel = 0;
        #10;
        $display("Test 1: a = %b, b = %b, sel = %b", a, b, sel);
        #10;
        total_tests = total_tests + 1;
        if (y === 0) begin
            $display("✓ Test 1 passed: y = %b (expected: 0)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 1 failed: y = %b (expected: 0)", y);
            failed_tests = failed_tests + 1;
        end
        
        // Test case 2: sel = 0, a = 0, b = 1
        a = 0; b = 1; sel = 0;
        #10;
        $display("Test 2: a = %b, b = %b, sel = %b", a, b, sel);
        #10;
        total_tests = total_tests + 1;
        if (y === 0) begin
            $display("✓ Test 2 passed: y = %b (expected: 0)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 2 failed: y = %b (expected: 0)", y);
            failed_tests = failed_tests + 1;
        end
        
        // Test case 3: sel = 0, a = 1, b = 0
        a = 1; b = 0; sel = 0;
        #10;
        $display("Test 3: a = %b, b = %b, sel = %b", a, b, sel);
        #10;
        total_tests = total_tests + 1;
        if (y === 1) begin
            $display("✓ Test 3 passed: y = %b (expected: 1)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 3 failed: y = %b (expected: 1)", y);
            failed_tests = failed_tests + 1;
        end
        
        // Test case 4: sel = 0, a = 1, b = 1
        a = 1; b = 1; sel = 0;
        #10;
        $display("Test 4: a = %b, b = %b, sel = %b", a, b, sel);
        #10;
        total_tests = total_tests + 1;
        if (y === 1) begin
            $display("✓ Test 4 passed: y = %b (expected: 1)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 4 failed: y = %b (expected: 1)", y);
            failed_tests = failed_tests + 1;
        end
        
        // Test case 5: sel = 1, a = 0, b = 0
        a = 0; b = 0; sel = 1;
        #10;
        $display("Test 5: a = %b, b = %b, sel = %b", a, b, sel);
        #10;
        total_tests = total_tests + 1;
        if (y === 0) begin
            $display("✓ Test 5 passed: y = %b (expected: 0)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 5 failed: y = %b (expected: 0)", y);
            failed_tests = failed_tests + 1;
        end
        
        // Test case 6: sel = 1, a = 0, b = 1
        a = 0; b = 1; sel = 1;
        #10;
        $display("Test 6: a = %b, b = %b, sel = %b", a, b, sel);
        #10;
        total_tests = total_tests + 1;
        if (y === 1) begin
            $display("✓ Test 6 passed: y = %b (expected: 1)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 6 failed: y = %b (expected: 1)", y);
            failed_tests = failed_tests + 1;
        end
        
        // Test case 7: sel = 1, a = 1, b = 0
        a = 1; b = 0; sel = 1;
        #10;
        $display("Test 7: a = %b, b = %b, sel = %b", a, b, sel);
        #10;
        total_tests = total_tests + 1;
        if (y === 0) begin
            $display("✓ Test 7 passed: y = %b (expected: 0)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 7 failed: y = %b (expected: 0)", y);
            failed_tests = failed_tests + 1;
        end
        
        // Test case 8: sel = 1, a = 1, b = 1
        a = 1; b = 1; sel = 1;
        #10;
        $display("Test 8: a = %b, b = %b, sel = %b", a, b, sel);
        #10;
        total_tests = total_tests + 1;
        if (y === 1) begin
            $display("✓ Test 8 passed: y = %b (expected: 1)", y);
            passed_tests = passed_tests + 1;
        end else begin
            $display("✗ Test 8 failed: y = %b (expected: 1)", y);
            failed_tests = failed_tests + 1;
        end

        $display("\nTest Summary:");
        $display("Total tests run: %d", total_tests);
        $display("Number passed: %d", passed_tests);
        $display("Number failed: %d", failed_tests);

        $finish;
    end
endmodule