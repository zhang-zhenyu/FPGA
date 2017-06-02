`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:52:41 05/16/2017 
// Design Name: 
// Module Name:    syncgen 
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
module syncgen(reset,clk,v_sync,h_sync,line,pixel);
input reset;
input clk;
output reg v_sync;
output reg h_sync;
output reg[8:0]line;
output reg [9:0]pixel;

parameter 
v_cycle_length=525, //场周期长度为 场周期长度为 525行
v_blank_width=2, //v_sync负脉冲宽度为 负脉冲宽度为 负脉冲宽度为 2行
h_begin =35, //开始刷新第 一行的时间（开始刷新第 一行的时间（开始刷新第 一行的时间（开始刷新第 一行的时间（开始刷新第 一行的时间（开始刷新第 一行的时间（35行）
h_end =515, //480个行周期的结束时间（第 个行周期的结束时间（第 个行周期的结束时间（第 个行周期的结束时间（第 个行周期的结束时间（第 个行周期的结束时间（第 515行）
h_cycle_length=800, //行周期长度为 行周期长度为 800列
h_blank_width=96, //h_sync负脉冲宽度为 负脉冲宽度为 负脉冲宽度为 96列
p_begin=144, //开始刷新每行的第 一个像素时间（开始刷新每行的第 一个像素时间（开始刷新每行的第 一个像素时间（开始刷新每行的第 一个像素时间（开始刷新每行的第 一个像素时间（开始刷新每行的第 一个像素时间（开始刷新每行的第 一个像素时间（开始刷新每行的第 一个像素时间（144列）
p_end=784; //刷新完每行的最后一个像素结束时间（第 刷新完每行的最后一个像素结束时间（第 刷新完每行的最后一个像素结束时间（第 刷新完每行的最后一个像素结束时间（第 刷新完每行的最后一个像素结束时间（第 刷新完每行的最后一个像素结束时间（第 刷新完每行的最后一个像素结束时间（第 刷新完每行的最后一个像素结束时间（第 刷新完每行的最后一个像素结束时间（第 784列）

//定义 2个 reg型变量作为加法计数器 型变量作为加法计数器 ：
reg[9:0] h_count; //以 clk为时钟，对行周期 为时钟，对行周期 为时钟，对行周期 为时钟，对行周期 Trow定时计数 定时计数 定时计数
reg[9:0] v_count; //以 h_sync为时钟，对场周期 为时钟，对场周期 为时钟，对场周期 Tscreen定时计数

// ① h_count计数和产生 h_sync
always @ (posedge clk,negedge reset)
	begin//当 h_count计到最大值时，则清零；否加 计到最大值时，则清零；否加 计到最大值时，则清零；否加 计到最大值时，则清零；否加 计到最大值时，则清零；否加 计到最大值时，则清零；否加 计到最大值时，则清零；否加 1计数
		if(!reset)
			begin
				h_count<=0;
			end
		else if(h_count==h_cycle_length-1)
			begin
				h_count<=0;
			end
		else  
			begin
				h_count<=h_count+1;
			end
	end
	
always @(negedge clk,negedge reset)
	begin//当 h_count=0~95时， h_sync=0，否则为高电平 ，否则为高电平 ，否则为高电平 ，否则为高电平
		if(!reset)
			begin
				h_sync<=1;
			end
		else if(h_count<=95&&h_count>=0)
			begin
				h_sync<=0;
			end
		else 
			begin
				h_sync<=1;
			end
	end

// ② v_count计数和产生 v_sync
always @(negedge h_sync,negedge reset)
	begin//v_count计到最大值 524时清零；否则加 1计数
		if(!reset)
			begin
				v_count<=0;
			end
		else if(v_count==524)
			begin
				v_count<=0;
			end
		else
			begin
				v_count<=v_count+1;
			end
	end
	
always @(posedge h_sync,negedge  reset)
	begin//当 v_count=0~1时， v_sync=0，否则为高电平
		if(!reset)
			begin
				v_sync<=1;
			end
		else if(v_count<2)
			begin
				v_sync<=0;
			end
		else
			begin
				v_sync<=1;
			end
	end

// ③ line[8..0]对像素所处行计数 对像素所处行计数
always @ (negedge h_sync,negedge reset) //h_sync的下降沿触发 的下降沿触发 的下降沿触发 line计数。
	begin//当 h_begin-1 ≦v_count<h_end-1时， line加 1计数；
		if(!reset)
			begin
				line<=0;
			end
		else if(v_count<(h_end-1)&&v_count>=(h_begin-1))
			begin
				line<=line+1;
			end
		else
			begin
				line<=0;
			end
	end//否则 line清零。

// ④ pixel[9..0]对像素所处列计数 对像素所处列计数
always @ (posedge clk, negedge  reset)
	begin//当 1≦line≦480，且 p_begin-1≦h_count<p_end-1时， pixel加 1计数；
		if(!reset)
			begin
				pixel<=0;
			end
		else if(line<=480&&line>=1&&(p_begin-1)<=h_count&&h_count<(p_end-1))
			begin
				pixel<=pixel+1;
			end
		else
			begin
				pixel<=0;
			end
	end//否则 pixel清零。



endmodule
