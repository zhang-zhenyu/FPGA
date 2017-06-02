`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:40:20 05/16/2017 
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
module walls(clk,line,pixel,BitRaster,BitRasterIW);
input clk;
input [8:0]line;
input [9:0]pixel;
output reg BitRaster;
output reg BitRasterIW;

always @(posedge clk)
	begin
		if((line>=1-1&&line<=15)||(line<=480&&line>=465)||(pixel>=1-1&&pixel<=15-1)||(pixel<=639&&pixel>=625-1))
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

module wall2(clk,line,pixel,BitRaster,BitRasterIW);
	
	//输入输出变量定义
	input clk;   		   //系统时钟（ 25MHz），驱动模块工作
	input [8:0] line;	   //当前刷新像素的纵坐标
	input [9:0] pixel;   //当前刷新像素的横坐标
	output reg BitRaster;    //当前像素是围墙时，输出为 1
	output reg BitRasterIW;  //当像素在围墙包围的场地之内时，输出为 1
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
