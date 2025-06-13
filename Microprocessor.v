`timescale 1ns / 1ps
module Microprocessor(
        input wire clk_50m,
        input wire reset,
        input wire [7:0] instr, // testbench provides this
        output reg [7:0] pc,
        output wire [6:0] seg_hi,
        output wire [6:0] seg_lo,
		  output wire [6:0] seg_op,
		  output wire [6:0] seg_pc_hi,
		  output wire [6:0] seg_pc_lo
    );
	 
	 wire [7:0] display_data;
	 
	 // 7-seg (wdata)
    // seven_seg u_seg(.data(display_data), .seg_hi(seg_hi), .seg_lo(seg_lo));
    
    // 1Hz clk
    wire clk_1s;
    clock_div ClockDivider(.clk_50m(clk_50m), .reset(reset), .clk_1s(clk_1s));

    // Decode
    wire [1:0] op   = instr[7:6];
    wire [1:0] rs   = instr[5:4];
    wire [1:0] rt   = instr[3:2];
    wire [1:0] rd   = instr[1:0];
    wire [1:0] imm2 = instr[1:0];

    // Control
    wire RegDst, RegWrite, ALUSrc, Branch, MemRead, MemWrite, MemtoReg;
    control_unit Control_Unit(.op(op), .RegDst(RegDst), .RegWrite(RegWrite), .ALUSrc(ALUSrc), 
										.Branch(Branch), .MemRead(MemRead), .MemWrite(MemWrite), .MemtoReg(MemtoReg));

    // Reg Fetch
    wire [1:0] waddr = RegDst ? rd : rt;
    wire [7:0] reg_r1, reg_r2, reg_wdata;
	 
    register_file RegFile(.clk(clk_1s), .reset(reset),
                        .we(RegWrite), .raddr1(rs), .raddr2(rt),
                        .waddr(waddr), .wdata(reg_wdata),
                        .rdata1(reg_r1), .rdata2(reg_r2));

    // ALU
    wire [7:0] alu_b = ALUSrc ? {{6{imm2[1]}}, imm2} : reg_r2;
    wire [7:0] alu_y;
    alu ALU(.a(reg_r1), .b(alu_b), .y(alu_y));

    // DMem
    wire [7:0] mem_rdata;
    data_memory DMem(.clk(clk_1s), .reset(reset),
                        .memread(MemRead), .memwrite(MemWrite),
                        .addr(alu_y[4:0]), .wdata(reg_r2),
                        .rdata(mem_rdata));

    // WB
    assign reg_wdata = MemtoReg ? mem_rdata : alu_y;
	 
	 //assign display_data = RegWrite ? reg_wdata : 8'h00;
	 
	 // display
	 seven_seg u_seglo(.data(reg_wdata[3:0]), .write(RegWrite), .seg(seg_lo));
	 seven_seg u_seghi(.data(reg_wdata[7:4]), .write(RegWrite), .seg(seg_hi));
	 optoseg op2seg(.op(op), .seg(seg_op));
	 
	 seven_seg segpclo(.data(pc[3:0]), .write(1), .seg(seg_pc_lo));
	 seven_seg segpchi(.data(pc[7:4]), .write(1), .seg(seg_pc_hi));
	 
	 /*always @(posedge clk_1s or posedge reset) begin
    if (reset)
        display_data <= 8'h00;
    else
        display_data <= reg_wdata;
	 end*/

   initial begin
		pc = 0;
	end

	always @(posedge reset or posedge clk_1s) begin
		if (reset)
			pc <= 0;
		else
			pc <= Branch == 0 ? pc + 1 : pc + 1 + imm2;
	end

endmodule
