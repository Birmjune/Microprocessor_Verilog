`timescale 1ns / 1ps

module TestProcessorTest;
	reg clk_50m;
	reg reset;
	reg [7:0] instr;
	reg [7:0] test_pc;
    wire [7:0] pc;
    wire [6:0] seg_hi;
    wire [6:0] seg_lo;
	 wire [6:0] seg_op;
    wire [7:0] test_instruction;

	Microprocessor_with_test uut (
		.clk_50m(clk_50m),
        .reset(reset),
        .instr(instr),
        .test_pc(test_pc),
        .pc(pc),
        .seg_hi(seg_hi),
        .seg_lo(seg_lo),
		  .seg_op(seg_op),
        .test_instruction(test_instruction)
	);

	initial begin
		clk_50m = 0;
		reset = 0;
		instr = 0;
		test_pc = 0;
		#10;
		reset = 1;
		#10;
		reset = 0;
		#300;
		reset=1;
		#10;
		reset=0;
	end

	always begin
		clk_50m = 1;
		#1;
		clk_50m = 0;
		#1;
	end

	always @(pc) begin
		test_pc <= pc;
	end

	always @(test_instruction) begin
		instr <= test_instruction;
	end
	

endmodule