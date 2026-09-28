// Let us make a brand new microprocessor design together. We're severely
// constrained on space and I/O. We have to fit in 1000 standard cells of an
// ASIC, so I think we will need to restrict ourselves to an accumulator based
// 8-bit architecture with no multi-byte instructions.
//
// The design must use: reg [7:0] RAM [0:255] for program and data memory,
// and 8-bit registers named PC and ACC. reset is active-high.

module Eight_bit_CPU(
	input clk,
	input reset,
	input [7:0] data_in,
	output [7:0] data_out,
	output [7:0] address,
	output mem_read,
	output mem_write
);
