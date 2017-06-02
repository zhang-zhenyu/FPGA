`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:30:52 05/17/2017 
// Design Name: 
// Module Name:    ball 
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
module ball(clk,reset,VSync,PaddlePos1,PaddlePos2,line,pixel,BitRaster,LftCollision,RgtCollision);
input clk;
input reset;
input VSync;
input [8:0]PaddlePos1;
input [8:0]PaddlePos2;
input [8:0]line;
input [9:0]pixel;
output BitRaster;
output reg LftCollision;
output reg RgtCollision;

reg [9:0] BallPosX,BallPosY,BallDX,BallDY;//小球横坐标、纵坐标、横增量、纵增量 
reg BR; //相当于 BitRaster，提高信号稳定性 ，提高信号稳定性 ，提高信号稳定性 ，提高信号稳定性
reg [3:0] SSMoveBall; //状态机
wire HorzBall,VertBall; //小球的坐标范围

parameter WaitVS=0;
parameter CheckUp=1;
parameter CheckDown=2;
parameter CheckLft=3;
parameter CheckRgt=4;
parameter CheckLftScor=5;
parameter CheckRgtScore=6;
parameter IncCo=7;
parameter Load=8;


// ① 以小球左上角为基准，确定的坐标范围 以小球左上角为基准，确定的坐标范围 以小球左上角为基准，确定的坐标范围
assign HorzBall = ((pixel >= BallPosX) && (pixel <= BallPosX +9)); //小球宽度为 小球宽度为 10
assign VertBall = ((line >= BallPosY) && (line <= BallPosY +9)); //小球高度为 小球高度为 10
assign BitRaster = BR;

// ② 状态机的转移
always @(posedge clk or negedge reset)
	begin
		if(!reset) 
			begin
				SSMoveBall=WaitVS;
			end
		else
			begin
				case (SSMoveBall)
					WaitVS:
						begin
							if (VSync==0) 
								SSMoveBall=CheckUp;
							else 
								SSMoveBall=WaitVS;
						end
					CheckUp:
						begin
							SSMoveBall=CheckDown;
						end
					CheckDown:
						begin
							SSMoveBall=CheckLft;
						
						end
					CheckLft:
						begin
							SSMoveBall=CheckRgt;
							
						end
					CheckRgt:
						begin
							SSMoveBall=CheckLftScor;
							
						end
					CheckLftScor:
						begin
							SSMoveBall=CheckRgtScore;
							
						end
					CheckRgtScore:
						begin
							SSMoveBall=IncCo;
							
						end
					IncCo:
						begin
							SSMoveBall=Load;
							
						end
					
					Load: 
						begin
							if (VSync==1) 
								SSMoveBall=WaitVS;
							else 
								SSMoveBall=Load;

						end
					default: 
						SSMoveBall=WaitVS;
				endcase
			end
	end
	
// ③ 状态机输出
always @(posedge clk or negedge reset)
	begin
		if(!reset)
			begin
				BallPosX=315; //小球初始横坐标 小球初始横坐标 小球初始横坐标
				BallDX=PaddlePos2 % 5 + 1;//小球横增量等于右挡板的坐标模 5加 1
				BallPosY=235; //小球初始纵坐标 小球初始纵坐标 小球初始纵坐标
				BallDY=PaddlePos1 % 5 + 1;//小球纵增量等于左挡板的坐标模 5加 1
				LftCollision=1'b0;
				RgtCollision=1'b0;
			end
		else
			begin
				case (SSMoveBall)
					WaitVS:
						begin
							BallDX=BallDX;
							BallDY=BallDY;
							LftCollision=1'b0;
							RgtCollision=1'b0;
						end
					CheckUp:
						begin
							if(BallPosY<=15) //碰到上墙 碰到上墙
								BallDY=PaddlePos1 % 5 + 1;
							end
					CheckDown:
						begin
							if(BallPosY>=435)
								begin
									BallDY=0-(PaddlePos1%5 + 1);
								end
						end
					CheckLft:
						begin
							if((BallPosX>=31&&BallPosX<=50)&&(BallPosY>=(PaddlePos1-10)&&BallPosY<=(PaddlePos1+80)))//碰到左挡板
								begin
									BallDX=PaddlePos2 % 5 + 1;
								end
						end
					CheckRgt:
						begin
							if((BallPosX>=591&&BallPosX<=610)&&(BallPosY>=(PaddlePos2-10)&&BallPosY<=(PaddlePos2+80)))//碰到右挡板
								begin
									BallDX=0-(PaddlePos2 % 5 + 1);
								end
						end
					CheckLftScor:
						begin
							if(BallPosX<=15)
								begin
									LftCollision=1;
								end
						end
					CheckRgtScore:
						begin
							if(BallPosX>=615)//碰到右
								begin
									RgtCollision=1;
								end
						end
					IncCo:
						begin
							BallPosX=BallPosX+BallDX; //改变小球横坐标
							BallPosY=BallPosY+BallDY; //改变小球纵坐标
						end
					Load:
						begin
							if(LftCollision || RgtCollision)//若小球与上墙或下左侧壁 
								begin
									BallPosX=315; //小球初始横坐标 小球初始横坐标 小球初始横坐标
									BallDX=PaddlePos2 % 5 + 1;//小球横增量等于右挡板的坐标模 5加 1
									BallPosY=235; //小球初始纵坐标 小球初始纵坐标 小球初始纵坐标
									BallDY=PaddlePos1 % 5 + 1;//小球纵增量等于左挡板的坐标模 5加 1
									LftCollision=1'b0;
									RgtCollision=1'b0;
								end
						end	
				endcase
			end
	end
	
// ④ 判断球的位置
always @(posedge clk)
	begin
		/*if(!reset)
		begin
		end*/
		BR=HorzBall&&VertBall;
	end
endmodule
