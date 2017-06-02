`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   20:14:05 03/20/2017
// Design Name:   PriEncoder8_3
// Module Name:   W:/ise/exercise/ecode83/PriEncoder8_3test.v
// Project Name:  ecode83
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: PriEncoder8_3
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module PriEncoder8_3test;

	// Inputs
	reg EI;
	reg [7:0] I;

	// Outputs
	wire [2:0] A;
	wire GS;
	wire EO;

	// Instantiate the Unit Under Test (UUT)
	PriEncoder8_3 uut (
		.EI(EI), 
		.I(I), 
		.A(A), 
		.GS(GS), 
		.EO(EO)
	);

	initial 
	begin
		// Initialize Inputs
		EI = 0;
		I = 8'b0000_0000;
		#20 I = 8'b00111000; //I7优先编码
		#30 I = 8'b10011011;
		#30 EI=1; //禁止编码器工作
		I = 8'b10001001;
		#30 I = 8'b10100100;
		#30 EI=0; //允许编码器工作
		I = 8'b11001010; //I5优先编码
		#30 I = 8'b11110011; //I4优先编码
		#30 I = 8'b11100101; //I4优先编码
		#30 I = 8'b11111111; //没有编码输入
		#30 I = 8'b11111100; //I1优先编码
	end


      
endmodule

