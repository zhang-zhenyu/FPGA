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

reg HorPaddle; //�����磬 �����磬 Ϊ"1"��ʾ ��ǰ��Ļ������ ��ǰ��Ļ������ ��ǰ��Ļ������ �ڵ��� ��ˮƽ��Χ֮�� ��ˮƽ��Χ֮�� ��ˮƽ��Χ֮�� ��ˮƽ��Χ֮��
reg VertPaddle; //�����ݽ磬 �����ݽ磬 Ϊ"1"��ʾ ��ǰ��Ļ������ ��ǰ��Ļ������ ��ǰ��Ļ������ �ڵ��� �Ĵ�ֱ��Χ֮�� �Ĵ�ֱ��Χ֮�� �Ĵ�ֱ��Χ֮�� �Ĵ�ֱ��Χ֮��
reg [2:0] SSMovePaddle;//״̬��

parameter 
	WaitVS=3'd 1,//״̬ ��״̬ ��״̬��
	IncPosY=3'd 2,
	DecPosY=3'd 3,
	Load=3'd 4;

// �� ״̬����ת������� ״̬����ת������� ״̬����ת�������
always @(posedge clk or negedge  reset )
	begin
		if(!reset)	
			begin 
				SSMovePaddle=WaitVS;
				PaddlePosY=16; 
			end//�����ʼ�����ϱ� �����ʼ�����ϱ� �����ʼ�����ϱ� �����ʼ�����ϱ�
		else	
			begin
				case (SSMovePaddle)
					WaitVS:
						begin //��a���ȴ���ͬ���źŵ��� �ȴ���ͬ���źŵ��� �ȴ���ͬ���źŵ��� �ȴ���ͬ���źŵ��� �ȴ���ͬ���źŵ���
							if (VSync==0) 
								SSMovePaddle=IncPosY; //ˢ��ÿһ֡ʱ ˢ��ÿһ֡ʱ ˢ��ÿһ֡ʱ
							else 
								SSMovePaddle=WaitVS;
							end
					IncPosY: //��b���ж��Ƿ����� �ж��Ƿ����� �ж��Ƿ����� �ж��Ƿ����� PaddlePosY��ֵ
						begin
							if(GoDown ) //������ ?
								begin
									if (PaddlePosY<=380)//��û����ײ���������� ��û����ײ���������� ��û����ײ���������� ��û����ײ���������� ��û����ײ���������� ��û����ײ���������� 4
										begin
											PaddlePosY=PaddlePosY+4;
										end
									else
										begin
											PaddlePosY=384; //���������򱣳�ԭ���� ���������򱣳�ԭ���� ���������򱣳�ԭ���� ���������򱣳�ԭ����
										end
								end
							SSMovePaddle = DecPosY; //��ת����һ״̬ ��ת����һ״̬ ��ת����һ״̬
						end
					DecPosY: //��c���ж��Ƿ���� �ж��Ƿ���� �ж��Ƿ���� �ж��Ƿ���� PaddlePosY��ֵ
						begin
							if(GoUp)//������ ?
								begin
									if (PaddlePosY>=20)//��û����ײ���������� ��û����ײ���������� ��û����ײ���������� ��û����ײ���������� ��û����ײ���������� ��û����ײ���������� 4
										begin
											PaddlePosY=PaddlePosY-4;
										end
									else
										begin
											PaddlePosY=16; //���������򱣳�ԭ���� ���������򱣳�ԭ���� ���������򱣳�ԭ���� ���������򱣳�ԭ����
										end
								end
							SSMovePaddle=Load;
						end
					Load: //��d������ ������
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
	
// �� �жϵ�ǰ��Ļ����Щ����Ӧ�����ڵ����ڲ� �жϵ�ǰ��Ļ����Щ����Ӧ�����ڵ����ڲ� �жϵ�ǰ��Ļ����Щ����Ӧ�����ڵ����ڲ�
always @(posedge clk) //��� 10���� 80
	begin
		if (pixel >= 40 && pixel < 50) 
			HorPaddle=1;//ֻ����������� paddle2.v��ͬ
		else 
			HorPaddle=0;
		if (line >= PaddlePosY && line <(PaddlePosY+80)) 
			VertPaddle=1;
		else 
			VertPaddle=0;
		BitRaster = VertPaddle&&HorPaddle; //ֻ�� HorPaddle�� VertPaddle��Ϊ 1ʱ BitRaster��Ϊ 1
	end
	
endmodule
