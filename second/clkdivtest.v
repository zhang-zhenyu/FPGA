`timescale 1ns / 1ps


module clkdivtest;

	// Inputs
	reg clkin;
	reg clrn;

	// Outputs
	wire clk_10kHz;
	wire clk_1kHz;
	wire[12:0]  count1;
	wire[3:0] count2;

	// Instantiate the Unit Under Test (UUT)
	clkdiv uut (
		.clkin(clkin), 
		.clrn(clrn), 
		.clk_10kHz(clk_10kHz), 
		.clk_1kHz(clk_1kHz)
	);

	initial begin
		// Initialize Inputs
		clkin = 0;
		clrn = 0;
		#10 clrn=1'b1;
		#10000000 $stop;
		
	end
	
	
	assign count1=uut.count1;
	assign count2=uut.count2;
      
	always 
	#10 clkin=~clkin;
endmodule

