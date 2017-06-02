`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:20:36 03/31/2017
// Design Name:   moore10010
// Module Name:   C:/Users/zhenyu/Documents/ise/system/fsm_test/moore10010/mooretest.v
// Project Name:  moore10010
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: moore10010
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mooretest;

	// Inputs
	reg enable;
	reg clk;
	reg in;
	reg reset;

	// Outputs
	wire out;
	wire [2:0]state;

	// Instantiate the Unit Under Test (UUT)
	moore10010 uut (
		.enable(enable), 
		.clk(clk), 
		.in(in), 
		.reset(reset), 
		.out(out)
	);

	initial begin
		// Initialize Inputs
		enable = 0;
		clk = 0;
		in = 0;
		reset = 0;

		// Wait 100 ns for global reset to finish
		#1500 enable=1;
		#2000 reset=0;
		#1100 in=1;
		#1000 in=0;
		#1000 in=0;
		#1000 in=1;
		#1000 in=0;
		#1000 in=0;
		
		#1000 in=1;
		#1000 in=0;
		#1000 in=0;
		#1000 in=1;
		#1000 in=0;
		#1000 in=0;
		
	end
	
	always
		#500 clk=~clk;  


	always @( posedge clk)
		begin
			if($time>15000 )
				#50 in={$random}%2;
		end
        
		// Add stimulus here

	assign state=uut.CS;
      
endmodule

