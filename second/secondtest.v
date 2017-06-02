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
clk = 1'b0; //一定要有此句！否则clk没有波形
#10;
forever
#10 clk = ~ clk;// Tclk = 20ns
end
initial //（2）对源程序中的输入信号进行初始化
begin
clrn = 1;
startstopn=1;
# 200000 clrn = 0; //在0.2ms处clrn从1->0
# 2000000 clrn = 1; //维持负脉冲2ms，然后变为1
# 3000000 startstopn=0; //延迟3ms，startstopn从1->0，启动计数
# 2500000 startstopn=1; //维持负脉冲2.5ms，然后变为1
# 2000000 startstopn=0; //延迟2ms，startstopn从1->0，模拟抖动
# 2000000 startstopn=1; //维持负脉冲2ms，然后变为1
# 130000000 startstopn=0; //延迟130ms，startstopn从1->0，暂停计数
# 2500000 startstopn=1; //维持负脉冲2.5ms，然后变为1
# 2000000 startstopn=0; //延迟2ms，startstopn从1->0，模拟抖动
# 2000000 startstopn=1; //维持负脉冲2ms，然后变为1
# 140000000 startstopn=0; //延迟140ms，startstopn从1->0，继续计数
# 2500000 startstopn=1; //维持负脉冲2.5ms，然后变为1
end


assign clk_10kHz = uut.clk_10kHz;
assign clk_1kHz = uut.clk_1kHz;
assign enable = uut.enable;
assign dsec=uut.dsec;
assign sec=uut.sec;
assign secd=uut.secd;
assign secm=uut.secm;
assign startstopout=uut.startstopn_out;
//  ……
assign scan_data = uut.scan_data;

endmodule

