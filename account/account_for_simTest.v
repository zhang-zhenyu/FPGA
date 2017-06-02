`timescale 1ms / 1us

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:50:29 04/12/2017
// Design Name:   account_for_sim
// Module Name:   C:/Users/zhenyu/Documents/ise/system/account/account_for_simTest.v
// Project Name:  account
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: account_for_sim
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module account_for_simTest;

	// Inputs
	reg clk_1kHz;
	reg clk_4Hz;
	reg card;
	reg on;
	reg[1:0] category;
	reg set_money_high;
	reg set_money_mid;
	reg set_money_low;
	reg clrn;

	// Outputs
	wire read_out;
	wire write_out;
	wire warn_out;
	wire cut_out;
	wire speaker_out;
	wire [2:0] scan_en_1;
	wire [6:0] disptime_7seg;
	wire [2:0] scan_en_0;
	wire [6:0] dispmoney_7seg;
	
	
	wire [7:0] disptime;
	//wire [9:0] realmoney;
wire [11:0] dispmoney;
wire[3:0] scan_data_1;
wire[3:0] scan_data_0;

	// Instantiate the Unit Under Test (UUT)
	account_for_sim i1 (
		.clk_1kHz(clk_1kHz), 
		.clk_4Hz(clk_4Hz), 
		.card(card), 
		.on(on), 
		.category(category), 
		.set_money_high(set_money_high), 
		.set_money_mid(set_money_mid), 
		.set_money_low(set_money_low), 
		.clrn(clrn), 
		.read_out(read_out), 
		.write_out(write_out), 
		.warn_out(warn_out), 
		.cut_out(cut_out), 
		.speaker_out(speaker_out), 
		.scan_en_1(scan_en_1), 
		.disptime_7seg(disptime_7seg), 
		.scan_en_0(scan_en_0), 
		.dispmoney_7seg(dispmoney_7seg)
	);
	
	
	//产生clk_1kHz
initial 


begin 
clk_1kHz<=0;
forever #0.5 clk_1kHz=~clk_1kHz;
 end
//产生clk_4Hz
initial 
begin
clk_4Hz<=0;
forever #124 clk_4Hz=~clk_4Hz;
end
//每个输入信号根据原设计模块的各种情况在不同时间段内赋相应的值
//此部分同accountTest.V

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
//i1.realmoney <= 12'h000;
i1.my_account.realmoney<=0;

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
//…… 
#3000 i1.my_account.realmoney<=0;
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
assign disptime = i1.disptime;
assign dispmoney = i1.dispmoney;
assign scan_data_1 = i1.scan_data_1; //驱动数码管组1，最低两位数码管显示通话时间的高位和低位
assign scan_data_0 = i1.scan_data_0; //驱动数码管组0

initial begin
		// Initialize Inputs
		clk_1kHz = 0;
		clk_4Hz = 0;
		card = 0;
		on = 0;
		category = 0;

		clrn = 0;



	end
	
      
endmodule

