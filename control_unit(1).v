`timescale 1ns / 1ps
module control_unit(
    input  wire [1:0] op,          // instr[7:6]
    output reg        RegDst,
    output reg        RegWrite,
    output reg        ALUSrc,
    output reg        Branch,      // j 
    output reg        MemRead,
    output reg        MemWrite,
    output reg        MemtoReg
);
    always @(*) begin
        {RegDst, RegWrite, ALUSrc, Branch, MemRead, MemWrite, MemtoReg} = 7'b0;
        case (op)
            2'b00:   {RegDst,RegWrite} = 2'b11; // add 
            2'b01:   {RegWrite,ALUSrc,MemRead,MemtoReg} = 4'b1111; // lw
            2'b10:   {ALUSrc,MemWrite} = 2'b11; // sw 
            2'b11:   Branch = 1'b1; // j
        endcase
    end
endmodule