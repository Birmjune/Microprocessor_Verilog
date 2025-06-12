`timescale 1ns / 1ps
module optoseg(
    input [1:0] op,
    output reg [6:0] seg
    );
	
	always @(*) begin
		case (op)
			2'b00: seg = 7'b1110111; //Add
			2'b01: seg = 7'b0001110; //Load
			2'b10: seg = 7'b1011011; //Store
			2'b11: seg = 7'b0111000; //Jump
		endcase
	end

endmodule
