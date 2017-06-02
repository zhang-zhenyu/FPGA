`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:08:11 05/17/2017 
// Design Name: 
// Module Name:    paddle 
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
module paddle(clk,reset,VSync,GoUp,GoDown,line,pixel,BitRaster,PaddlePosY);
input clk;
input reset;
input VSync;
input GoUp;
input GoDown;
input [8:0]line;
input [9:0]pixel;
output reg BitRaster;
output reg[8:0] PaddlePosY;

reg HorPaddle; //挡板横界， 挡板横界， 为"1"表示 当前屏幕上像素 当前屏幕上像素 当前屏幕上像素 在挡板 的水平范围之内 的水平范围之内 的水平范围之内 的水平范围之内
reg VertPaddle; //挡板纵界， 挡板纵界， 为"1"表示 当前屏幕上像素 当前屏幕上像素 当前屏幕上像素 在挡板 的垂直范围之内 的垂直范围之内 的垂直范围之内 的垂直范围之内
reg [2:0] SSMovePaddle;//状态机

parameter 
	WaitVS=3'd 1,//状态 机状态 机状态机
	IncPosY=3'd 2,
	DecPosY=3'd 3,
	Load=3'd 4;

// ① 状态机的转移与输出 状态机的转移与输出 状态机的转移与输出
always @(posedge clk or negedge  reset )
	begin
		if(!reset)	
			begin 
				SSMovePaddle=WaitVS;
				PaddlePosY=16; 
			end//挡板初始在最上边 挡板初始在最上边 挡板初始在最上边 挡板初始在最上边
		else	
			begin
				case (SSMovePaddle)
					WaitVS:
						begin //（a）等待场同步信号到来 等待场同步信号到来 等待场同步信号到来 等待场同步信号到来 等待场同步信号到来
							if (VSync==0) 
								SSMovePaddle=IncPosY; //刷新每一帧时 刷新每一帧时 刷新每一帧时
							else 
								SSMovePaddle=WaitVS;
							end
					IncPosY: //（b）判断是否增加 判断是否增加 判断是否增加 判断是否增加 PaddlePosY的值
						begin
							if(GoDown ) //是向下 ?
								begin
									if (PaddlePosY<=380)//若没到最底部则纵坐标加 若没到最底部则纵坐标加 若没到最底部则纵坐标加 若没到最底部则纵坐标加 若没到最底部则纵坐标加 若没到最底部则纵坐标加 4
										begin
											PaddlePosY=PaddlePosY+4;
										end
									else
										begin
											PaddlePosY=384; //若到底了则保持原坐标 若到底了则保持原坐标 若到底了则保持原坐标 若到底了则保持原坐标
										end
								end
							SSMovePaddle = DecPosY; //跳转到下一状态 跳转到下一状态 跳转到下一状态
						end
					DecPosY: //（c）判断是否减少 判断是否减少 判断是否减少 判断是否减少 PaddlePosY的值
						begin
							if(GoUp)//是向上 ?
								begin
									if (PaddlePosY>=20)//若没到最底部则纵坐标加 若没到最底部则纵坐标加 若没到最底部则纵坐标加 若没到最底部则纵坐标加 若没到最底部则纵坐标加 若没到最底部则纵坐标加 4
										begin
											PaddlePosY=PaddlePosY-4;
										end
									else
										begin
											PaddlePosY=16; //若到底了则保持原坐标 若到底了则保持原坐标 若到底了则保持原坐标 若到底了则保持原坐标
										end
								end
							SSMovePaddle=Load;
						end
					Load: //（d）重置 ）重置
						begin
							if(VSync)
								SSMovePaddle=WaitVS;
							else
								SSMovePaddle=Load;
						end
					default: 
						SSMovePaddle=WaitVS;
				endcase
			end
	end
	
// ② 判断当前屏幕上哪些像素应该属于挡板内部 判断当前屏幕上哪些像素应该属于挡板内部 判断当前屏幕上哪些像素应该属于挡板内部
always @(posedge clk) //板宽 10，长 80
	begin
		if (pixel >= 40 && pixel < 50) 
			HorPaddle=1;//只有这条语句与 paddle2.v不同
		else 
			HorPaddle=0;
		if (line >= PaddlePosY && line <(PaddlePosY+80)) 
			VertPaddle=1;
		else 
			VertPaddle=0;
		BitRaster = VertPaddle&&HorPaddle; //只有 HorPaddle和 VertPaddle均为 1时 BitRaster才为 1
	end
	
endmodule
