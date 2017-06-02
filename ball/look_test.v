`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:03:23 05/17/2017
// Design Name:   look
// Module Name:   E:/ball/look_test.v
// Project Name:  ball
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: look
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module look_test;

	// Inputs
	reg clk;
	reg BRPad1;
	reg BRPad2;
	reg BRBall;
	reg BRWall;
	reg BRIW;

	// Outputs
	wire vga_red;
	wire vga_green;
	wire vga_blue;

	// Instantiate the Unit Under Test (UUT)
	look uut (
		.clk(clk), 
		.BRPad1(BRPad1), 
		.BRPad2(BRPad2), 
		.BRBall(BRBall), 
		.BRWall(BRWall), 
		.BRIW(BRIW), 
		.vga_red(vga_red), 
		.vga_green(vga_green), 
		.vga_blue(vga_blue)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		BRPad1 = 0;
		BRPad2 = 0;
		BRBall = 0;
		BRWall = 0;
		BRIW = 0;

		// Wait 100 ns for global reset to finish
		#120;
		{BRPad1,BRPad2,BRBall,BRWall,BRIW}=5'b00001;
		#100 {BRPad1,BRPad2,BRBall,BRWall,BRIW}=5'b00001;
		#100 {BRPad1,BRPad2,BRBall,BRWall,BRIW}=5'b00010;
		#100 {BRPad1,BRPad2,BRBall,BRWall,BRIW}=5'b00100;
		#100 {BRPad1,BRPad2,BRBall,BRWall,BRIW}=5'b01000;
		#100 {BRPad1,BRPad2,BRBall,BRWall,BRIW}=5'b10000;
		#100 {BRPad1,BRPad2,BRBall,BRWall,BRIW}=5'b11100;
		
		#100 $stop;
		
        
		// Add stimulus here

	end
	
	initial 
	begin
	clk = 0;
	forever
	begin
		#20 clk<=~clk;
	end
	end
	
      
endmodule

