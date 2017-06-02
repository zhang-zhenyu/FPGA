`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   17:40:20 05/24/2017
// Design Name:   sound
// Module Name:   E:/ball/sound_test.v
// Project Name:  ball
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: sound
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sound_test;

	// Inputs
	reg reset;
	reg clk_6MHz;
	reg clk_10Hz;
	reg LftCollision;
	reg RgtCollision;

	// Outputs
	wire speaker;
	
	integer i;

	// Instantiate the Unit Under Test (UUT)
	sound uut (
		.reset(reset), 
		.clk_6MHz(clk_6MHz), 
		.clk_10Hz(clk_10Hz), 
		.LftCollision(LftCollision), 
		.RgtCollision(RgtCollision), 
		.speaker(speaker)
	);

	initial begin
		// Initialize Inputs
		reset = 1;
		clk_6MHz = 0;
		clk_10Hz = 0;
		LftCollision = 0;
		RgtCollision = 0;
		i=0;

		// Wait 100 ns for global reset to finish
		#100 reset=0;
      #100 reset=1;  
		// Add stimulus here
		
		while(i<10)
		begin
			#(500000000*2) LftCollision=1;
			#(500000024*2) LftCollision=0;
		end
		
		#10000000 $stop;

	end
	
			initial 
	begin
	clk_6MHz = 0;
	forever
	begin
		#80 clk_6MHz<=~clk_6MHz;
	end
	end
	
	
				initial 
	begin
	clk_10Hz = 0;
	forever
	begin
		#50000000 clk_10Hz<=~clk_10Hz;
	end
	end
	
      
endmodule

