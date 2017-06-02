`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:04:38 04/18/2017
// Design Name:   muit
// Module Name:   C:/Users/zhenyu/Documents/ise/system/muit/muit_test.v
// Project Name:  muit
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: muit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module muit_test;

	// Inputs
	reg [7:0] a;
	reg [7:0] b;

	// Outputs
	wire [15:0] outcome;

	// Instantiate the Unit Under Test (UUT)
	muit uut (
		.a(a), 
		.b(b), 
		.outcome(outcome)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		b = 0;

		// Wait 100 ns for global reset to finish
		#100 
		a<=1;
		b<=1;
		#100 
		a<=2;
		b<=2;
		#100 
		a<=3;
		b<=3;
		#100 
		a<=4;
		b<=4;
		#100 
		a<=5;
		b<=5;
		#100 
		a<=6;
		b<=6;
		#100 
		a<=7;
		b<=7;
		#100 
		a<=8;
		b<=8;
		#100 
		a<=9;
		b<=9;
		#100 
		a<=10;
		b<=10;
		#100 
		a<=11;
		b<=11;
		#100 
		a<=12;
		b<=12;
		#100 
		a<=8;
		b<=8;
		
        
		// Add stimulus here

	end
      
endmodule

