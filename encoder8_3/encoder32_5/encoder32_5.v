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


module encoder16_4(EI,I,Z, GS, EO);

input EI;
input [15:0] I;
output [3:0] Z;
output GS;
output EO;

wire[2:0] A_Hi;
wire GS_Hi;
wire EO_Hi;
wire EI_Lo;
wire[2:0] A_Lo;
wire GS_Lo;
wire EO_Lo;

PriEncoder8_3 my_encoder1(EI, I[15:8],A_Hi, GS_Hi,EO_Hi);
PriEncoder8_3 my_encoder2(EI_Lo, I[7:0],A_Lo, GS_Lo,EO);
assign EI_Lo=EO_Hi;
assign Z[3]=GS_Hi;
//assign Z[2:0]=A_Hi&A_Lo;
assign Z[2]=A_Hi[2]&A_Lo[2];
assign Z[1]=A_Hi[1]&A_Lo[1];
assign Z[0]=A_Hi[0]&A_Lo[0];
assign GS=GS_Hi&GS_Lo;


endmodule


module encoder32_5(EI, I, Z,GS, EO);

input EI;
input [31:0] I;
output [4:0] Z;
output GS;
output EO;

wire[3:0] A_Hi;
wire GS_Hi;
wire EO_Hi;
wire EI_Lo;
wire[3:0] A_Lo;
wire GS_Lo;
wire EO_Lo;

encoder16_4 my_encoder3(EI, I[31:16],A_Hi, GS_Hi,EO_Hi);
encoder16_4 my_encoder4(EI_Lo, I[15:0],A_Lo, GS_Lo,EO);
assign EI_Lo=EO_Hi;
assign Z[4]=GS_Hi;
//assign Z[2:0]=A_Hi&A_Lo;
assign Z[3]=A_Hi[3]&A_Lo[3];
assign Z[2]=A_Hi[2]&A_Lo[2];
assign Z[1]=A_Hi[1]&A_Lo[1];
assign Z[0]=A_Hi[0]&A_Lo[0];
assign GS=GS_Hi&GS_Lo;



endmodule
