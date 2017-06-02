`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:53:21 03/22/2017
// Design Name:   encoder16_4
// Module Name:   C:/Users/zhenyu/Documents/ise/system/encoder8_3/encoder16_4/encoder16_4test.v
// Project Name:  encoder16_4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: encoder16_4
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module encoder16_4test;

	// Inputs
	reg EI;
	reg [15:0] I;

	// Outputs
	wire [3:0] Z;
	wire GS;
	wire EO;

	// Instantiate the Unit Under Test (UUT)
	encoder16_4 uut (
		.EI(EI), 
		.I(I), 
		.Z(Z), 
		.GS(GS), 
		.EO(EO)
	);

	initial 
	begin
	EI = 0; //允许编码器工作
	I = 0;
	#10 I =16'b0011010100000011; //3503H，I15优先编码
	//#30 I =16'b1111001101001000; //F348H，I11优先编码
	#30 I =16'b1001000000110010; //9032H，I14优先编码
	#30 I =16'b1111001101001000; //F348H，I11优先编码
	#30 I =16'b1111111100101101; //FF2DH，I7优先编码
	#30 EI = 1; //禁止编码器工作
	I=16'b0000111111111111; //0FFFH
	#30 EI = 0;
	#30 I =16'b1111111111111101; //FFFDH，I1优先编码
	#30 I = 16'b1111111111111111; //FFFFH，没有编码输
	end
      
endmodule

