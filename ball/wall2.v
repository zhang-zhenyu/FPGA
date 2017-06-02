`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:34:16 05/13/2017 
// Design Name: 
// Module Name:    walls 
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
module wall2(clk,line,pixel,BitRaster,BitRasterIW);
	
	//���������������
	input clk;   		   //ϵͳʱ�ӣ� 25MHz��������ģ�鹤��
	input [8:0] line;	   //��ǰˢ�����ص�������
	input [9:0] pixel;   //��ǰˢ�����صĺ�����
	output reg BitRaster;    //��ǰ������Χǽʱ�����Ϊ 1
	output reg BitRasterIW;  //��������Χǽ��Χ�ĳ���֮��ʱ�����Ϊ 1
  	always @(posedge clk)
	  begin
	    if((pixel>=1&&pixel<=15)||(line>=1&&line<=15)||(line>=465&&line<=480)||(pixel>=625&&pixel<=640))
			begin
			  BitRaster<=1;
			  BitRasterIW<=0;
			end
		 else 
			begin
			  BitRaster<=0;
			  BitRasterIW<=1;
			end
		 
	  end 
	  
endmodule
