`timescale 1us / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:42:35 04/19/2017
// Design Name:   add_tree_sim
// Module Name:   C:/Users/zhenyu/Documents/ise/system/add_tree_multi/add_tree_sim_test.v
// Project Name:  add_tree_multi
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: add_tree_sim
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module add_tree_sim_test;

	// Inputs
	reg clk_10kHz;
	reg clk_1kHz;
	reg clrn;
	reg [7:0] a;
	reg [7:0] b;

	// Outputs
	wire [15:0] p;
	wire [19:0] p_BCD;
	wire [3:0] scan_data_1;
	wire scan_en_1;
	wire [3:0] scan_data_0;
	wire [3:0] scan_en_0;
	wire [6:0] data_1_7seg;
	wire [6:0] data_0_7seg;

	// Instantiate the Unit Under Test (UUT)
	add_tree_sim uut (
		.clk_10kHz(clk_10kHz), 
		.clk_1kHz(clk_1kHz), 
		.clrn(clrn), 
		.a(a), 
		.b(b), 
		.p(p), 
		.p_BCD(p_BCD), 
		.scan_data_1(scan_data_1), 
		.scan_en_1(scan_en_1), 
		.scan_data_0(scan_data_0), 
		.scan_en_0(scan_en_0), 
		.data_1_7seg(data_1_7seg), 
		.data_0_7seg(data_0_7seg)
	);

	initial
begin
clk_10kHz = 0;
clk_1kHz = 0;
a = 0;
b = 0;
clrn = 0;
#10 clrn = 1;
#1000 a=8'd1; //1ms后改变a、b数值
b=8'd1;
#5000 a=8'd2; //5ms后改变a、b数值
b=8'd2;
#5000 a=8'd3;
b=8'd3;
#5000 a=8'd10;
b=8'd20;
#5000 a=8'd35;
b=8'd20;
#5000 a=8'd125;
b=8'd3;
#5000 a=8'd150;
b=8'd40;
#5000 a=8'd254;
b=8'd10;
#5000 a=8'd254;
b=8'd11;
//…… //赋予a、b其他数值
#5000 $stop; //5ms后停止仿真
end

initial 
begin
clk_10kHz = 0;
forever  #50 clk_10kHz<=~clk_10kHz;
end

initial 
begin
clk_1kHz = 0;
forever  #500 clk_1kHz<=~clk_1kHz;
end
     
      
endmodule

