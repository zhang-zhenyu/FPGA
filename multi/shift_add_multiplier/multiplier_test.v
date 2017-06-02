`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   00:58:26 04/19/2017
// Design Name:   multiplier
// Module Name:   C:/Users/zhenyu/Documents/ise/system/shift_add_multiplier/multiplier_test.v
// Project Name:  shift_add_multiplier
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: multiplier
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module multiplier_test;

	// Inputs
	reg clk_10kHz;
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
	wire [1:0] state;
	wire [15:0] a_lshift_r;
	wire [7:0] b_rshift_r;
	wire [15:0] sum;
	wire z;

	// Instantiate the Unit Under Test (UUT)
	multiplier uut (
		.clk_10kHz(clk_10kHz), 
		.clrn(clrn), 
		.start(start), 
		.a(a), 
		.b(b), 
		.load_a(load_a), 
		.load_b(load_b), 
		.p(p), 
		.done(done), 
		.p_BCD(p_BCD), 
		.state(state), 
		.a_lshift_r(a_lshift_r), 
		.b_rshift_r(b_rshift_r), 
		.sum(sum), 
		.z(z)
	);

	initial begin
		// Initialize Inputs
		
		clrn = 0;
		start = 0;
		a = 0;
		b = 0;
		load_a = 0;
		load_b = 0;

		// Wait 100 ns for global reset to finish
		#10 clrn = 1;
		//#50 start=1; //开始运算
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
#400 clrn=0; //400us后，复位
#50 clrn=1;
#50 a=8'd125; //a为另一个数
//重复以上过程
#10000 $stop; //10ms后停止仿真
        
		// Add stimulus here

	end
	
	initial
	begin
	clk_10kHz = 0;
	forever #50 clk_10kHz=~clk_10kHz;
	end
      
endmodule

