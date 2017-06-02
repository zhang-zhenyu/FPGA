`timescale 1ms / 1us

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:52:29 04/12/2017
// Design Name:   scan
// Module Name:   C:/Users/zhenyu/Documents/ise/system/account/scantest.v
// Project Name:  account
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
	reg [11:0] datain;

	// Outputs
	wire [3:0] scan_data;
	wire [2:0] scan_en;

	// Instantiate the Unit Under Test (UUT)
	scan uut (
		.clk(clk), 
		.clrn(clrn), 
		.datain(datain), 
		.scan_data(scan_data), 
		.scan_en(scan_en)
	);

initial
begin
clk = 0;
clrn = 1;
datain = 0;
#5 clrn = 0; //给clrn一个负脉冲
#5 clrn = 1;
datain = 12'h123; //给输入赋值
#10 datain = 12'h456;
//……
#20 $stop; //20ms后暂停仿真
end
always #0.5 clk=~clk;
      
endmodule

