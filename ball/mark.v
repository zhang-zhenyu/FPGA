`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:57:16 05/17/2017 
// Design Name: 
// Module Name:    mark 
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
module mark(Lftcollision,Rgtcollision,reset,Lftscore,Rgtscore,Lftwin,Rgtwin);
input Lftcollision;
input Rgtcollision;
input reset;
output reg [3:0]Lftscore;
output reg [3:0]Rgtscore;
output reg  Lftwin;
output reg Rgtwin;

always @(posedge Rgtcollision,negedge reset)
	begin
		if(!reset)
			begin
				Lftwin<=0;
				Lftscore<=0;
			end
		else 
			begin
				if(Lftscore==5)
					begin
						Lftscore<=Lftscore;
					end
				else if(Lftscore==4)
					begin
						Lftwin<=1;
						Lftscore<=Lftscore+1;
					end
				else
					begin
						Lftscore<=Lftscore+1;
					end
			end
	end
	
always @(posedge Lftcollision,negedge reset)
	begin
		if(!reset)
			begin
				Rgtwin<=0;
				Rgtscore<=0;
			end
		else 
			begin
				if(Rgtscore==5)
					begin
						Rgtscore<=Rgtscore;
					end
				else if(Rgtscore==4)
					begin
						Rgtwin<=1;
						Rgtscore<=Rgtscore+1;
					end
				else
					begin
						Rgtscore<=Rgtscore+1;
					end
			end
	end


endmodule
