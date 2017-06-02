`timescale 1ns / 1ps


module moore10010(enable,clk, in,reset,out);

input clk, in,reset,enable;
output out;
//output[2:0] state;

reg [2:0] CS;
//reg [2:0] NS;
reg out;

parameter Reset=3'b000;
parameter Q1=3'b001;
parameter Q2=3'b010;
parameter Q3=3'b011;
parameter Q4=3'b100;
parameter Get=3'b101;

always @(posedge clk)
	begin
		if(!enable)
			CS<=Reset;
		else if(reset)
			begin
				CS<=Reset;
			end
		else
			begin
				case(CS)
					Reset:
						begin
							if(in==0)
								CS<=Reset;
							else
								CS<=Q1;
						end
					Get:
						begin
							if(in==0)
								CS<=Reset;
							else
								CS<=Q1;
						end
					Q1:
						begin
							if(in==0)
								CS<=Q2;
							else
								CS<=Reset;
						end
					Q2:
						begin
							if(in==0)
								CS<=Q3;
							else
								CS<=Reset;
						end
					Q3:
						begin
							if(in==0)
								CS<=Reset;
							else
								CS<=Q4;
						end
					Q4:
						begin
							if(in==0)
								CS<=Get;
							else
								CS<=Q1;
						end
				endcase
			end
	end

always @(posedge clk)
	begin
		case(CS)
			Reset:
				out<=0;
			Get:
				out<=1;
			Q1:
				out<=0;
			Q2:
				out<=0;
			Q3:
				out<=0;
			Q4:
				out<=0;
		endcase
	end
	
endmodule
