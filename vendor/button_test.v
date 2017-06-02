`timescale 1ms / 1us

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:47:36 03/29/2017
// Design Name:   button
// Module Name:   C:/Users/zhenyu/Documents/ise/system/encoder8_3/second/buttontest.v
// Project Name:  second
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: button
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module buttontest;

	// Inputs
	reg clk_1kHz;
	reg pbn;

	// Outputs
	wire [6:0] cnt; //�ӷ������������ڶ�ʱ
	//wire enableb; //����ά�ּ���

	// Instantiate the Unit Under Test (UUT)
	button uut (
		.clk_1kHz(clk_1kHz), 
		.pbn(pbn), 
		.signal(signal)
	);

	initial 
begin
clk_1kHz = 0;
pbn = 1;
#6 pbn=1'b0;//ģ��������������
#4 pbn=1'b0;
#3 pbn=1'b1;
#2 pbn=1'b0;
#2 pbn=1'b1;
#130 pbn=1'b0; //�ٴ�ģ��������������
#5 pbn=1'b1;
#4 pbn=1'b0;
#3 pbn=1'b1;
#200 $stop; //200ms��ֹͣ����
end
//���м������ֵ
assign cnt = uut.cnt;
//assign enableb = uut.enableb;
//��������ʱ�Ӽ���
always #0.5 clk_1kHz=~clk_1kHz;

      
endmodule

