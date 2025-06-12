`timescale 1ns / 1ps
module clock_div(
    input  wire clk_50m,
    input  wire reset,
    output reg  clk_1s
);
    localparam DIV = 25000000;
    reg [25:0] cnt;

    always @(posedge clk_50m or posedge reset) begin
        if (reset) begin
            cnt    <= 0;
            clk_1s <= 0;
        end else if (cnt == DIV-1) begin
            cnt    <= 0;
            clk_1s <= ~clk_1s;
        end else
            cnt <= cnt + 1;
    end
endmodule