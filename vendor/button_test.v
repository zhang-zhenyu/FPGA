`timescale 1ms / 1us

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:47:36 03/29/2017
// Design Name:   button
// Module Name:   C:/Users/zhenyu/Documents/ise/system/encoder8_3/second/buttontest.v
// Project Name:  second
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: button
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module buttontest;

	// Inputs
	reg clk_1kHz;
	reg pbn;

	// Outputs
	wire [6:0] cnt; //加法计数器，用于定时
	//wire enableb; //用于维持计数

	// Instantiate the Unit Under Test (UUT)
	button uut (
		.clk_1kHz(clk_1kHz), 
		.pbn(pbn), 
		.signal(signal)
	);

	initial 
begin
clk_1kHz = 0;
pbn = 1;
#6 pbn=1'b0;//模拟产生多个负脉冲
#4 pbn=1'b0;
#3 pbn=1'b1;
#2 pbn=1'b0;
#2 pbn=1'b1;
#130 pbn=1'b0; //再次模拟产生多个负脉冲
#5 pbn=1'b1;
#4 pbn=1'b0;
#3 pbn=1'b1;
#200 $stop; //200ms后停止仿真
end
//给中间变量赋值
assign cnt = uut.cnt;
//assign enableb = uut.enableb;
//赋予输入时钟激励
always #0.5 clk_1kHz=~clk_1kHz;

      
endmodule

