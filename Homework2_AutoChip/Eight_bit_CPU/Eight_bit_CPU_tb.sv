`timescale 1ns/1ps

//==================================================
module tb;                       // renamed from Eight_bit_CPU_tb
//==================================================

reg clk;
reg reset;
reg [7:0] data_in;
wire [7:0] data_out;
wire [7:0] address;
wire mem_read;
wire mem_write;

integer errors;
integer i;

Eight_bit_CPU dut (
    .clk(clk),
    .reset(reset),
    .data_in(data_in),
    .data_out(data_out),
    .address(address),
    .mem_read(mem_read),
    .mem_write(mem_write)
);

initial clk = 1'b0;
always #5 clk = ~clk;

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

task do_fetch;
    begin
        @(posedge clk);
        @(negedge clk);
    end
endtask

task do_execute;
    begin
        @(posedge clk);
        @(negedge clk);
    end
endtask

initial begin
    //==================================================
    // removed $dumpfile / $dumpvars (they referenced the old module name)
    //==================================================
    errors  = 0;
    data_in = 8'h00;
    reset   = 1'b1;

    for (i = 0; i < 256; i = i + 1)
        dut.RAM[i] = 8'h00;

    // ---------------- Program ----------------
    dut.RAM[0]  = 8'h1E; // LOAD  14   ACC = 05
    dut.RAM[1]  = 8'h3F; // ADD   15   ACC = 08
    dut.RAM[2]  = 8'h2D; // STORE 13   RAM[13] = 08
    dut.RAM[3]  = 8'h4F; // SUB   15   ACC = 05
    dut.RAM[4]  = 8'h80; // INC        ACC = 06
    dut.RAM[5]  = 8'h90; // DEC        ACC = 05
    dut.RAM[6]  = 8'h5F; // AND   15   ACC = 01
    dut.RAM[7]  = 8'h6F; // OR    15   ACC = 03
    dut.RAM[8]  = 8'h70; // NOT        ACC = FC
    dut.RAM[9]  = 8'hD0; // IN         ACC = 00
    dut.RAM[10] = 8'hBB; // JZ    11
    dut.RAM[11] = 8'h80; // INC        ACC = 01
    dut.RAM[12] = 8'hC0; // OUT        data_out = 01
    // ---------------- Data -------------------
    dut.RAM[13] = 8'h00;
    dut.RAM[14] = 8'h05;
    dut.RAM[15] = 8'h03;

    repeat (2) @(posedge clk);
    @(negedge clk);
    reset = 1'b0;

    check8(dut.PC,  8'h00, "reset PC");
    check8(dut.ACC, 8'h00, "reset ACC");

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

    do_fetch; do_execute;
    check8(dut.PC, 8'h0B, "JZ -> PC");

    do_fetch; do_execute;
    do_fetch; do_execute;
    check8(data_out, 8'h01, "OUT after JZ");

    $display("----------------------------------------");
    if (errors == 0) $display("ALL TESTS PASSED");
    else             $display("%0d TEST(S) FAILED", errors);
    $display("----------------------------------------");
    $finish;
end

initial begin
    #2000;
    $display("TIMEOUT");
    $finish;
end

//==================================================
final begin
    $display("Mismatches: %0d in %0d samples", errors, 15);
end
//==================================================
endmodule
