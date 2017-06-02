`timescale 1ms / 1us

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:24:01 03/29/2017
// Design Name:   bcdcnt
// Module Name:   C:/Users/zhenyu/Documents/ise/system/encoder8_3/second/bcdcntteset.v
// Project Name:  second
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: bcdcnt
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module bcdcntteset;

	// Inputs
	reg clkin;
	reg clrn;

	// Outputs
	wire [3:0] dsec;
	wire [3:0] sec;
	wire [3:0] secd;
	wire [3:0] secm;
	wire cn;

	// Instantiate the Unit Under Test (UUT)
	bcdcnt uut (
		.clkin(clkin), 
		.clrn(clrn), 
		.dsec(dsec), 
		.sec(sec), 
		.secd(secd), 
		.secm(secm), 
		.cn(cn)
	);

initial
begin
clkin = 0; //必须有此句！否则仿真没有波形
clrn = 1;
#10 clrn=1'b0; //10ms后给clrn一个负脉冲
#5 clrn=1'b1;
#100000 $stop; //100s后停止
end
always #5 clkin=~clkin; //赋予输入时钟激励，周期为10ms
		// Add stimulus here

      
endmodule

