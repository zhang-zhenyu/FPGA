`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:47:44 05/14/2017 
// Design Name: 
// Module Name:    mourse 
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
module mouse(clk_12MHz,reset,ps2_clk,ps2_data,upr,downr,valid,senddata);

input clk_12MHz;		//系统时钟，750kHz
input reset;	//系统复位信号，低有效
inout ps2_clk;	//鼠标时钟线，双向信号，本实验假定为20kHz
inout ps2_data;	//鼠标数据线，双向信号
output upr;	
output downr;
output reg valid; //为便于仿真，声明为输出
output reg[10:0] senddata; //移位寄存器，暂存主机要发送的使能命令，为便于仿真，声明为输出

//中间变量：
reg [2:0] divider_cnt; //用于时钟分频的计数器
reg clk; //将系统时钟（clk_12MHz）进行16 分频后得到的750kHz 时钟，作为基准对鼠标产生的时钟进行采样过滤。clk 应为方波输出。
reg[1:0] reseted; //已复位标志，当reset 信号从"1"变为"0"时reseted=1。
reg[6:0] pulldown_cnt;//下拉时钟线和数据线的计时
reg enable; /* 只有在 100 < pulldown_cnt < 120 时enable 为1，在enable 的上升沿将使能命令暂存于senddata[10:0]中，senddata[0] == 0 时拉低数据线。*/
reg[3:0] cmd_cnt; //对发送使能命令的位数计数（起始位"0"，还有8 个数据位、1 个校验位及1 个停止位"1"）
reg[5:0] filter; //此计数器用于过滤鼠标时钟
reg clk_filtered; //已过滤的鼠标时钟
reg r_flag; //为"1"时表示开始读取数据帧
reg[3:0] in_cnt; //对已接收鼠标数据的位数计数（8 位数据加一个校验位共9 位为1 帧）
reg[1:0] p_cnt; //对鼠标发送的数据包的字节计数
reg[8:0] shiftin; //移位寄存器，暂存鼠标发送的数据
reg [7:0]code; //鼠标输出数据


parameter CMD_F4=12'b10_11110100_0;//ps/2 设备使能命令，11 位（停止位1+校验位0+ F4 +起始位0）

//（1）将系统时钟12MHz 分频后得到750kHz 时钟信号clk
always @(posedge clk_12MHz,negedge reset)
	begin
		if(!reset)
			begin
				divider_cnt<=0;
				clk<=0;
			end
		else if(divider_cnt==7)
			begin
				clk<=~clk;
				divider_cnt<=0;
			end
		else
			begin
				divider_cnt<=divider_cnt+1;
			end
	end
	
//（2）系统复位后才发送及接收数据
always @(negedge reset)
	begin
		if(reseted<2'd3)
			begin
				reseted<=reseted+1;
			end
		else 
			begin
				reseted<=2'b1;
			end
	end
	
//（3）对鼠标时钟线和数据线进行控制，并产生挡板控制信号
assign ps2_clk =(pulldown_cnt < 7'd100) ? (1'b0) : (1'bz);
assign ps2_data = (senddata[0] == 1'b0) ? (1'b0) : (1'bz);
assign upr = (code[7:0]==8'H09) ? (1'b1):(1'b0); //鼠标左键控制上移
assign downr = (code[7:0]==8'H0A) ? (1'b1):(1'b0); //鼠标右键控制下移

//（4）以750kHz 时钟为基准对鼠标产生的时钟进行采样过滤，以免受干扰
always @(negedge clk)
	begin//产生clk_filtered
		filter<={ps2_clk,filter[5:1]};
		if(filter==6'b111111)
			begin
				clk_filtered<=1'b1;
			end
		else if(filter==6'b000000)
			begin
				clk_filtered<=1'b0;
			end
	end
	
//（5）按下reset 时系统复位，然后pulldown_cnt 进行计数，在不同的时刻pulldown_cnt和enable 输出不同的值
always @(posedge clk or negedge reset)
	begin
		if(!reset)
			begin
				pulldown_cnt<=7'd0;
				enable<=1'b0;
			end
		else if(reseted>0)
			begin
				if(pulldown_cnt<100)
					begin
						pulldown_cnt<=pulldown_cnt+1;
					end
				else if(pulldown_cnt<120)
					begin
						pulldown_cnt<=pulldown_cnt+7'b1;
						enable<=1;
					end
				else
					begin
						enable<=0;
					end
			end
	end
	
//（6）主机发送使能命令及接收来自鼠标的数据
always @(negedge clk_filtered or negedge reset or posedge enable)
	begin
		if (!reset) //① 复位，各计数器清零
			begin//cmd_cnt、r_flag、in_cnt、p_cnt 清零
				senddata<=11'h7ff;
				cmd_cnt<=0;
				r_flag<=0;
				in_cnt<=0;
				p_cnt<=0;
				code<=0;
			end
		else if (enable) //② 在enable 的上升沿拉低数据线
			begin// cmd_cnt 清零，使能命令暂存于senddata 中
				senddata<=CMD_F4;
				cmd_cnt<=0;
			end
		else if (pulldown_cnt >= 7'd120)//③ 释放时钟线后主机可以发送使能命令，然后接收鼠标数据
			begin
				if(cmd_cnt<4'd11)//主机发送使能命令
					begin
						senddata<={1'b1,senddata[10:1]};
						cmd_cnt<=cmd_cnt+1;
					end
				else //主机接收鼠标的串行数据
					begin
						if(ps2_data==1'b0&&r_flag==0)
							begin
								r_flag<=1;
							end
						else if(r_flag===1)//已经开始读取数据
							begin
								if(in_cnt<9)
									begin
										in_cnt<=in_cnt+1;
										shiftin[8:0]<={ps2_data,shiftin[8:1]};
									end
								else
									begin
										in_cnt<=4'd0;
										r_flag<=0;
										
										if(p_cnt==0||p_cnt==1)
											begin
												code<=shiftin[7:0];
											end
											
										if(p_cnt==1)
											begin
												valid<=1;
											end
										else 
											begin
												valid<=0;
											end
											
										if(p_cnt<3)
											begin
												p_cnt<=p_cnt+1;
											end
										else 
											begin
												p_cnt<=1;
											end
									end
							end
					end
			end
	end
	
endmodule
