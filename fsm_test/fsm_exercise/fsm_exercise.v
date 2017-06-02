`timescale 1ns / 1ps


module fsm_exercise(clk, in,reset, out,state);

input clk, in,reset;
output out;
output[2:0] state;

reg [2:0] state;
reg out;

parameter Reset=3'b000;
parameter Q1=3'b001;
parameter Q2=3'b010;
parameter Q3=3'b011;
parameter Q4=3'b100;

always @(posedge clk)
	begin
	if(reset==0)
		begin
			state<=Reset;
			out<=0;
		end
	else
		case(state)
		Reset:
			if(in)
				begin
					state<=Q1;
					out<=0;
				end
			else
				begin
					state<=Reset;
					out<=0;
				end
		Q1:
			if(!in)
				begin
					state<=Q2;
					out<=0;
				end
			else
				begin
					state<=Q1;
					out<=0;
				end
		Q2:
			if(!in)
				begin
					state<=Q3;
					out<=0;
				end
			else
				begin
					state<=Reset;
					out<=0;
				end
		Q3:
			if(in)
				begin
					state<=Q4;
					out<=0;
				end
			else
				begin
					state<=Q1;
					out<=0;
				end
		Q4:
			if(!in)
				begin
					state<=Reset;
					out<=1;
				end
			else
				begin
					state<=Reset;
					out<=0;
				end
		endcase
	end
	
endmodule
