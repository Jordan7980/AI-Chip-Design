`timescale 1ns/1ps

//==========================================================================================
//==========================================================================================
//  ADDED: Testbench for Eight_bit_CPU  (entire file is new)
//==========================================================================================
//==========================================================================================

module Eight_bit_CPU_tb;

// Testbench signals (inputs to the DUT are reg, outputs from the DUT are wire)
reg clk;
reg reset;
reg [7:0] data_in;
wire [7:0] data_out;
wire [7:0] address;
wire mem_read;
wire mem_write;

integer errors;
integer i;

// Device Under Test
Eight_bit_CPU dut (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .data_out(data_out),
    .address(address),
    .mem_read(mem_read),
    .mem_write(mem_write)
);

// Clock: 10 ns period
initial clk = 1'b0;
always #5 clk = ~clk;

// Compare a value to what we expect and print PASS / FAIL
task check8;
    input [7:0] actual;
    input [7:0] expected;
    input [8*16:1] name;
    begin
        if (actual !== expected) begin
            $display("FAIL  %0s : got %h, expected %h   (t=%0t)", name, actual, expected, $time);
            errors = errors + 1;
        end else begin
            $display("PASS  %0s : %h", name, actual);
        end
    end
endtask

// Fetch cycle: posedge loads IR (ALU always block reacts right away),
// then wait for negedge so everything has settled before checking
task do_fetch;
    begin
        @(posedge clk);
        @(negedge clk);
    end
endtask

// Execute cycle: posedge does PC <= PC + 1 and goes back to fetch state
task do_execute;
    begin
        @(posedge clk);
        @(negedge clk);
    end
endtask

// Main test
initial begin
    $dumpfile("Eight_bit_CPU_tb.vcd");
    $dumpvars(0, Eight_bit_CPU_tb);

    errors  = 0;
    data_in = 8'h00;   // IN instruction will read 0 -> sets up the JZ test
    reset   = 1'b1;

    // RAM is internal to the CPU (no load port), so we write it directly
    // through a hierarchical reference: dut.RAM[...]
    for (i = 0; i < 256; i = i + 1)
        dut.RAM[i] = 8'h00;

    // ---------------- Program ----------------
    // format: {opcode[7:4], operand[3:0]}
    dut.RAM[0]  = 8'h1E; // LOAD  14   ACC = 05
    dut.RAM[1]  = 8'h3F; // ADD   15   ACC = 05 + 03 = 08
    dut.RAM[2]  = 8'h2D; // STORE 13   RAM[13] = 08
    dut.RAM[3]  = 8'h4F; // SUB   15   ACC = 08 - 03 = 05
    dut.RAM[4]  = 8'h80; // INC        ACC = 06
    dut.RAM[5]  = 8'h90; // DEC        ACC = 05
    dut.RAM[6]  = 8'h5F; // AND   15   ACC = 05 & 03 = 01
    dut.RAM[7]  = 8'h6F; // OR    15   ACC = 01 | 03 = 03
    dut.RAM[8]  = 8'h70; // NOT        ACC = FC
    dut.RAM[9]  = 8'hD0; // IN         ACC = data_in = 00
    dut.RAM[10] = 8'hBB; // JZ    11   ACC == 0, so PC should go to 11
    dut.RAM[11] = 8'h80; // INC        ACC = 01   (only runs if JZ lands on 11)
    dut.RAM[12] = 8'hC0; // OUT        data_out = ACC
    // ---------------- Data -------------------
    dut.RAM[13] = 8'h00; // STORE target
    dut.RAM[14] = 8'h05;
    dut.RAM[15] = 8'h03;

    // Hold reset for a couple of clocks, release on a negedge
    repeat (2) @(posedge clk);
    @(negedge clk);
    reset = 1'b0;

    // Reset values
    check8(dut.PC,  8'h00, "reset PC");
    check8(dut.ACC, 8'h00, "reset ACC");

    // Each instruction = 1 fetch cycle + 1 execute cycle
    do_fetch; check8(address, 8'h00, "fetch addr 0");
              check8(dut.ACC, 8'h05, "LOAD 14");       do_execute;
    do_fetch; check8(dut.ACC, 8'h08, "ADD 15");        do_execute;
    do_fetch; check8(dut.RAM[13], 8'h08, "STORE 13");  do_execute;
    do_fetch; check8(dut.ACC, 8'h05, "SUB 15");        do_execute;
    do_fetch; check8(dut.ACC, 8'h06, "INC");           do_execute;
    do_fetch; check8(dut.ACC, 8'h05, "DEC");           do_execute;
    do_fetch; check8(dut.ACC, 8'h01, "AND 15");        do_execute;
    do_fetch; check8(dut.ACC, 8'h03, "OR 15");         do_execute;
    do_fetch; check8(dut.ACC, 8'hFC, "NOT");           do_execute;
    do_fetch; check8(dut.ACC, 8'h00, "IN");            do_execute;

    // JZ: after the execute cycle PC should be sitting on the target (11)
    do_fetch; do_execute;
    check8(dut.PC, 8'h0B, "JZ -> PC");

    // Two more instructions: correct jump runs INC then OUT -> data_out = 01
    do_fetch; do_execute;
    do_fetch; do_execute;
    check8(data_out, 8'h01, "OUT after JZ");

    // Summary
    $display("----------------------------------------");
    if (errors == 0) $display("ALL TESTS PASSED");
    else             $display("%0d TEST(S) FAILED", errors);
    $display("----------------------------------------");
    $finish;
end

// Watchdog so the sim can't hang forever
initial begin
    #2000;
    $display("TIMEOUT");
    $finish;
end

endmodule

//==========================================================================================
//==========================================================================================
//  END OF ADDED TESTBENCH
//==========================================================================================
//==========================================================================================
