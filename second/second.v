`timescale 1ns / 1ps

module second(clk, startstopn, clrn,data_out,scan_en,cn);

input clk; //系统时钟信号（f=50MHz）
input startstopn; //启/停信号（负脉冲）
input clrn; //复位信号（负脉冲）
output [6:0] data_out; //驱动数码管组0的7段电平信号（低有效），data_out[6:0]
output [3:0] scan_en; //串行扫描数码管组0的位选择信号（高有效），从高到低分别选择最左边至最右边的数码管
output cn;//向分钟的进位信号

wire clk_10kHz; //10kHz时钟信号（要仿真）
wire clk_1kHz; //1kHz时钟信号（要仿真）
wire startstopn_out; //经过按键消抖后的按键输出信号
wire TFF_clk; //对经过按键消抖后的按键输出信号startstopn_out反相，使其变为正脉冲
wire [6:0] cnt_debounce; //对按键消抖定时的计数器

reg enable; //T'FF的输出信号，随startstopn_out信号翻转，为1时允许计数；为0时暂停计数

//以下中间变量要仿真
wire clko; //分频电路子模块clkdiv100.v的输出时钟信号，T=0.01s
wire [3:0] dsec; //秒高位BCD码计数器
wire [3:0] sec; //秒低位BCD码计数器
wire [3:0] secd; //百分秒高位BCD码计数器
wire [3:0] secm; //百分秒低位BCD码计数器
wire[3:0] scan_data; //驱动数码管组0的用于扫描显示的BCD码信号


assign TFF_clk = ~startstopn_out; //中间节点，对startstopn_out反相，使下降沿有效改为上升沿有效，TFF_clk作为T'FF的时钟信号

always @(posedge TFF_clk or negedge clrn)
	begin
		if(!clrn) 
			enable<=0; //clrn为异步清零信号，低有效
		else 
			enable<=~enable; //来一次startstopn，enable翻转一次，相当于T'FF
	end
	
	
//（2）调用分频器、button、bcdcnt、scan和p7seg子模块
//module clkdiv(clkin, clrn, clk_10kHz, clk_1kHz);
clkdiv my_clkdiv(clk,clrn,clk_10kHz,clk_1kHz);

//module clkdiv100(clkin, en, clrn, clkout);
//分频器2，进入 10k，输出100Hz, en为1是启动计数，en为0时暂停计数
clkdiv100 my_clkdiv100(clk_10kHz,enable,clrn,clko);

//module button(clk_1kHz,pbn,signal);
button my_button(clk_1kHz,startstopn,startstopn_out);

//module bcdcnt(clkin,clrn, dsec,sec,secd,secm,cn);
bcdcnt my_bcdcnt(clko,clrn,dsec,sec,secd,secm,cn);

//1kHz输入，
//module scan(clk, clrn,dsec,sec,secd,secm ,scan_data,scan_en);
scan my_scan(clk_1kHz,clrn,dsec,sec,secd,secm,scan_data,scan_en);

//module p7seg(data,out);
p7seg my_p7seg(scan_data,data_out);


//……


endmodule


//分频器1，进入50M的时钟，输出10K，1K
module clkdiv(clkin, clrn, clk_10kHz, clk_1kHz);
input clkin;
input clrn;
output reg clk_10kHz;
output reg clk_1kHz;

parameter count_width= 5000;

reg[12:0] count1;
reg[3:0] count2;

always @(posedge clkin, negedge clrn) //5000分频
	begin
		if(!clrn)
			begin
				count1<=0;
				clk_10kHz<=0;
			end
		else 
			begin
				if(count1==count_width/2-1)
				begin
					clk_10kHz<=~clk_10kHz;
					count1<=0;
				end
				else
				begin
					count1<=count1+1;
					//clk_10kHz<=~clk_10kHz;
				end
			end
	end

always @(posedge clk_10kHz, negedge clrn)
	begin
		if(!clrn)
			begin
				count2<=0;
				clk_1kHz<=0;
			end
		else if(count2==4)
		begin
			clk_1kHz<=~clk_1kHz;
			count2<=0;
		end
		else
			begin
			count2<=count2+1; 
			//clk_1kHz=~clk_1kHz;
			end
	end
endmodule

//分频器2，进入 10k，输出100Hz, en为1是启动计数，en为0时暂停计数
module clkdiv100(clkin, en, clrn, clkout);
input clkin;
input en;
input clrn;
output reg clkout;
reg[6:0] count;

always @(posedge clkin, negedge clrn,negedge en)
	begin
		if(!clrn)
			begin
				count<=0;
				clkout<=0;
			end
		else if(en==0)
			begin
				count<=count;
			end
		else if(count==49)
			begin
				clkout<=~clkout;
				count<=0;
			end
		else
			begin
				count<=count+1;
			end
	end
	
endmodule


//按键消抖，只响应按键被按下的第一个负脉冲，并输出一个宽度一定的（120ms）的负脉冲信号
module button(clk_1kHz,pbn,signal);
parameter count_width=121;

input clk_1kHz,pbn;
output reg signal;

reg[6:0] cnt;
reg enable;

always @(posedge clk_1kHz)
	begin
		if(enable)//enable有效
			begin
				cnt=cnt+1;
				//signal=1;
				if(cnt==121)
					begin
						cnt=0;
						enable=0;
						signal=1;
					end
			end
		else if(!pbn)
			begin
				cnt=0;
				enable=1;
				signal=0;
			end
		else 
			begin
				cnt=0;
				enable=0;
				signal=1;
			end
	end
	
endmodule

//BCD码计数器，输入 100Hz时钟
module bcdcnt(clkin,clrn, dsec,sec,secd,secm,cn);
input clkin,clrn;
output reg[3:0] dsec,sec,secd,secm;
output reg cn;

always @(posedge clkin or negedge clrn)
	begin	
		if (!clrn) // 1）异步清零
			begin
				cn<=0;//进位信号和各计数器清零
				dsec<=0;
				sec<=0;
				secd<=0;
				secm<=0;
			end
		else //2）计数，采用4个if语句的嵌套
			begin
				if(secm[3:0]==9) //百分秒低位是否为9？
					begin
						secm[3:0]<=0;
						if(secd[3:0]==9) //百分秒高位是否为9？
							begin
								secd[3:0]<=0;
								if(sec==9)
									begin
										sec<=0;
										if(dsec==5)
											begin
												cn<=1;
												dsec<=0;
												sec<=0;
												secd<=0;
												secm<=0;			
											end
										else
											begin
												dsec<=dsec+1;
											end
									end
								else
									begin
										sec<=sec+1;
									end
							end
						else
							begin
								secd<=secd+1;
							end
					end
				else
					begin
						secm<=secm+1;
					end
			end			
	end
endmodule


//1kHz输入，
module scan(clk, clrn,dsec,sec,secd,secm ,scan_data,scan_en);
input clk; //1kHz时钟信号
input clrn;
input[3:0] dsec,sec,secd,secm; //秒高位、秒低位、百分秒高位、百分秒低位
output reg[3:0] scan_data; //驱动数码管组0的用于扫描显示的BCD码信号
output reg[3:0] scan_en; //串行扫描数码管组0的位选择信号（高有效）

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
				if(state==3) 
					state<=0; //状态机的状态转移
				else 
					state<=state+1'b1;
				case(state) //产生数码管的输入信号和位选择信号
					0://最高位数码管亮，显示秒高位
						begin
							scan_data<=dsec[3:0];
							scan_en<=4'b1000;
						end 
					1:
						begin
							scan_data<=sec[3:0];
							scan_en<=4'b0100;
						end
					2:
						begin
							scan_data<=secd[3:0];
							scan_en<=4'b0010;
						end
					3:
						begin
							scan_data<=secm[3:0];
							scan_en<=4'b0001;
						end
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





 
