`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:01:25 05/17/2017 
// Design Name: 
// Module Name:    sound 
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
module sound(reset,clk_6MHz,clk_10Hz,LftCollision,RgtCollision,speaker);

input reset;
input clk_6MHz;
input clk_10Hz;
input LftCollision;
input RgtCollision;
output reg speaker;

wire ring_pulse; //ΪLftCollision��RgtCollision�Ļ�
reg [4:0] level_cnt=0; //�������ź�ת��Ϊ��ƽ�źŵ�ʱ�����
reg ring_level=0; //��LftCollision��RgtCollision�����ź�ת��Ϊ��ƽ�ź�
reg[3:0] counter=0; //ʱ�������������ڿ���ÿ��������ʱ��
reg[3:0] high,mid,low; //�ֱ�������ʾ�����������͵�������
reg[14:0] origen,divider; //������ƵԤ������������Ƶ������
//wire carry; //divider������־

// �� �������ź�ת��Ϊ һ�����Ƚ������ź�ת��Ϊ һ������1��ĵ�ƽ�ź�
assign ring_pulse=LftCollision||RgtCollision; //ֻ�� 40ns���� ���� Ball.v��
always @(posedge clk_10Hz or posedge ring_pulse)
	begin
		if(ring_pulse&&level_cnt==0) 
			begin
				ring_level<=1;
			end
		else if(ring_level==1)
			begin
				if(level_cnt==9)//level_cnt�� 1������ ������ �ƹ� 10���� ������ ������
					begin
						ring_level<=0;
						level_cnt<=0;
					end
				else
					begin
						level_cnt<=level_cnt+1;
					end
			end
	end

// �� ���ף�����ʱ����������ֵ �����������к͵�
always @(posedge clk_10Hz)
	begin
		if (!ring_level) 
			counter<=4'd0;
		else
			begin
				if(counter==9)//ֻ���� ring_levelΪ"1"ʱ counter�� 1���� ,�����Ƶ� 9
					counter<=0;
				else
					begin
						counter<=counter+1;
					end
			end
		case(counter) //����
			4'd1:	{high,mid,low}=12'h007; //���� 3
			4'd2: {high,mid,low}=12'h010; //���� 3
			4'd3: {high,mid,low}=12'h020; //���� 3
			4'd4: {high,mid,low}=12'h030; //���� 3
			4'd5: {high,mid,low}=12'h040; //���� 3
			4'd6: {high,mid,low}=12'h050; //���� 3
			4'd7: {high,mid,low}=12'h060; //���� 3
			4'd8: {high,mid,low}=12'h070; //���� 3
			4'd9: {high,mid,low}=12'h000; //���� 3
			
		endcase
	end

// �� ���ݸ������к͵͵�ֵ ������Ƶ������Ԥ�ø��ݾ�����Ƶ������Ԥ��
always @(posedge clk_10Hz, negedge reset)
	begin
		if (!reset) 
			origen=9102;
		else 
			begin
				case({high,mid,low})
					12'h001: origen=22936; //���� 3
					12'h002: origen=20429; //���� 3
					12'h003: origen=18204; //���� 3
					12'h004: origen=17182; //���� 3
					12'h005: origen=15036; //���� 3
					12'h006: origen=13636; //���� 3
					12'h007: origen=12148; //���� 3
					12'h010: origen=11466; //���� 3
					12'h020: origen=10216; //���� 3
					12'h030: origen=9102; //���� 3
					12'h040: origen=8590; //���� 3
					12'h050: origen=7652; //���� 3
					12'h060: origen=6818; //���� 3
					12'h070: origen=6074; //���� 3
					12'h100: origen=5734; //���� 3
					12'h200: origen=5108; //���� 3
					12'h300: origen=4550; //���� 3
					12'h400: origen=4296; //���� 3
					12'h500: origen=3828; //���� 3
					12'h600: origen=3410; //���� 3
					12'h700: origen=3038; //���� 3
					default:
						begin
							origen=110;//��ֹ��
						end
				endcase
			end
	end
	
// �� ��������Ƶ������������λ
always @(posedge clk_6MHz or negedge reset) //��a��������Ƶ���� 
	begin
		if (!reset)
			begin//��Ƶ�����������ֵ
				divider<=0;
				speaker<=0;
			end
		else if(!ring_level)
			begin
				speaker<=0;
				divider<=0; //û����ײ�ź�ʱ�����з�Ƶ
			end
		else//ֻ���� ring_levelΪ"1"divider�� 1����
			begin
			if(origen==110)
					begin
						speaker<=0;
					end
				else
				if(divider==origen/2-1)
					begin
						speaker<=~speaker;
						divider<=0;
					end
				else 
					begin
						divider<=divider+1;
					end
			end
	end
			
endmodule
