`timescale 1ns / 1ps

//核心子模块
module account(clk_1kHz,clk_4Hz,card,on,category, set_money_high,set_money_mid,set_money_low,clrn,disptime,dispmoney,read, write,warn,cut, speaker);
	input clk_1kHz,clk_4Hz;//来自分频子模块的时钟信号，频率分别为1kHz和4Hz
	input card; //卡插入信号，当卡插入时，为高电平，卡拔出后，为低电平
	input on; //接通信号，从电话局反馈回来的信号，高电平时表示线路已接通，低电平时表示线路未接通
	input [1:0] category; //话务种类，从电话局反馈回来的信号，"01"表示市话，"10"表示长话，"11"表示特话
	input set_money_high; //低有效，设置卡中金额的百位，单位为角，每按一下加1
	input set_money_mid; //低有效，设置卡中金额的十位，单位为角，每按一下加1
	input set_money_low; //低有效，设置卡中金额的个位，单位为角，每按一下加1
	input clrn; //清零信号（低有效）
	output reg [7:0] disptime; //显示本次通话的时长，高4位和低4位分别为BCD码计数器。单位为分钟，这里假设能显示的最大时间为59分钟
	output [11:0] dispmoney;//显示卡内余额，高4位、中间4位和低4位分别为BCD码计数器。单位为角，这里假设能显示的最大数额为99.9元
	output read; //读卡信号，当电话卡插入时变高，此时读卡
	output reg write; //写卡信号，当其上升沿到来时写卡
	output reg warn; //当卡中余额不足时产生的告警信号，高有效，告警15s后变为低电平
	output reg cut; //自动切断当前通话信号。平时为低，当告警时间达到15s时cut变高
	output speaker; //告警信号驱动蜂鸣器发声
	
	integer cnt1; //对通话时间计数
	reg min_clk; //分时钟（为脉冲信号），写卡的时刻
	wire [11:0] money; //用于计费（卡内余额），以min_clk为时钟信号，高4位、中间4位和低4位分别采用BCD码计数器
	//wire [11:0] money;
	reg[9:0] realmoney;//money的内存值
	integer cnt_warning; //用于计告警时间
	reg flag; //当告警达15秒时置flag为1，以便使warn清零
	
	//有assign出现的地方不可以需要将右边声明为wire型
	assign dispmoney =card?money:0; //只要电话卡一插入，则显示卡内余额
	assign read = card?1:0; //只要电话卡一插入，则产生读卡信号（高电平）
	assign speaker=warn&clk_1kHz; //告警信号驱动蜂鸣器发声
	
	assign money[3:0]=realmoney%10;
	assign money[7:4]=(realmoney%100)/10;
	assign money[11:8]=realmoney/100;
	
	
	//1）产生通话计时和通话计费的基准时钟信号min_clk
	always @(posedge clk_4Hz)
		begin
			if(card && on) //若卡已插入且电话局接通线路
				begin
					if(cnt1==59)//则cnt1开始加1计数，若计到59s，则cnt1清零，产生min_clk
						begin
							cnt1<=0;
							min_clk<=1;
						end
					else 
						begin
							cnt1<=cnt1+1;
							min_clk<=0;
						end
				end
			else 
				begin
					cnt1<=0;
					min_clk<=0;
				end
		end
		
	//2）对通话计时
	always @(negedge clk_4Hz or negedge clrn)
		begin
			if (!clrn) 
				begin
					disptime<=8'd0;
					//cnt1<=0;
				end
			else if(card && on) //若卡已插入且电话局接通线路
				begin
					if(min_clk) //且通话时间够1分钟，则disptime开始加1计数，注意为bcd计数器
						begin
							if(disptime[3:0]==9)
								begin
									disptime[3:0]<=0;
									disptime[7:4]<=disptime[7:4]+1;
								end
							else
								begin
									disptime[3:0]<=disptime[3:0]+1;
								end
						end
					else 
						disptime<=disptime;//一定要有此句，否则在min_clk变为0后的下一个时钟周期disptime也变为0
				end
			else
				disptime<=0;
		end
		
	// 3）完成设置卡内的金额初值和通话计费
	always @(negedge clk_4Hz or negedge clrn)
		begin
			if (!clrn)//各变量清零
				begin
					realmoney<=0;
					flag<=0;
					write<=0;
					cut<=0;
					warn<=0;
				end
			//a.设置卡内的金额初值
			/*
			else if (!set_money_low) 
				begin
					if (money[3:0]==9)
						money[3:0]<=4'h0;
					else 
						money[3:0]<=money[3:0]+4'h1;
				end
			//设置元位和十元位
			else if(!set_money_mid)
				begin
					if(money[7:4]==9)
						money[7:4]<=4'h0;
					else 
						money[7:4]<=money[7:4]+4'h1;
				end
			else if(!set_money_high)
				begin
					if(money[11:8]==9)
						money[11:8]<=4'h0;
					else 
						money[11:8]<=money[11:8]+4'h1;
				end
			*/
			
			else //设置卡内初值
			if(!set_money_low)
				begin
					realmoney<=realmoney+1;
				end
			else if(!set_money_mid)
				begin
					realmoney<=realmoney+10;
				end
			else if(!set_money_high)
				begin
					realmoney<=realmoney+100;
				end
			else
			//b.通话计费
			if(card && on) //若卡已插入且线路已接通
				begin
					if(min_clk) //且通话时间够1分钟
						case (category)
							2'b01: //（1）若话务为市话
								begin
									if(realmoney<12'd3) //① 若卡上余额<3角，则告警
										begin
											warn<=1;
											write<=0;
										end
									else //② 若卡上余额>3角，则对市话计费
										begin
											realmoney<=realmoney-3;
											write<=1; 
											warn<=0; //③ 准备写卡，warn清0
										end
								end
							2'b10: //（2）若话务为长话
								begin
									if(realmoney<12'd6) //① 若卡上余额<6角，则告警
										begin
											warn<=1;
											write<=0;
										end
									else //② 若卡上余额>6角，则对市话计费
										begin
											realmoney<=realmoney-6;
											write<=1; 
											warn<=0; //③ 准备写卡，warn清0
										end
								end
							2'b11:
								begin
									realmoney<=realmoney;
									warn<=0;
								end
							default:
								begin
									realmoney<=realmoney;
									warn<=0;
								end
						endcase
					else //若min_clk=0
						begin
							write<=0; //则不写卡
							if(flag) 
								warn<=0; //若告警时间达到15s, 则warn变为低电平
							if(warn) //若有告警信号
								begin
									if(cnt_warning==15)
										begin 
											cut<=1;
											flag<=1;
											cnt_warning<=0;
										end //若计到15s，则自动切断通话，flag置1
									else
										begin
											cnt_warning<=cnt_warning+1;
											flag<=0;
										end//若未到15s，则cnt_warning加1计数, flag置0
								end
							else //没warning
								begin 
									cnt_warning<=0; 
									cut<=0; 
									flag<=0;
								end
						end
				end
			else //若卡已拔出或线路未接通，则对一些信号进行复位
				begin 
					write<=0; 
					warn<=0;
					cnt_warning<=0;
					cut<=0; 
					flag<=0;
				end
		end
		
endmodule


//分频器，进入50M的时钟，输出1K，4Hz
module clkdiv(clkin, clrn, clk_1kHz, clk_4Hz);
input clkin;
input clrn;
output reg clk_1kHz;
output reg clk_4Hz;

parameter count_width= 50000;

reg[14:0] count1;
reg[7:0] count2;

always @(posedge clkin, negedge clrn) //5000分频
	begin
		if(!clrn)
			begin
				count1<=0;
				clk_1kHz<=0;
			end
		else 
			begin
				if(count1==count_width/2-1)
				begin
					clk_1kHz<=~clk_1kHz;
					count1<=0;
				end
				else
				begin
					count1<=count1+1;
					//clk_10kHz<=~clk_10kHz;
				end
			end
	end

always @(posedge clk_1kHz, negedge clrn)
	begin
		if(!clrn)
			begin
				count2<=0;
				clk_4Hz<=0;
			end
		else if(count2==124)
		begin
			clk_4Hz<=~clk_4Hz;
			count2<=0;
		end
		else
			begin
			count2<=count2+1; 
			//clk_1kHz=~clk_1kHz;
			end
	end
endmodule


//scan模块,1kHz输入，
module scan(clk, clrn,datain,scan_data,scan_en);
input clk; //1kHz时钟信号
input clrn;
input[11:0] datain; //输入
output reg[3:0] scan_data; //驱动数码管组0的用于扫描显示的BCD码信号
output reg[2:0] scan_en; //串行扫描数码管组0的位选择信号（高有效）

reg[1:0] state;

always @(posedge clk or negedge clrn)
	begin
		if (!clrn) //异步清零
			begin
				state<=0;//......state、scan_data和scan_en清零
				scan_data<=0;
				scan_en<=0;
			end
		else
			begin
				if(state==2) 
					state<=0; //状态机的状态转移
				else 
					state<=state+1'b1;
				case(state) //产生数码管的输入信号和位选择信号
					0://最高位数码管亮，显示秒高位
						begin
							scan_data<=datain[11:8];
							scan_en<=3'b100;
						end 
					1:
						begin
							scan_data<=datain[7:4];
							scan_en<=3'b010;
						end
					2:
						begin
							scan_data<=datain[3:0];
							scan_en<=4'b001;
						end
					/*3:
						begin
							scan_data<=secm[3:0];
							scan_en<=4'b0001;
						end
					*/
				endcase
			end
		end
		
endmodule

module p7seg(data,out);
input [3:0]data ; //七段数码管输入
output reg[6:0] out; //七段数码管字段输出，out[6:0]从最高位out[6]到最低位out[0]

always @(data ) //不能只写成always，否则仿真没有波形！
	case (data)
		4'd0: 
			out <= 7'b1000000 ;
		4'd1: 
			out <= 7'b1111001 ;
		4'd2: 
			out <= 7'b0100100 ;
		4'd3: 
			out <= 7'b0110000 ;
		4'd4: 
			out <= 7'b0011001 ;
		4'd5: 
			out <= 7'b0010010 ;
		4'd6: 
			out <= 7'b0000010 ;
		4'd7: 
			out <= 7'b1111000 ;
		4'd8: 
			out <= 7'b0000000 ;
		4'd9: 
			out <= 7'b0010000 ;
		default: 
			out <= 7'b1000000;//当data为4'hA~4'hF时，数码管显示数字0
	endcase

endmodule



module account_for_sim(clk_1kHz,clk_4Hz,card,on,category,set_money_high,set_money_mid, set_money_low, clrn, read_out,write_out, warn_out, cut_out, speaker_out, scan_en_1,disptime_7seg, scan_en_0,dispmoney_7seg);

input clk_1kHz,clk_4Hz; //来自分频子模块的时钟信号，频率分别为1kHz和4Hz
input card; //卡插入信号，当卡插入时，为高电平；卡拔出后，为低电平
input on; //接通信号，从电话局反馈回来的信号，高电平时表示线路已接通，低电平时表示线路未接通
input [1:0] category; //话务种类，从电话局反馈回来的信号，"01"表示市话，"10"表示长话，"11"表示特话
input set_money_high; //低有效，设置卡中金额的百位，单位为角，每按一下加1
input set_money_mid; //低有效，设置卡中金额的十位，单位为角，每按一下加1
input set_money_low; //低有效，设置卡中金额的个位，单位为角，每按一下加1
input clrn; //清零信号（低有效）
output read_out; //读卡信号，低有效
output write_out; //写卡信号，低有效
output warn_out; //当卡中余额不足时产生的告警信号。当打市话时，余额少于3角，打长话时，余额少于6角，即会产生告警信号。低有效，告警15s后变为高电平
output cut_out; //自动切断当前通话信号，当告警时间达到15s时cut变低
output speaker_out; //告警信号驱动蜂鸣器发声，低有效
output [2:0] scan_en_1; //串行扫描数码管组1的位选择信号，从最高位到最低位分别选择数码管组的从左往右第2个、第3个和第4个的数码管
output[6:0] disptime_7seg; //disptime的4位扫描数据经过7段译码后的输出，驱动数码管组1
output [2:0] scan_en_0; //串行扫描数码管组0的位选择信号，从最高位到最低位分别选择数码管组的从左往右第2个、第3个和第4个的数码管
output[6:0] dispmoney_7seg; //dispmoney的4位扫描数据经过7段译码后的输出，驱动数码管组0

wire[7:0] disptime; //显示本次通话的时长（要仿真），单位为分钟，这里假设能显示的最大时间为59分钟
wire[11:0] dispmoney; //显示卡内余额（要仿真），单位为角，这里假设能显示的最大数额为99.9元
wire[11:0] data_in_1; //将disptime[7:0]扩充为12位（因为scan.v中data_in为12位）
wire[3:0] scan_data_1; //驱动数码管组1的用于扫描显示的BCD码信号（要仿真），最低两位数码管扫描显示通话时间的高位和低位
wire[3:0] scan_data_0; //驱动数码管组0的用于扫描显示的BCD码信号（要仿真），低三位数码管扫描显示卡内余额的十元位、元位和角位
wire read; //读卡信号，当电话卡插入时变高，此时读卡
wire write; //写卡信号，当其上升沿到来时写卡
wire warn; //当卡中余额不足时产生的告警信号
wire cut; //自动切断当前通话信号，当告警时间达到15s时cut变高
wire speaker; //告警信号驱动蜂鸣器发声

//（1）调用核心子模块
//module account(clk_1kHz,clk_4Hz,card,on,category, set_money_high,set_money_mid,set_money_low,clrn,disptime,dispmoney,read, write,warn,cut, speaker);
account my_account(clk_1kHz,clk_4Hz,card,on,category, set_money_high,set_money_mid,set_money_low,clrn, disptime, dispmoney ,read, write, warn, cut, speaker);
//（2）调用数码管扫描显示子模块
assign data_in_1 = {4'b0000,disptime}; //将disptime[7:0]扩充为12位

//module scan(clk, clrn,datain,scan_data,scan_en);

scan my_scan1(clk_1kHz, clrn, data_in_1, scan_data_1, scan_en_1); //扫描显示通话时间
scan my_scan2(clk_1kHz, clrn, dispmoney, scan_data_0, scan_en_0); //扫描显示卡内余额


//（3）调用七段译码子模块
//module p7seg(data,out);

p7seg my_p7seg1(scan_data_1,disptime_7seg); //对通话时间七段译码
p7seg my_p7seg2(scan_data_0,dispmoney_7seg); //对卡内余额七段译码

//（4）将驱动LED的输出信号read、write、warn、cut和speaker均反相，使其变为低有效
assign read_out=!read;
assign write_out=!write;
assign warn_out=!warn;
assign cut_out=!cut;
assign speaker_out=speaker;

//…………

endmodule 


module account_top(clk,card,on,category,set_money_high,set_money_mid, set_money_low, clrn, read_out,write_out, warn_out, cut_out, speaker_out, scan_en_1,disptime_7seg, scan_en_0,dispmoney_7seg);

input clk;
input card; //卡插入信号，当卡插入时，为高电平；卡拔出后，为低电平
input on; //接通信号，从电话局反馈回来的信号，高电平时表示线路已接通，低电平时表示线路未接通
input [1:0] category; //话务种类，从电话局反馈回来的信号，"01"表示市话，"10"表示长话，"11"表示特话
input set_money_high; //低有效，设置卡中金额的百位，单位为角，每按一下加1
input set_money_mid; //低有效，设置卡中金额的十位，单位为角，每按一下加1
input set_money_low; //低有效，设置卡中金额的个位，单位为角，每按一下加1
input clrn; //清零信号（低有效）
output read_out; //读卡信号，低有效
output write_out; //写卡信号，低有效
output warn_out; //当卡中余额不足时产生的告警信号。当打市话时，余额少于3角，打长话时，余额少于6角，即会产生告警信号。低有效，告警15s后变为高电平
output cut_out; //自动切断当前通话信号，当告警时间达到15s时cut变低
output speaker_out; //告警信号驱动蜂鸣器发声，低有效
output [2:0] scan_en_1; //串行扫描数码管组1的位选择信号，从最高位到最低位分别选择数码管组的从左往右第2个、第3个和第4个的数码管
output[6:0] disptime_7seg; //disptime的4位扫描数据经过7段译码后的输出，驱动数码管组1
output [2:0] scan_en_0; //串行扫描数码管组0的位选择信号，从最高位到最低位分别选择数码管组的从左往右第2个、第3个和第4个的数码管
output[6:0] dispmoney_7seg; //dispmoney的4位扫描数据经过7段译码后的输出，驱动数码管组0

wire clk_1kHz,clk_4Hz; //来自分频子模块的时钟信号，频率分别为1kHz和4Hz
wire[7:0] disptime; //显示本次通话的时长（要仿真），单位为分钟，这里假设能显示的最大时间为59分钟
wire[11:0] dispmoney; //显示卡内余额（要仿真），单位为角，这里假设能显示的最大数额为99.9元
wire[11:0] data_in_1; //将disptime[7:0]扩充为12位（因为scan.v中data_in为12位）
wire[3:0] scan_data_1; //驱动数码管组1的用于扫描显示的BCD码信号（要仿真），最低两位数码管扫描显示通话时间的高位和低位
wire[3:0] scan_data_0; //驱动数码管组0的用于扫描显示的BCD码信号（要仿真），低三位数码管扫描显示卡内余额的十元位、元位和角位
wire read; //读卡信号，当电话卡插入时变高，此时读卡
wire write; //写卡信号，当其上升沿到来时写卡
wire warn; //当卡中余额不足时产生的告警信号
wire cut; //自动切断当前通话信号，当告警时间达到15s时cut变高
wire speaker; //告警信号驱动蜂鸣器发声

//module clkdiv(clkin, clrn, clk_1kHz, clk_4Hz);
clkdiv my_clkdiv(clk,clrn,clk_1kHz,clk_4Hz);

//（1）调用核心子模块
//module account(clk_1kHz,clk_4Hz,card,on,category, set_money_high,set_money_mid,set_money_low,clrn,disptime,dispmoney,read, write,warn,cut, speaker);
account my_account(clk_1kHz,clk_4Hz,card,on,category, set_money_high,set_money_mid,set_money_low,clrn,disptime,dispmoney,read, write,warn,cut, speaker);
//（2）调用数码管扫描显示子模块
assign data_in_1 = {4'b0000,disptime}; //将disptime[7:0]扩充为12位

//module scan(clk, clrn,datain,scan_data,scan_en);

scan my_scan1(clk_1kHz, clrn, data_in_1, scan_data_1, scan_en_1); //扫描显示通话时间
scan my_scan2(clk_1kHz, clrn, dispmoney, scan_data_0, scan_en_0); //扫描显示卡内余额


//（3）调用七段译码子模块
//module p7seg(data,out);

p7seg my_p7seg1(scan_data_1,disptime_7seg); //对通话时间七段译码
p7seg my_p7seg2(scan_data_0,dispmoney_7seg); //对卡内余额七段译码

//（4）将驱动LED的输出信号read、write、warn、cut和speaker均反相，使其变为低有效
assign read_out=!read;
assign write_out=!write;
assign warn_out=!warn;
assign cut_out=!cut;
assign speaker_out=speaker;

//…………

endmodule 




