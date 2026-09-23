`timescale 1ns/1ps

module tb_abro_state_machine();
    reg clk;
    reg rst_n;
    reg A;
    reg B;
    wire O;
    wire [3:0] State;

    // Instantiate the ABRO state machine
    abro_state_machine uut (
        .clk(clk),
        .rst_n(rst_n),
        .A(A),
        .B(B),
        .O(O),
        .State(State)
    );

    // Clock generation
    always begin
        #5 clk = ~clk;
    end

    integer i;
    reg [3:0] expected_state;
    reg expected_O;

    localparam S0 = 4'b0001;
    localparam S1 = 4'b0010;
    localparam S2 = 4'b0100;
    localparam S3 = 4'b1000;

    integer errors;
    integer test_num;

    // ADDED: Mealy output function, same rules as abro_fsm's O
    function mealy_O(input [3:0] st, input a, input b);
        begin
            case (st)
                S0:      mealy_O = a | b; // IDLE -> STATE_A or STATE_B
                S1:      mealy_O = b;     // STATE_A -> STATE_AB
                S2:      mealy_O = a;     // STATE_B -> STATE_AB
                default: mealy_O = 1'b0;  // STATE_AB never drives O
            endcase
        end
    endfunction

    // Apply one set of inputs, clock once, then check
    task apply_and_check(input a_in, input b_in);
        begin
            // Drive inputs on the FALLING edge so they are stable
            // well before the rising edge (avoids a race with the DUT)
            @(negedge clk);
            A = a_in;
            B = b_in;

            // CHANGED: model now follows the abro_fsm rules
            //   IDLE(S0)     --A-->          STATE_A(S1)
            //   IDLE(S0)     --B (no A)-->   STATE_B(S2)
            //   STATE_A(S1)  --B-->          STATE_AB(S3)
            //   STATE_A(S1)  --!A (no B)-->  IDLE
            //   STATE_B(S2)  --A-->          STATE_AB(S3)
            //   STATE_B(S2)  --!B (no A)-->  IDLE
            //   STATE_AB(S3) --!A && !B-->   IDLE
            case (expected_state)
                S0: begin
                    if (A)       expected_state = S1;
                    else if (B)  expected_state = S2;
                end
                S1: begin
                    if (B)       expected_state = S3;
                    else if (!A) expected_state = S0;
                end
                S2: begin
                    if (A)       expected_state = S3;
                    else if (!B) expected_state = S0;
                end
                S3: if (!A && !B) expected_state = S0;
                default:          expected_state = S0;
            endcase

            // O is MEALY in abro_fsm: it depends on the current state
            // AND the inputs. After the edge, the DUT is in the new state
            // with the same A/B still applied, so compute O from that.
            expected_O = mealy_O(expected_state, A, B);

            // Wait for the rising edge, then a little longer so the
            // DUT's nonblocking (<=) update has finished
            @(posedge clk);
            #1;

            if (O !== expected_O || State !== expected_state) begin
                $display("Error: Test case %0d failed (A=%b, B=%b)", test_num, A, B);
                $display("  Expected: O=%b, State=%b", expected_O, expected_state);
                $display("  Got: O=%b, State=%b", O, State);
                errors = errors + 1;
            end
            test_num = test_num + 1;
        end
    endtask

    // Test stimulus and checking
    initial begin
        // Initialize signals
        clk = 0;
        rst_n = 1;
        A = 0;
        B = 0;


        // CHANGED: replaced the old case(i) expected-value logic
        errors   = 0;
        test_num = 0;

        // Reset and check we land in S0 with O=0
        rst_n = 0;
        #1;
        expected_state = S0;
        expected_O     = 1'b0;
        if (O !== expected_O || State !== expected_state) begin
            $display("Error: Reset failed. Expected: O=%b, State=%b  Got: O=%b, State=%b",
                     expected_O, expected_state, O, State);
            errors = errors + 1;
        end
        @(negedge clk);
        rst_n = 1;

        // Directed tests: walk every transition on purpose
        // CHANGED: directed tests walk every abro_fsm transition
        apply_and_check(0, 0); // IDLE stays
        apply_and_check(1, 0); // IDLE -> STATE_A
        apply_and_check(1, 0); // STATE_A stays (A held, no B)
        apply_and_check(0, 0); // STATE_A -> IDLE (A dropped)
        apply_and_check(0, 1); // IDLE -> STATE_B
        apply_and_check(0, 1); // STATE_B stays (B held, no A)
        apply_and_check(0, 0); // STATE_B -> IDLE (B dropped)
        apply_and_check(1, 0); // IDLE -> STATE_A
        apply_and_check(1, 1); // STATE_A -> STATE_AB
        apply_and_check(1, 0); // STATE_AB stays (not both low)
        apply_and_check(0, 0); // STATE_AB -> IDLE
        apply_and_check(0, 1); // IDLE -> STATE_B
        apply_and_check(1, 1); // STATE_B -> STATE_AB
        apply_and_check(0, 0); // STATE_AB -> IDLE
        apply_and_check(1, 1); // IDLE -> STATE_A (A checked first)

        // Random tests: the model tells us the answer every cycle
        for (i = 0; i < 50; i = i + 1) begin
            apply_and_check($random, $random);
        end

        // Async reset in the middle of a run
        apply_and_check(1, 0); // make sure we're not already in S0
        rst_n = 0;
        #1;
        expected_state = S0;
        
        // CHANGED: Mealy O in IDLE follows the inputs (A=1 is still held)
        expected_O     = mealy_O(S0, A, B);
        
        if (O !== expected_O || State !== expected_state) begin
            $display("Error: Async reset failed. Expected: O=%b, State=%b  Got: O=%b, State=%b",
                     expected_O, expected_state, O, State);
            errors = errors + 1;
        end

        if (errors == 0)
            $display("All test cases passed.");
        else
            $display("%0d test case(s) failed.", errors);
        $finish;

    end


	reg vcd_clk;
initial begin
    $dumpfile("my_design.vcd");
    $dumpvars(0, tb_abro_state_machine);
end

always #5 vcd_clk = ~vcd_clk; // Toggle clock every 5 time units

endmodule