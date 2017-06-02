`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   21:30:12 05/18/2017
// Design Name:   mark
// Module Name:   C:/Users/zhenyu/Documents/ise/system/ball/mark_test.v
// Project Name:  ball
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mark
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mark_test;

	// Inputs
	reg Lftcollision;
	reg Rgtcollision;
	reg reset;

	// Outputs
	wire [3:0] Lftscore;
	wire [3:0] Rgtscore;
	wire Lftwin;
	wire Rgtwin;
	integer i;

	// Instantiate the Unit Under Test (UUT)
	mark uut (
		.Lftcollision(Lftcollision), 
		.Rgtcollision(Rgtcollision), 
		.reset(reset), 
		.Lftscore(Lftscore), 
		.Rgtscore(Rgtscore), 
		.Lftwin(Lftwin), 
		.Rgtwin(Rgtwin)
	);

	initial begin
		// Initialize Inputs
		Lftcollision = 0;
		Rgtcollision = 0;
		reset = 1;

		// Wait 100 ns for global reset to finish
		#100 reset=0;
		#100 reset=1;
		
		i=0;
		while(i<30)
		begin
			#40 ;
			i=i+1;
			Lftcollision=~Lftcollision;
			
		end
		
		#1000 $stop;
        
		// Add stimulus here

	end
      
endmodule

