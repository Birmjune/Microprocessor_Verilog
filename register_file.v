`timescale 1ns / 1ps

module register_file(
    input  wire       clk,
    input  wire       reset,
    input  wire       we,
    input  wire [1:0] raddr1, raddr2,
    input  wire [1:0] waddr,
    input  wire [7:0] wdata,
    output wire [7:0] rdata1, rdata2
);
    reg [7:0] regs [3:0]; // register file
    integer i;

    initial begin 
		for (i = 0; i < 4; i = i + 1)
			regs[i] <= 0;
	 end

    assign rdata1 = regs[raddr1];
    assign rdata2 = regs[raddr2];
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i=0; i<4; i=i+1) regs[i] <= 8'd0; // reset 
        end else begin
            if (we) 
                regs[waddr] <= wdata;
        end
    end

endmodule
