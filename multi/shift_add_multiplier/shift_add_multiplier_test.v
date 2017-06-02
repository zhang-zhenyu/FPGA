`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:18:14 04/19/2017
// Design Name:   shift_add_multiplier
// Module Name:   C:/Users/zhenyu/Documents/ise/system/shift_add_multiplier/shift_add_multiplier_test.v
// Project Name:  shift_add_multiplier
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: shift_add_multiplier
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module shift_add_multiplier_test;

	// Inputs
	reg clk;
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
	shift_add_multiplier uut (
		.clk(clk), 
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
clk_10kHz = 0;
clk_1kHz = 0;
start = 0;
a = 0;
b = 0;
load_a = 0;
load_b = 0;
clrn = 0;
#10 clrn = 1;
#50 a=8'd62;
#50 load_a=1; //加载a
#100 load_a=0; //正脉冲宽度为100us
#50 b=8'd3;
#50 load_b=1; //加载b
#100 load_b=0; //正脉冲宽度为100us
a=8'd0;
#50 b=8'd0;
#50 start=1; //开始运算
#100 start=0;
#10000 clrn=0; //10ms后，复位（一定要间隔几ms以上再复位，因为数码管扫描显示是以clk_1kHz时钟信号为基准的）
#50 clrn=1;
#50 a=8'd125; //a为另一个数
//… //重复以上过程
#100000 $stop; //100ms后停止仿真
end
        
		// Add stimulus here

endmodule

