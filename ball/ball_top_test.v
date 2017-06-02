`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:57:57 05/17/2017
// Design Name:   ball_top
// Module Name:   C:/Users/zhenyu/Documents/ise/system/ball/ball_top_test.v
// Project Name:  ball
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ball_top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module ball_top_test;

	// Inputs
	reg reset;
	reg clk_25MHz;
	reg clk_12MHz;
	reg kb_clk;
	reg kb_data;
	reg reset_game;

	// Outputs
	wire red;
	wire green;
	wire blue;
	wire speaker;
	wire h_sync;
	wire v_sync;
	wire [6:0] left;
	wire [6:0] right;

	// Bidirs
	wire mouse_clk;
	wire mouse_data;

	// Instantiate the Unit Under Test (UUT)
	ball_top uut (
		.reset(reset), 
		.clk_25MHz(clk_25MHz), 
		.clk_12MHz(clk_12MHz), 
		.kb_clk(kb_clk), 
		.kb_data(kb_data), 
		.mouse_clk(mouse_clk), 
		.mouse_data(mouse_data), 
		.reset_game(reset_game), 
		.red(red), 
		.green(green), 
		.blue(blue), 
		.speaker(speaker), 
		.h_sync(h_sync), 
		.v_sync(v_sync), 
		.left(left), 
		.right(right)
	);

	initial begin
		// Initialize Inputs
		reset = 1;
		kb_clk = 0;
		kb_data = 0;
		reset_game = 1;

		// Wait 100 ns for global reset to finish
		#100 reset=0;
      #100 reset=1;
		// Add stimulus here
		
		

	end
	
	initial 
	begin
	clk_25MHz = 0;
	forever
	begin
		#20 clk_25MHz<=~clk_25MHz;
	end
	end
	
	initial 
	begin
	clk_12MHz = 0;
	forever
	begin
		#40 clk_12MHz<=~clk_12MHz;
	end
	end
      
      
endmodule

