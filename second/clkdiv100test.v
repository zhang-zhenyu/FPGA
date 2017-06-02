`timescale 1us / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:25:54 03/29/2017
// Design Name:   clkdiv100
// Module Name:   G:/second/clkdiv100test.v
// Project Name:  second
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clkdiv100
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
// ‰»Î10k£¨ ‰≥ˆ100
module clkdiv100test;

	// Inputs
	reg clkin;
	reg en;
	reg clrn;

	// Outputs
	wire clkout;

	// Instantiate the Unit Under Test (UUT)
	clkdiv100 uut (
		.clkin(clkin), 
		.en(en), 
		.clrn(clrn), 
		.clkout(clkout)
	);

	initial begin
		// Initialize Inputs
		clkin = 0;
		en = 0;
		clrn = 0;

		// Wait 100 ns for global reset to finish
		#100 clrn=1;
		#2000 en=1;
		#1000 en=0;
		#1000 en=1;
		//#10000 en=1;
		
		
		
		
        
		// Add stimulus here

	end
	always 
		#50 clkin=~clkin;
      
endmodule

