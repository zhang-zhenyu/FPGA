`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:14:31 05/17/2017
// Design Name:   clkdiv
// Module Name:   E:/ball/clkdiv_test.v
// Project Name:  ball
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clkdiv
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clkdiv_test;

	// Inputs
	reg reset;
	reg clk_25MHz;
	reg clk_12MHz;

	// Outputs
	wire clk_6MHz;
	wire clk_10Hz;

	// Instantiate the Unit Under Test (UUT)
	clkdiv uut (
		.reset(reset), 
		.clk_25MHz(clk_25MHz), 
		.clk_12MHz(clk_12MHz), 
		.clk_6MHz(clk_6MHz), 
		.clk_10Hz(clk_10Hz)
	);

	initial begin
		// Initialize Inputs
		reset = 1;


		// Wait 100 ns for global reset to finish
		#100;
		reset=0;
        
		  	#100;
		reset=1;
        
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

