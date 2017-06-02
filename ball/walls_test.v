`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:25:50 05/17/2017
// Design Name:   walls
// Module Name:   E:/ball/walls_test.v
// Project Name:  ball
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: walls
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module walls_test;

	// Inputs
	reg clk;
	reg [8:0] line;
	reg [9:0] pixel;

	// Outputs
	wire BitRaster;
	wire BitRasterIW;

	// Instantiate the Unit Under Test (UUT)
	walls uut (
		.clk(clk), 
		.line(line), 
		.pixel(pixel), 
		.BitRaster(BitRaster), 
		.BitRasterIW(BitRasterIW)
	);

	initial begin
		// Initialize Inputs
		clk = 0;
		line = 0;
		pixel = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

