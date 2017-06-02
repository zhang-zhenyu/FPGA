`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:43:04 05/16/2017
// Design Name:   syncgen
// Module Name:   C:/Users/zhenyu/Documents/ise/system/ball/syncgen_test.v
// Project Name:  ball
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: syncgen
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module syncgen_test;

	// Inputs
	reg reset;
	reg clk;

	// Outputs
	wire v_sync;
	wire h_sync;
	wire [8:0] line;
	wire [9:0] pixel;

	// Instantiate the Unit Under Test (UUT)
	syncgen uut (
		.reset(reset), 
		.clk(clk), 
		.v_sync(v_sync), 
		.h_sync(h_sync), 
		.line(line), 
		.pixel(pixel)
	);

	initial begin
		// Initialize Inputs
		
		
		reset = 1;
		// Wait 100 ns for global reset to finish
		#100 reset=0;
		#215 reset=1;
		
		#100_000_000  $stop;

        
		// Add stimulus here

	end
	
	initial 
		begin
			clk = 0;
			forever 
				begin
				#20 clk=~clk;
				end
		end 
		
endmodule

