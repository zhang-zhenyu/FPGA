`timescale 1ms / 1us

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:32:23 03/29/2017
// Design Name:   scan
// Module Name:   C:/Users/zhenyu/Documents/ise/system/encoder8_3/second/scantest.v
// Project Name:  second
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: scan
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module scantest;

	// Inputs
	reg clk;
	reg clrn;
	reg [3:0] dsec;
	reg [3:0] sec;
	reg [3:0] secd;
	reg [3:0] secm;

	// Outputs
	wire [3:0] scan_data;
	wire [3:0] scan_en;

	// Instantiate the Unit Under Test (UUT)
	scan uut (
		.clk(clk), 
		.clrn(clrn), 
		.dsec(dsec), 
		.sec(sec), 
		.secd(secd), 
		.secm(secm), 
		.scan_data(scan_data), 
		.scan_en(scan_en)
	);

	initial 
	begin
clk = 0;
clrn = 1;
dsec = 0;
sec = 0;
secd = 0;
secm = 0;
#5 clrn = 0; //给clrn一个负脉冲
#5 clrn = 1;
dsec = 4'd1; //给输入赋值
sec = 4'd4;
secd = 4'd6;
secm = 4'd8;
#10 dsec = 4'd2;
sec = 4'd5;
secd = 4'd7;
secm = 4'd9;
#2000 $stop ;//2s后停止
end
always #0.5 clk=~clk; //赋予输入时钟激励，周期为1ms

      
endmodule

