`timescale 1ns / 1ps
module data_memory(
    input wire clk,
    input wire reset,
    input wire memread,
    input wire memwrite,
    input wire [4:0] addr,  // 0x00~0x1F
    input wire [7:0] wdata,
    output wire [7:0] rdata
);

    reg [7:0] mem [31:0]; // memory
    integer k;
		
	 assign rdata = mem[addr];
	 
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (k=0; k<16; k=k+1) mem[k] <= k;
            for (k=16; k<32; k=k+1) mem[k] <= 16-k; 
        end else begin
            if (memwrite) mem[addr] <= wdata;
        end
    end

    // always @(*) rdata = memread ? mem[addr] : 8'd0;
endmodule
