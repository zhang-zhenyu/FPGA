`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:41:42 04/26/2017
// Design Name:   clkdiv
// Module Name:   C:/Users/zhenyu/Documents/ise/system/vendor/clkdiv_test.v
// Project Name:  vendor
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
	reg clkin;
	//reg clrn;

	// Outputs
	reg clk_1kHz;
	reg clk_1Hz;

	// Instantiate the Unit Under Test (UUT)
	clkdiv uut (
		.clkin(clkin), 
		//.clrn(clrn), 
		.clk_1kHz(clk_1kHz), 
		.clk_1Hz(clk_1Hz)
	);

	initial begin
		// Initialize Inputs
		
		//clrn = 0;
		clk_1Hz=0;
		clk_1kHz=0;

		// Wait 100 ns for global reset to finish
		#100;
		//clrn=1;
        
		// Add stimulus here

	end
	
	initial 
	begin
		clkin = 0;
		forever 
		#10 clkin<=~clkin;
	end
      
endmodule

