`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:02:17 03/20/2017 
// Design Name: 
// Module Name:    Priencoder8_3 
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
module PriEncoder8_3(
    input EI,
    input [7:0] I,
    output [2:0] A,
    output GS,
    output EO
    );
	 
	reg GS,EO;
	reg[2:0] A;
	always @(*)
	begin
		if(EI==1)//不工作
		begin
			A<=3'b111;
			GS<=1;
			EO<=1;
		end
		else if(I[7:0]==8'b1111_1111)//无输入，无有效输出
		begin
			A<=3'b111;
			GS<=1;
			EO<=0;
		end
		else if(I[7]==0)//优先编码7，低电平有效
		begin
			A<=3'b000;
			GS<=0;
			EO<=1;
		end
		else if(I[6]==0)
		begin
			A<=3'b001;
			GS<=0;
			EO<=1;
		end
		else if(I[5]==0)
		begin
			A<=3'b010;
			GS<=0;
			EO<=1;
		end
		else if(I[4]==0)
		begin
			A<=3'b011;
			GS<=0;
			EO<=1;
		end
		else if(I[3]==0)
		begin
			A<=3'b100;
			GS<=0;
			EO<=1;
		end
		else if(I[2]==0)
		begin
			A<=3'b101;
			GS<=0;
			EO<=1;
		end
		else if(I[1]==0)
		begin
			A<=3'b110;
			GS<=0;
			EO<=1;
		end
		else if(I[0]==0)
		begin
			A<=3'b111;
			GS<=0;
			EO<=1;
		end



			
		
	end


endmodule
