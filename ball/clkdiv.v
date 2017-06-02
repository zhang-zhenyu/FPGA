`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:36:34 05/17/2017 
// Design Name: 
// Module Name:    clkdiv 
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
module clkdiv(reset,clk_25MHz,clk_12MHz,clk_6MHz,clk_10Hz,clk_1kHz);
input reset;
input clk_25MHz;
input clk_12MHz;
output reg clk_6MHz;
output reg clk_10Hz;

output reg clk_1kHz;
reg[12:0] count1;
reg[9:0] count2;
reg [3:0]count3;

reg  clk_10kHz;


parameter count_width=2500;

	

always @(posedge clk_12MHz, negedge reset) //clk_6MHz
	begin
		if(!reset)
			begin
				clk_6MHz<=0;
			end
		else 
			begin
				clk_6MHz<=~clk_6MHz;
			end
	end


always @(posedge clk_25MHz, negedge reset) //5000·ÖÆµ
	begin
		if(!reset)
			begin
				count1<=0;
				clk_10kHz<=0;
			end
		else 
			begin
				if(count1==count_width/2-1)
				begin
					clk_10kHz<=~clk_10kHz;
					count1<=0;
				end
				else
				begin
					count1<=count1+1;
					//clk_10kHz<=~clk_10kHz;
				end
			end
	end

always @(posedge clk_10kHz, negedge reset)
	begin
		if(!reset)
			begin
				count2<=0;
				clk_10Hz<=0;
			end
		else if(count2==499)
		begin
			clk_10Hz<=~clk_10Hz;
			count2<=0;
		end
		else
			begin
			count2<=count2+1; 
			//clk_1kHz=~clk_1kHz;
			end
	end

always @(posedge clk_10kHz, negedge reset)
	begin
		if(!reset)
			begin
				count3<=0;
				clk_1kHz<=0;
			end
		else if(count3==4)
		begin
			clk_1kHz<=~clk_1kHz;
			count3<=0;
		end
		else
			begin
			count3<=count3+1; 
			//clk_1kHz=~clk_1kHz;
			end
	end


endmodule
