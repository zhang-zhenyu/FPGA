`timescale 1ns / 1ps

module clkdivtest;

	// Inputs
	reg clkin;
	reg clrn;

	// Outputs
	wire clk_1kHz;
	wire clk_4Hz;
	
	wire[14:0] count1;
	wire[7:0] count2;

	// Instantiate the Unit Under Test (UUT)
	clkdiv uut (
		.clkin(clkin), 
		.clrn(clrn), 
		.clk_1kHz(clk_1kHz), 
		.clk_4Hz(clk_4Hz)
	);

initial
begin
clkin = 0;
clrn = 0;
#10 clrn=1'b1; //10ns后clrn设置成1
#1000000000 $stop; //1000ms后停止仿真
end
//为便于仿真，将源程序模块中的中间变量赋给新定义的wire型变量
assign count1 = uut.count1;
assign count2 = uut.count2;
always #10 clkin=~clkin;
      
endmodule

