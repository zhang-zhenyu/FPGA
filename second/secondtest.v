`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:08:50 03/29/2017
// Design Name:   second
// Module Name:   C:/Users/zhenyu/Documents/ise/system/encoder8_3/second/secondtest.v
// Project Name:  second
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: second
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module secondtest;

	// Inputs
	reg clk;
	reg startstopn;
	reg clrn;

	// Outputs
	wire [6:0] data_out;
	wire [3:0] scan_en;
	wire cn;
	wire [3:0] dsec;
	wire [3:0] sec;
	wire [3:0] secd;
	wire [3:0] secm;
	wire startstopout;

	// Instantiate the Unit Under Test (UUT)
	second uut (
		.clk(clk), 
		.startstopn(startstopn), 
		.clrn(clrn), 
		.data_out(data_out), 
		.scan_en(scan_en), 
		.cn(cn)
	);

	initial 
    begin
clk = 1'b0; //һ��Ҫ�д˾䣡����clkû�в���
#10;
forever
#10 clk = ~ clk;// Tclk = 20ns
end
initial //��2����Դ�����е������źŽ��г�ʼ��
begin
clrn = 1;
startstopn=1;
# 200000 clrn = 0; //��0.2ms��clrn��1->0
# 2000000 clrn = 1; //ά�ָ�����2ms��Ȼ���Ϊ1
# 3000000 startstopn=0; //�ӳ�3ms��startstopn��1->0����������
# 2500000 startstopn=1; //ά�ָ�����2.5ms��Ȼ���Ϊ1
# 2000000 startstopn=0; //�ӳ�2ms��startstopn��1->0��ģ�ⶶ��
# 2000000 startstopn=1; //ά�ָ�����2ms��Ȼ���Ϊ1
# 130000000 startstopn=0; //�ӳ�130ms��startstopn��1->0����ͣ����
# 2500000 startstopn=1; //ά�ָ�����2.5ms��Ȼ���Ϊ1
# 2000000 startstopn=0; //�ӳ�2ms��startstopn��1->0��ģ�ⶶ��
# 2000000 startstopn=1; //ά�ָ�����2ms��Ȼ���Ϊ1
# 140000000 startstopn=0; //�ӳ�140ms��startstopn��1->0����������
# 2500000 startstopn=1; //ά�ָ�����2.5ms��Ȼ���Ϊ1
end


assign clk_10kHz = uut.clk_10kHz;
assign clk_1kHz = uut.clk_1kHz;
assign enable = uut.enable;
assign dsec=uut.dsec;
assign sec=uut.sec;
assign secd=uut.secd;
assign secm=uut.secm;
assign startstopout=uut.startstopn_out;
//  ����
assign scan_data = uut.scan_data;

endmodule

