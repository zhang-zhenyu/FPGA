`timescale 1ns / 1ps


module fsm_exercise_test;

	// Inputs
	reg clk;
	reg in;
	reg reset;

	// Outputs
	wire out;
	wire [2:0] state;

	// Instantiate the Unit Under Test (UUT)
	fsm_exercise uut (
		.clk(clk), 
		.in(in), 
		.reset(reset), 
		.out(out), 
		.state(state)
	);

	initial 
	begin
		// Initialize Inputs
		clk = 0;
		in = 0;
		reset = 0;
		
		#2000 reset=1;
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
endmodule

