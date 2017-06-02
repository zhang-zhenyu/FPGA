`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   09:26:04 05/16/2017
// Design Name:   keyboard
// Module Name:   C:/Users/zhenyu/Documents/ise/system/ball/keyboard_test.v
// Project Name:  ball
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: keyboard
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module keyboard_test;

	// Inputs
	reg clk_50MHz;
	reg reset;
	reg kb_clk;
	reg kb_data;

	// Outputs
	wire upl;
	wire downl;
	
	integer i=0;
	//integer count=0;
	reg[10:0] shift;

	// Instantiate the Unit Under Test (UUT)
	keyboard uut (
		.clk_50MHz(clk_50MHz), 
		.reset(reset), 
		.kb_clk(kb_clk), 
		.kb_data(kb_data), 
		.upl(upl), 
		.downl(downl)
	);

	initial 
	begin
		// Initialize Inputs
		
		reset = 0;
		kb_clk = 1;
		kb_data = 1;
		shift=11'b1_1111_1111_11;

		// Wait 100 ns for global reset to finish
		#100;
		reset=1;
		#200
		reset=0;
		
		#500
		reset=1;
		
		#100000 kb_clk=0;
		shift=11'b1_0001_1100_0;
		while(i<22)
			begin
				#25000 kb_clk=~kb_clk;
				i=i+1;
			end
		kb_clk=1;
		
		#100000 i=0;
		shift=11'b11_1111_0000_0;
		//count=1;
		while(i<22)
			begin
				#25000 kb_clk=~kb_clk;
				i=i+1;
			end
		kb_clk=1;
			
		#10000 i=0;
		shift=11'b1_0001_1100_0;
		//count=2;
		while(i<22)
			begin
				#25000 kb_clk=~kb_clk;
				i=i+1;
			end
        
		// Add stimulus here
	#1000000
		$stop;

	end
	
	initial 
		begin
			clk_50MHz = 0;
			forever
			#10	clk_50MHz=~clk_50MHz;
		end
		
	always @(negedge kb_clk)
		begin
			shift<={1,shift[10:1]};
			kb_data<=shift[0];
		end
	
	
	
      
endmodule

