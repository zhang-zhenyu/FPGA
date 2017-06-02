`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:41:52 05/17/2017 
// Design Name: 
// Module Name:    look 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module look(clk,BRPad1,BRPad2,BRBall,BRWall,BRIW,vga_red,vga_green,vga_blue);
input clk;
input BRPad1;
input BRPad2;
input BRBall;
input BRWall;
input BRIW;
output reg vga_red;
output reg vga_green;
output reg vga_blue;

/*always @(negedge clk)
	begin
		casex({BRPad1,BRPad2,BRBall,BRWall,BRIW})
			5'b1xxxx:
				begin
					vga_red<=1;
					vga_green<=0;
					vga_blue<=0;
				end
			5'b01xxx:
				begin
					vga_red<=1;
					vga_green<=0;
					vga_blue<=0;
				end
			5'b001xx:
				begin
					vga_red<=0;
					vga_green<=0;
					vga_blue<=1;
				end
			5'b0001x:
				begin
					vga_red<=0;
					vga_green<=1;
					vga_blue<=0;
				end
			5'b00001:
				begin
					vga_red<=1;
					vga_green<=1;
					vga_blue<=1;
				end
		endcase
	end
*/

always @(negedge clk)
	begin
		if(BRPad1||BRPad2)
			begin
				vga_red<=1;
				vga_green<=0;
				vga_blue<=0;
			end
		else if(BRBall)
			begin
				vga_red<=0;
				vga_green<=0;
				vga_blue<=1;
			end
		else if(BRWall)
			begin
				vga_red<=0;
				vga_green<=1;
				vga_blue<=0;
			end
		else
			begin
				vga_red<=0;
				vga_green<=0;
				vga_blue<=0;				
			end
	end

endmodule
