`timescale 1us / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:22:32 04/19/2017
// Design Name:   shift_add_multiplier_sim
// Module Name:   C:/Users/zhenyu/Documents/ise/system/shift_add_multiplier/sim_test.v
// Project Name:  shift_add_multiplier
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: shift_add_multiplier_sim
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module sim_test;

	// Inputs
	reg clk_10kHz;
	reg clk_1kHz;
	reg clrn;
	reg start;
	reg [7:0] a;
	reg [7:0] b;
	reg load_a;
	reg load_b;

	// Outputs
	wire [15:0] p;
	wire done;
	wire [19:0] p_BCD;
	wire [3:0] scan_data_1;
	wire scan_en_1;
	wire [3:0] scan_data_0;
	wire [3:0] scan_en_0;
	wire [6:0] data_1_7seg;
	wire [6:0] data_0_7seg;

	// Instantiate the Unit Under Test (UUT)
	shift_add_multiplier_sim uut (
		.clk_10kHz(clk_10kHz), 
		.clk_1kHz(clk_1kHz), 
		.clrn(clrn), 
		.start(start), 
		.a(a), 
		.b(b), 
		.load_a(load_a), 
		.load_b(load_b), 
		.p(p), 
		.done(done), 
		.p_BCD(p_BCD), 
		.scan_data_1(scan_data_1), 
		.scan_en_1(scan_en_1), 
		.scan_data_0(scan_data_0), 
		.scan_en_0(scan_en_0), 
		.data_1_7seg(data_1_7seg), 
		.data_0_7seg(data_0_7seg)
	);

initial
begin

//clk_1kHz = 0;
start = 0;
a = 0;
b = 0;
load_a = 0;
load_b = 0;
clrn = 0;
#10 clrn = 1;
#50 a=8'd62;
#50 load_a=1; //����a
#100 load_a=0; //��������Ϊ100us
#50 b=8'd3;
#50 load_b=1; //����b
#100 load_b=0; //��������Ϊ100us
a=8'd0;
#50 b=8'd0;
#50 start=1; //��ʼ����
#100 start=0;
#10000 clrn=0; //10ms�󣬸�λ��һ��Ҫ�����ms�����ٸ�λ����Ϊ�����ɨ����ʾ����clk_1kHzʱ���ź�Ϊ��׼�ģ�
#50 clrn=1;
#50 a=8'd125; //aΪ��һ����
//�� //�ظ����Ϲ���
#100000 $stop; //100ms��ֹͣ����
end

initial 
begin
clk_10kHz = 0;
forever #50 clk_10kHz<=~clk_10kHz;
end
     
initial 
begin
clk_1kHz = 0;
forever #500 clk_1kHz<=~clk_1kHz;
end	  
endmodule

