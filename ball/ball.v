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

reg [9:0] BallPosX,BallPosY,BallDX,BallDY;//С������ꡢ�����ꡢ�������������� 
reg BR; //�൱�� BitRaster������ź��ȶ��� ������ź��ȶ��� ������ź��ȶ��� ������ź��ȶ���
reg [3:0] SSMoveBall; //״̬��
wire HorzBall,VertBall; //С������귶Χ

parameter WaitVS=0;
parameter CheckUp=1;
parameter CheckDown=2;
parameter CheckLft=3;
parameter CheckRgt=4;
parameter CheckLftScor=5;
parameter CheckRgtScore=6;
parameter IncCo=7;
parameter Load=8;


// �� ��С�����Ͻ�Ϊ��׼��ȷ�������귶Χ ��С�����Ͻ�Ϊ��׼��ȷ�������귶Χ ��С�����Ͻ�Ϊ��׼��ȷ�������귶Χ
assign HorzBall = ((pixel >= BallPosX) && (pixel <= BallPosX +9)); //С����Ϊ С����Ϊ 10
assign VertBall = ((line >= BallPosY) && (line <= BallPosY +9)); //С��߶�Ϊ С��߶�Ϊ 10
assign BitRaster = BR;

// �� ״̬����ת��
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
	
// �� ״̬�����
always @(posedge clk or negedge reset)
	begin
		if(!reset)
			begin
				BallPosX=315; //С���ʼ������ С���ʼ������ С���ʼ������
				BallDX=PaddlePos2 % 5 + 1;//С������������ҵ��������ģ 5�� 1
				BallPosY=235; //С���ʼ������ С���ʼ������ С���ʼ������
				BallDY=PaddlePos1 % 5 + 1;//С�������������󵲰������ģ 5�� 1
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
							if(BallPosY<=15) //������ǽ ������ǽ
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
							if((BallPosX>=31&&BallPosX<=50)&&(BallPosY>=(PaddlePos1-10)&&BallPosY<=(PaddlePos1+80)))//�����󵲰�
								begin
									BallDX=PaddlePos2 % 5 + 1;
								end
						end
					CheckRgt:
						begin
							if((BallPosX>=591&&BallPosX<=610)&&(BallPosY>=(PaddlePos2-10)&&BallPosY<=(PaddlePos2+80)))//�����ҵ���
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
							if(BallPosX>=615)//������
								begin
									RgtCollision=1;
								end
						end
					IncCo:
						begin
							BallPosX=BallPosX+BallDX; //�ı�С�������
							BallPosY=BallPosY+BallDY; //�ı�С��������
						end
					Load:
						begin
							if(LftCollision || RgtCollision)//��С������ǽ�������� 
								begin
									BallPosX=315; //С���ʼ������ С���ʼ������ С���ʼ������
									BallDX=PaddlePos2 % 5 + 1;//С������������ҵ��������ģ 5�� 1
									BallPosY=235; //С���ʼ������ С���ʼ������ С���ʼ������
									BallDY=PaddlePos1 % 5 + 1;//С�������������󵲰������ģ 5�� 1
									LftCollision=1'b0;
									RgtCollision=1'b0;
								end
						end	
				endcase
			end
	end
	
// �� �ж����λ��
always @(posedge clk)
	begin
		/*if(!reset)
		begin
		end*/
		BR=HorzBall&&VertBall;
	end
endmodule
