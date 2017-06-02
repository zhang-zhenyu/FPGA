`timescale 1ms / 1us

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:24:20 04/12/2017
// Design Name:   account
// Module Name:   D:/account/accounttest.v
// Project Name:  account
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: account
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module accounttest;

	// Inputs
	reg clk_1kHz;
	reg clk_4Hz;
	reg card;
	reg on;
	reg [1:0] category;
	reg set_money_high;
	reg set_money_mid;
	reg set_money_low;
	reg clrn;
	
	

	// Outputs
	wire [7:0] disptime;
	wire [11:0] dispmoney;
	wire read;
	wire write;
	wire warn;
	wire cut;
	wire speaker;
	
	
	reg[11:0] money1;
	reg min_clk1;
	integer cnt1_1;
	integer cnt_warning1;

	// Instantiate the Unit Under Test (UUT)
	account uut (
		.clk_1kHz(clk_1kHz), 
		.clk_4Hz(clk_4Hz), 
		.card(card), 
		.on(on), 
		.category(category), 
		.set_money_high(set_money_high), 
		.set_money_mid(set_money_mid), 
		.set_money_low(set_money_low), 
		.clrn(clrn), 
		.disptime(disptime), 
		.dispmoney(dispmoney), 
		.read(read), 
		.write(write), 
		.warn(warn), 
		.cut(cut), 
		.speaker(speaker)
	);

	initial
begin
clk_1kHz <= 0;
forever #0.5 clk_1kHz <= ~clk_1kHz;
end


//����clk_4Hz
initial 
begin 
clk_4Hz<=0;
forever #125 clk_4Hz<=~clk_4Hz; 
end

//ÿ�������źŸ���ԭ���ģ��ĸ�������ڲ�ͬʱ����ڸ���Ӧ��ֵ
initial
begin
//��1�����źŸ���ʼֵ
card <= 1'b0;
category <= 2'b00;
on <= 1'b0;
clrn <= 1'b1;
set_money_high <= 1'b1;
set_money_mid <= 1'b1;
set_money_low <= 1'b1;
uut.realmoney <= 12'h000;
//��2�����ÿ��ڵĽ���ֵ
#1500 set_money_high <= 1'b0;//�ӳ�1.5s������money��λ��ֵ
#2000 set_money_high <= 1'b1;//��2s�ڣ���8��clk_4Hz���ڣ���������
#3500 set_money_mid <= 1'b0; //�ӳ�3.5s������moneyʮλ��ֵ
#1750 set_money_mid <= 1'b1; //��1.75s�ڣ���7��clk_4Hz���ڣ���������
#5500 set_money_low <= 1'b0; //�ӳ�5.5s������money��λ��ֵ
#2000 set_money_low <= 1'b1; //��2s�ڣ���8��clk_4Hz���ڣ���������
//��3�����л�
#1000 card <= 1'b1; //�ӳ�1s��忨
#1000 on <= 1'b1; //���뿨������������·�Ž�ͨ
category <= 2'b01; //���л�
#40000 card <= 1'b0; //�ӳ�40s��ο�
category <= 2'b00;
#200 on <= 1'b0; //��·��
#500 clrn <= 1'b0; //500ms��������
#3000 clrn <= 1'b1; //clrn����3s������


//��4���򳤻����ȸ����ڽ���ֵ1Ԫ��
#3000 uut.realmoney<=0;
#1000 set_money_mid <= 1'b0;
#250 set_money_mid <= 1'b1;

#1000 card <= 1'b1; //�ӳ�1s��忨
#1000 on <= 1'b1; //���뿨������������·�Ž�ͨ
category <= 2'b10; //�򳤻�
#40000 card <= 1'b0; //�ӳ�40s��ο�
category <= 2'b00;
#200 on <= 1'b0; //��·��
#500 clrn <= 1'b0; //500ms��������
#3000 clrn <= 1'b1; //clrn����3s������
//��ʱcard��category��onҪ���¸�ֵ

//��5�����ػ�
//����
#30000 $stop; //30s��ֹͣ����
end

//��Ҫ������м������ֵ
always @(posedge clk_1kHz)
begin
money1 <= uut.money;
min_clk1 <= uut.min_clk;
cnt1_1 <= uut.cnt1;
cnt_warning1 <= uut.cnt_warning;
end
      
endmodule

