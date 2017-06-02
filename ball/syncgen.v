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
v_cycle_length=525, //�����ڳ���Ϊ �����ڳ���Ϊ 525��
v_blank_width=2, //v_sync��������Ϊ ��������Ϊ ��������Ϊ 2��
h_begin =35, //��ʼˢ�µ� һ�е�ʱ�䣨��ʼˢ�µ� һ�е�ʱ�䣨��ʼˢ�µ� һ�е�ʱ�䣨��ʼˢ�µ� һ�е�ʱ�䣨��ʼˢ�µ� һ�е�ʱ�䣨��ʼˢ�µ� һ�е�ʱ�䣨35�У�
h_end =515, //480�������ڵĽ���ʱ�䣨�� �������ڵĽ���ʱ�䣨�� �������ڵĽ���ʱ�䣨�� �������ڵĽ���ʱ�䣨�� �������ڵĽ���ʱ�䣨�� �������ڵĽ���ʱ�䣨�� 515�У�
h_cycle_length=800, //�����ڳ���Ϊ �����ڳ���Ϊ 800��
h_blank_width=96, //h_sync��������Ϊ ��������Ϊ ��������Ϊ 96��
p_begin=144, //��ʼˢ��ÿ�еĵ� һ������ʱ�䣨��ʼˢ��ÿ�еĵ� һ������ʱ�䣨��ʼˢ��ÿ�еĵ� һ������ʱ�䣨��ʼˢ��ÿ�еĵ� һ������ʱ�䣨��ʼˢ��ÿ�еĵ� һ������ʱ�䣨��ʼˢ��ÿ�еĵ� һ������ʱ�䣨��ʼˢ��ÿ�еĵ� һ������ʱ�䣨��ʼˢ��ÿ�еĵ� һ������ʱ�䣨144�У�
p_end=784; //ˢ����ÿ�е����һ�����ؽ���ʱ�䣨�� ˢ����ÿ�е����һ�����ؽ���ʱ�䣨�� ˢ����ÿ�е����һ�����ؽ���ʱ�䣨�� ˢ����ÿ�е����һ�����ؽ���ʱ�䣨�� ˢ����ÿ�е����һ�����ؽ���ʱ�䣨�� ˢ����ÿ�е����һ�����ؽ���ʱ�䣨�� ˢ����ÿ�е����һ�����ؽ���ʱ�䣨�� ˢ����ÿ�е����һ�����ؽ���ʱ�䣨�� ˢ����ÿ�е����һ�����ؽ���ʱ�䣨�� 784�У�

//���� 2�� reg�ͱ�����Ϊ�ӷ������� �ͱ�����Ϊ�ӷ������� ��
reg[9:0] h_count; //�� clkΪʱ�ӣ��������� Ϊʱ�ӣ��������� Ϊʱ�ӣ��������� Ϊʱ�ӣ��������� Trow��ʱ���� ��ʱ���� ��ʱ����
reg[9:0] v_count; //�� h_syncΪʱ�ӣ��Գ����� Ϊʱ�ӣ��Գ����� Ϊʱ�ӣ��Գ����� Tscreen��ʱ����

// �� h_count�����Ͳ��� h_sync
always @ (posedge clk,negedge reset)
	begin//�� h_count�Ƶ����ֵʱ�������㣻��� �Ƶ����ֵʱ�������㣻��� �Ƶ����ֵʱ�������㣻��� �Ƶ����ֵʱ�������㣻��� �Ƶ����ֵʱ�������㣻��� �Ƶ����ֵʱ�������㣻��� �Ƶ����ֵʱ�������㣻��� 1����
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
	begin//�� h_count=0~95ʱ�� h_sync=0������Ϊ�ߵ�ƽ ������Ϊ�ߵ�ƽ ������Ϊ�ߵ�ƽ ������Ϊ�ߵ�ƽ
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

// �� v_count�����Ͳ��� v_sync
always @(negedge h_sync,negedge reset)
	begin//v_count�Ƶ����ֵ 524ʱ���㣻����� 1����
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
	begin//�� v_count=0~1ʱ�� v_sync=0������Ϊ�ߵ�ƽ
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

// �� line[8..0]�����������м��� �����������м���
always @ (negedge h_sync,negedge reset) //h_sync���½��ش��� ���½��ش��� ���½��ش��� line������
	begin//�� h_begin-1 �Qv_count<h_end-1ʱ�� line�� 1������
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
	end//���� line���㡣

// �� pixel[9..0]�����������м��� �����������м���
always @ (posedge clk, negedge  reset)
	begin//�� 1�Qline�Q480���� p_begin-1�Qh_count<p_end-1ʱ�� pixel�� 1������
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
	end//���� pixel���㡣



endmodule
