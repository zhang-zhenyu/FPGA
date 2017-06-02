`timescale 1us / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:07:57 04/19/2017
// Design Name:   add_tree
// Module Name:   C:/Users/zhenyu/Documents/ise/system/add_tree_multi/add_tree_test.v
// Project Name:  add_tree_multi
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: add_tree
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module add_tree_test;

	// Inputs
	reg clk_10kHz;
	reg clrn;
	reg [7:0] a;
	reg [7:0] b;

	// Outputs
	wire [15:0] p;
	wire [19:0] p_BCD;

	// Instantiate the Unit Under Test (UUT)
	add_tree uut (
		.clk_10kHz(clk_10kHz), 
		.clrn(clrn), 
		.a(a), 
		.b(b), 
		.p(p), 
		.p_BCD(p_BCD)
	);

	initial
begin
//clk_10kHz = 0;


a = 0;
b = 0;
clrn = 0;
#10 clrn = 1;
#100 a=8'd1;
b=8'd1;
#100 a=8'd2;
b=8'd2;
#100 a=8'd3;
b=8'd3;
#100 a=8'd10;
b=8'd20;
#100 a=8'd35;
b=8'd20;
#100 a=8'd125;
b=8'd3;
#100 a=8'd150;
b=8'd40;
#100 a=8'd254;
b=8'd10;
#100 a=8'd254;
b=8'd11;
//¡­¡­
#1000 $stop; //1msºóÍ£Ö¹·ÂÕæ
end

initial
begin
clk_10kHz = 0;
forever #50 clk_10kHz<=~clk_10kHz;
end 
endmodule

