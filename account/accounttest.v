`timescale 1ms / 1us

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:24:20 04/12/2017
// Design Name:   account
// Module Name:   D:/account/accounttest.v
// Project Name:  account
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: account
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module accounttest;

	// Inputs
	reg clk_1kHz;
	reg clk_4Hz;
	reg card;
	reg on;
	reg [1:0] category;
	reg set_money_high;
	reg set_money_mid;
	reg set_money_low;
	reg clrn;
	
	

	// Outputs
	wire [7:0] disptime;
	wire [11:0] dispmoney;
	wire read;
	wire write;
	wire warn;
	wire cut;
	wire speaker;
	
	
	reg[11:0] money1;
	reg min_clk1;
	integer cnt1_1;
	integer cnt_warning1;

	// Instantiate the Unit Under Test (UUT)
	account uut (
		.clk_1kHz(clk_1kHz), 
		.clk_4Hz(clk_4Hz), 
		.card(card), 
		.on(on), 
		.category(category), 
		.set_money_high(set_money_high), 
		.set_money_mid(set_money_mid), 
		.set_money_low(set_money_low), 
		.clrn(clrn), 
		.disptime(disptime), 
		.dispmoney(dispmoney), 
		.read(read), 
		.write(write), 
		.warn(warn), 
		.cut(cut), 
		.speaker(speaker)
	);

	initial
begin
clk_1kHz <= 0;
forever #0.5 clk_1kHz <= ~clk_1kHz;
end


//产生clk_4Hz
initial 
begin 
clk_4Hz<=0;
forever #125 clk_4Hz<=~clk_4Hz; 
end

//每个输入信号根据原设计模块的各种情况在不同时间段内赋相应的值
initial
begin
//（1）各信号赋初始值
card <= 1'b0;
category <= 2'b00;
on <= 1'b0;
clrn <= 1'b1;
set_money_high <= 1'b1;
set_money_mid <= 1'b1;
set_money_low <= 1'b1;
uut.realmoney <= 12'h000;
//（2）设置卡内的金额初值
#1500 set_money_high <= 1'b0;//延迟1.5s后设置money百位初值
#2000 set_money_high <= 1'b1;//在2s内（即8个clk_4Hz周期）持续设置
#3500 set_money_mid <= 1'b0; //延迟3.5s后设置money十位初值
#1750 set_money_mid <= 1'b1; //在1.75s内（即7个clk_4Hz周期）持续设置
#5500 set_money_low <= 1'b0; //延迟5.5s后设置money个位初值
#2000 set_money_low <= 1'b1; //在2s内（即8个clk_4Hz周期）持续设置
//（3）打市话
#1000 card <= 1'b1; //延迟1s后插卡
#1000 on <= 1'b1; //插入卡、拨完号码后，线路才接通
category <= 2'b01; //打市话
#40000 card <= 1'b0; //延迟40s后拔卡
category <= 2'b00;
#200 on <= 1'b0; //线路断
#500 clrn <= 1'b0; //500ms后清空余额
#3000 clrn <= 1'b1; //clrn持续3s负脉冲


//（4）打长话（先给卡内金额充值1元）
#3000 uut.realmoney<=0;
#1000 set_money_mid <= 1'b0;
#250 set_money_mid <= 1'b1;

#1000 card <= 1'b1; //延迟1s后插卡
#1000 on <= 1'b1; //插入卡、拨完号码后，线路才接通
category <= 2'b10; //打长话
#40000 card <= 1'b0; //延迟40s后拔卡
category <= 2'b00;
#200 on <= 1'b0; //线路断
#500 clrn <= 1'b0; //500ms后清空余额
#3000 clrn <= 1'b1; //clrn持续3s负脉冲
//此时card、category和on要重新赋值

//（5）打特话
//……
#30000 $stop; //30s后停止仿真
end

//给要仿真的中间变量赋值
always @(posedge clk_1kHz)
begin
money1 <= uut.money;
min_clk1 <= uut.min_clk;
cnt1_1 <= uut.cnt1;
cnt_warning1 <= uut.cnt_warning;
end
      
endmodule

