`timescale 1ms / 1us

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:50:29 04/12/2017
// Design Name:   account_for_sim
// Module Name:   C:/Users/zhenyu/Documents/ise/system/account/account_for_simTest.v
// Project Name:  account
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: account_for_sim
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module account_for_simTest;

	// Inputs
	reg clk_1kHz;
	reg clk_4Hz;
	reg card;
	reg on;
	reg[1:0] category;
	reg set_money_high;
	reg set_money_mid;
	reg set_money_low;
	reg clrn;

	// Outputs
	wire read_out;
	wire write_out;
	wire warn_out;
	wire cut_out;
	wire speaker_out;
	wire [2:0] scan_en_1;
	wire [6:0] disptime_7seg;
	wire [2:0] scan_en_0;
	wire [6:0] dispmoney_7seg;
	
	
	wire [7:0] disptime;
	//wire [9:0] realmoney;
wire [11:0] dispmoney;
wire[3:0] scan_data_1;
wire[3:0] scan_data_0;

	// Instantiate the Unit Under Test (UUT)
	account_for_sim i1 (
		.clk_1kHz(clk_1kHz), 
		.clk_4Hz(clk_4Hz), 
		.card(card), 
		.on(on), 
		.category(category), 
		.set_money_high(set_money_high), 
		.set_money_mid(set_money_mid), 
		.set_money_low(set_money_low), 
		.clrn(clrn), 
		.read_out(read_out), 
		.write_out(write_out), 
		.warn_out(warn_out), 
		.cut_out(cut_out), 
		.speaker_out(speaker_out), 
		.scan_en_1(scan_en_1), 
		.disptime_7seg(disptime_7seg), 
		.scan_en_0(scan_en_0), 
		.dispmoney_7seg(dispmoney_7seg)
	);
	
	
	//����clk_1kHz
initial 


begin 
clk_1kHz<=0;
forever #0.5 clk_1kHz=~clk_1kHz;
 end
//����clk_4Hz
initial 
begin
clk_4Hz<=0;
forever #124 clk_4Hz=~clk_4Hz;
end
//ÿ�������źŸ���ԭ���ģ��ĸ�������ڲ�ͬʱ����ڸ���Ӧ��ֵ
//�˲���ͬaccountTest.V

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
//i1.realmoney <= 12'h000;
i1.my_account.realmoney<=0;

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
//���� 
#3000 i1.my_account.realmoney<=0;
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
assign disptime = i1.disptime;
assign dispmoney = i1.dispmoney;
assign scan_data_1 = i1.scan_data_1; //�����������1�������λ�������ʾͨ��ʱ��ĸ�λ�͵�λ
assign scan_data_0 = i1.scan_data_0; //�����������0

initial begin
		// Initialize Inputs
		clk_1kHz = 0;
		clk_4Hz = 0;
		card = 0;
		on = 0;
		category = 0;

		clrn = 0;



	end
	
      
endmodule

