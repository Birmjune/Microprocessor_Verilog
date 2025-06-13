// 수정 후: FPGA 보드에서 단독 실행을 위한 코드
`timescale 1ns / 1ps
module Microprocessor_with_test(
        input wire clk_50m,
        input wire reset,
        // input wire [7:0] instr,       // <<-- 1. 더 이상 외부에서 명령어를 받지 않으므로 삭제
		  // input wire [7:0] test_pc,       // <<-- 테스트벤치용이므로 삭제 또는 주석 처리
        output wire [7:0] pc,
        output wire [6:0] seg_hi,
        output wire [6:0] seg_lo,
		  output wire [6:0] seg_op,
		  output wire [6:0] seg_pc_hi,
		  output wire [6:0] seg_pc_lo,
        output wire [7:0] current_instruction_debug // <<-- 디버깅용 출력 이름 변경 (선택 사항)
    );

    // 2. 프로세서에 공급할 내부 명령어를 위한 와이어 선언
    wire [7:0] instruction_from_rom;
    wire [7:0] MemByte[31:0];
	assign MemByte[0] = 8'b01001001;
	assign MemByte[1] = 8'b11000001;
	assign MemByte[2] = 8'b00011000;
	assign MemByte[3] = 8'b10101001;
	assign MemByte[4] = 8'b01001101;
	
	assign MemByte[5] = 8'b01001001;
	assign MemByte[6] = 8'b00011000;
	assign MemByte[7] = 8'b10101001;
	assign MemByte[8] = 8'b01001101;
	
	assign MemByte[9] = 8'b00000000;
	assign MemByte[10] = 8'b01000101;
	assign MemByte[11] = 8'b11000010; // negative jump check

    // 3. 프로세서의 'pc' 출력을 메모리의 주소로 사용
    // 이것이 바로 "Instruction Fetch" 단계에 해당합니다.
    assign instruction_from_rom = MemByte[pc];


    Microprocessor microprocessor(
        .clk_50m(clk_50m),
        .reset(reset),
        .instr(instruction_from_rom), // <<-- 4. 내부 메모리에서 가져온 명령어를 프로세서에 연결
        .pc(pc),
        .seg_hi(seg_hi),
        .seg_lo(seg_lo),
		  .seg_op(seg_op),
		  .seg_pc_hi(seg_pc_hi),
		  .seg_pc_lo(seg_pc_lo)
    );

    // 내부 명령어 메모리 (ROM)

	

	// 디버깅을 위해 현재 실행 중인 명령어를 외부로 출력
	assign current_instruction_debug = instruction_from_rom;

endmodule
