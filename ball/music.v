`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:22:42 05/17/2017 
// Design Name: 
// Module Name:    music 
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
module music(reset,clk_6MHz,clk_10Hz,LftWin,RgtWin,speaker);
input reset;
input clk_6MHz;
input clk_10Hz;
input LftWin;
input RgtWin;
output reg speaker;

wire ring_pulse; //ΪLftCollision��RgtCollision�Ļ�
//reg [3:0] level_cnt; //�������ź�ת��Ϊ��ƽ�źŵ�ʱ�����
//reg ring_level; //��LftCollision��RgtCollision�����ź�ת��Ϊ��ƽ�ź�
reg[5:0] counter; //ʱ�������������ڿ���ÿ��������ʱ��
reg[3:0] high,mid,low; //�ֱ�������ʾ�����������͵�������
reg[13:0] origen,divider; //������ƵԤ������������Ƶ������
//wire carry; //divider������־

// �� �������ź�ת��Ϊ һ�����Ƚ������ź�ת��Ϊ һ������1��ĵ�ƽ�ź�
assign ring_pulse=LftWin||RgtWin; //ֻ�� 40ns���� ���� Ball.v��


// �� ���ף�����ʱ����������ֵ �����������к͵�
always @(posedge clk_10Hz)
	begin
		if (!ring_pulse) 
			counter<=0;
		else
			begin
				if(counter==30)//ֻ���� ring_levelΪ"1"ʱ counter�� 1���� ,�����Ƶ� 9
					counter<=30;
				else
					begin
						counter<=counter+1;
					end
			end
		case(counter) //����
			6'd1: {high,mid,low}=12'h010; //���� 3
			6'd2: {high,mid,low}=12'h020; //���� 3
			6'd3: {high,mid,low}=12'h030; //���� 3
			6'd4: {high,mid,low}=12'h040; //���� 3
			6'd5: {high,mid,low}=12'h050; //���� 3
			6'd6: {high,mid,low}=12'h060; //���� 3
			6'd7: {high,mid,low}=12'h070; //���� 3
			6'd8: {high,mid,low}=12'h010; //���� 3
			6'd9: {high,mid,low}=12'h020; //���� 3
			6'd10: {high,mid,low}=12'h030; //���� 3
			6'd11: {high,mid,low}=12'h040; //���� 3
			6'd12: {high,mid,low}=12'h050; //���� 3
			6'd13: {high,mid,low}=12'h060; //���� 3
			6'd14: {high,mid,low}=12'h070; //���� 3
			6'd15: {high,mid,low}=12'h010; //���� 3
			6'd16: {high,mid,low}=12'h020; //���� 3
			6'd17: {high,mid,low}=12'h030; //���� 3
			6'd18: {high,mid,low}=12'h040; //���� 3
			6'd19: {high,mid,low}=12'h050; //���� 3
			6'd20: {high,mid,low}=12'h060; //���� 3
			6'd21: {high,mid,low}=12'h070; //���� 3
			6'd22: {high,mid,low}=12'h010; //���� 3
			6'd23: {high,mid,low}=12'h020; //���� 3
			6'd24: {high,mid,low}=12'h030; //���� 3
			6'd25: {high,mid,low}=12'h040; //���� 3
			6'd26: {high,mid,low}=12'h050; //���� 3
			6'd27: {high,mid,low}=12'h060; //���� 3
			6'd28: {high,mid,low}=12'h070; //���� 3
			6'd29: {high,mid,low}=12'h010; //���� 3
			6'd30: {high,mid,low}=12'h000; //���� 3
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
		else if(!ring_pulse)
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
				else if(divider==origen/2-1)
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
