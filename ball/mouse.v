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

input clk_12MHz;		//ϵͳʱ�ӣ�750kHz
input reset;	//ϵͳ��λ�źţ�����Ч
inout ps2_clk;	//���ʱ���ߣ�˫���źţ���ʵ��ٶ�Ϊ20kHz
inout ps2_data;	//��������ߣ�˫���ź�
output upr;	
output downr;
output reg valid; //Ϊ���ڷ��棬����Ϊ���
output reg[10:0] senddata; //��λ�Ĵ������ݴ�����Ҫ���͵�ʹ�����Ϊ���ڷ��棬����Ϊ���

//�м������
reg [2:0] divider_cnt; //����ʱ�ӷ�Ƶ�ļ�����
reg clk; //��ϵͳʱ�ӣ�clk_12MHz������16 ��Ƶ��õ���750kHz ʱ�ӣ���Ϊ��׼����������ʱ�ӽ��в������ˡ�clk ӦΪ���������
reg[1:0] reseted; //�Ѹ�λ��־����reset �źŴ�"1"��Ϊ"0"ʱreseted=1��
reg[6:0] pulldown_cnt;//����ʱ���ߺ������ߵļ�ʱ
reg enable; /* ֻ���� 100 < pulldown_cnt < 120 ʱenable Ϊ1����enable �������ؽ�ʹ�������ݴ���senddata[10:0]�У�senddata[0] == 0 ʱ���������ߡ�*/
reg[3:0] cmd_cnt; //�Է���ʹ�������λ����������ʼλ"0"������8 ������λ��1 ��У��λ��1 ��ֹͣλ"1"��
reg[5:0] filter; //�˼��������ڹ������ʱ��
reg clk_filtered; //�ѹ��˵����ʱ��
reg r_flag; //Ϊ"1"ʱ��ʾ��ʼ��ȡ����֡
reg[3:0] in_cnt; //���ѽ���������ݵ�λ��������8 λ���ݼ�һ��У��λ��9 λΪ1 ֡��
reg[1:0] p_cnt; //����귢�͵����ݰ����ֽڼ���
reg[8:0] shiftin; //��λ�Ĵ������ݴ���귢�͵�����
reg [7:0]code; //����������


parameter CMD_F4=12'b10_11110100_0;//ps/2 �豸ʹ�����11 λ��ֹͣλ1+У��λ0+ F4 +��ʼλ0��

//��1����ϵͳʱ��12MHz ��Ƶ��õ�750kHz ʱ���ź�clk
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
	
//��2��ϵͳ��λ��ŷ��ͼ���������
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
	
//��3�������ʱ���ߺ������߽��п��ƣ���������������ź�
assign ps2_clk =(pulldown_cnt < 7'd100) ? (1'b0) : (1'bz);
assign ps2_data = (senddata[0] == 1'b0) ? (1'b0) : (1'bz);
assign upr = (code[7:0]==8'H09) ? (1'b1):(1'b0); //��������������
assign downr = (code[7:0]==8'H0A) ? (1'b1):(1'b0); //����Ҽ���������

//��4����750kHz ʱ��Ϊ��׼����������ʱ�ӽ��в������ˣ������ܸ���
always @(negedge clk)
	begin//����clk_filtered
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
	
//��5������reset ʱϵͳ��λ��Ȼ��pulldown_cnt ���м������ڲ�ͬ��ʱ��pulldown_cnt��enable �����ͬ��ֵ
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
	
//��6����������ʹ���������������������
always @(negedge clk_filtered or negedge reset or posedge enable)
	begin
		if (!reset) //�� ��λ��������������
			begin//cmd_cnt��r_flag��in_cnt��p_cnt ����
				senddata<=11'h7ff;
				cmd_cnt<=0;
				r_flag<=0;
				in_cnt<=0;
				p_cnt<=0;
				code<=0;
			end
		else if (enable) //�� ��enable ������������������
			begin// cmd_cnt ���㣬ʹ�������ݴ���senddata ��
				senddata<=CMD_F4;
				cmd_cnt<=0;
			end
		else if (pulldown_cnt >= 7'd120)//�� �ͷ�ʱ���ߺ��������Է���ʹ�����Ȼ������������
			begin
				if(cmd_cnt<4'd11)//��������ʹ������
					begin
						senddata<={1'b1,senddata[10:1]};
						cmd_cnt<=cmd_cnt+1;
					end
				else //�����������Ĵ�������
					begin
						if(ps2_data==1'b0&&r_flag==0)
							begin
								r_flag<=1;
							end
						else if(r_flag===1)//�Ѿ���ʼ��ȡ����
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
