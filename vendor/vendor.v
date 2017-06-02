`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:28:32 04/26/2017 
// Design Name: 
// Module Name:    vendor 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vendor_core(clk_1Hz,clk_1kHz,rstn,suren,goods,money,led_warn,led,led_half_out,price,sum,returned,dis_price,dis_money,dis_returned,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);
	
input clk_1Hz; //1Hz时钟信号
input clk_1kHz; //数码管扫描基准时钟，Tclk=1ms
input rstn; //系统复位信号（负脉冲）
input suren; //确认购买信号（负脉冲）
input [3:0] goods; //某1位为"1"时选择某种商品，从最低到最高分别对应价格为5角、1元、1.5元和2元的商品
input [2:0] money; //选择投入的钱币面值，001：5角，010：1元，100：5元。可以同时投入多种面值钱币，3种钱币共8种组合


output reg led_warn; //钱不足时告警指示灯（低有效）
output [3:0] led; //LED显示消费者购买的商品（低有效），从最低位到最高位分别对应价格为5角、1元、1.5元和2元的商品
output reg led_half_out; //找零指示灯（低有效）

output reg [4:0] price; //所选商品价格。为便于观察其变化，声明为输出，内存价格
output reg[6:0] sum; //投入钱币的总金额,按分计，内存钱数
output reg[6:0]returned; //找零金额或是投入钱币小于商品价格时退回所投钱币

output [7:0] dis_price ; //所选商品价格的高位和低位BCD码
output [7:0] dis_money; //投入钱币金额的高位和低位BCD码
output [7:0] dis_returned ; //找零金额的高位和低位BCD码

output [3:0] scan_en_1; //串行扫描数码管组1的位选择信号（高有效）
output [3:0] scan_en_0; //串行扫描数码管组0的位选择信号（高有效）
output [6:0] data_1_7seg; //驱动数码管组1的7段电平信号（低有效），低两位数码管扫描显示所选商品价格的高位和低位
output [6:0] data_0_7seg; //驱动数码管组0的7段电平信号（低有效），高两位扫描显示投入钱币金额的高位和低位，低两位扫描显示找零金额的高位和低位
wire[3:0] scan_data_1;
wire [3:0] scan_data_0;

//中间变量


reg read_complete;
reg [2:0] times; //用于对按下确认购买键后的时间计数，5秒后自动返回到初始状态
//reg finished;


assign dis_price[7:4]=price/10;
assign dis_price[3:0]=price%10;
assign dis_money[7:4]=sum/10;
assign dis_money[3:0]=sum%10;
assign dis_returned[7:4]=returned/10;
assign dis_returned[3:0]=returned%10;

assign led[3]=~goods[3];
assign led[2]=~goods[2];
assign led[1]=~goods[1];
assign led[0]=~goods[0];

//module scan(clk, clrn,dsec,sec,secd,secm ,scan_data,scan_en);
scan my_scan0(clk_1kHz,rstn,dis_money[7:4],dis_money[3:0],dis_returned[7:4],dis_returned[3:0],scan_data_1,scan_en_1);
scan my_scan1(clk_1kHz,rstn,4'b0000,4'b0000,dis_price[7:4],dis_price[3:0] ,scan_data_0,scan_en_0);

//module p7seg(data,out);
p7seg my_p7seg1(scan_data_1,data_1_7seg);
p7seg my_p7seg0(scan_data_0,data_0_7seg);

always @(negedge rstn,negedge suren, posedge clk_1Hz)
	begin
		if(!rstn)
			begin
				sum<=0;
				price<=0;
				read_complete<=0;
				times<=0;
				returned<=0;
				//finished<=0;
				//returned<=0;
				//scan_en_1=0;
				//scan_en_0=0;
			end
		else //if(!read_complete)
			//begin
				if(!suren)
					begin
						sum<=50*money[2]+10*money[1]+5*money[0];
						price<=goods[3]*20+goods[2]*15+goods[1]*10+goods[0]*5;
						read_complete<=1;
						
					end
			//end
		else if(read_complete==1)
			begin
				if(times==5)
					 begin
						read_complete<=0;
						//finished<=1;
						times<=0;
						led_warn<=1;
						led_half_out<=1;
						sum<=0;
						price<=0;
						returned<=0;
					end
				else
					begin
						times<=times+1;
						//finished<=0;
						if(sum>=price)//钱够
							begin
								led_warn<=1;
								led_half_out<=0;
								returned<=sum-price;
							end
						else//钱不够
							begin
								led_warn<=0;
								led_half_out<=1;
								returned<=0;
							end
					end
					
				
			end
		
		
		
	end
	

/*always@(negedge read_complete)
	begin
		sum<=0;
		price<=0;
		returned<=0;
	end

*/



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

//分频器，进入50M的时钟，输出1K，1
module clkdiv(clkin,clk_1kHz, clk_1Hz);
input clkin;
//input clrn;
output reg clk_1kHz;
output reg clk_1Hz;

parameter count_width= 5000;

reg clk_10kHz;
reg[12:0] count1;
reg[3:0] count2;
reg[8:0] count3;

always @(posedge clkin) //5000分频
	begin
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

always @(posedge clk_10kHz)
	begin
		
	if(count2==4)
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
	
always @(posedge clk_1kHz)
	begin
		if(count3==499)
		begin
			clk_1Hz<=~clk_1Hz;
			count3<=0;
		end
		else
			begin
			count3<=count3+1; 
			//clk_1kHz=~clk_1kHz;
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



module vendor_top(clk,rst_button,sure_button,goods,money,led_warn,led,led_half_out,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);
input clk; //1Hz时钟信号
//input clk_1kHz; //数码管扫描基准时钟，Tclk=1ms
input rst_button; //系统复位信号（负脉冲）
input sure_button; //确认购买信号（负脉冲）
input [3:0] goods; //某1位为"1"时选择某种商品，从最低到最高分别对应价格为5角、1元、1.5元和2元的商品
input [2:0] money; //选择投入的钱币面值，001：5角，010：1元，100：5元。可以同时投入多种面值钱币，3种钱币共8种组合


output led_warn; //钱不足时告警指示灯（低有效）
output [3:0] led; //LED显示消费者购买的商品（低有效），从最低位到最高位分别对应价格为5角、1元、1.5元和2元的商品
output led_half_out; //找零指示灯（低有效）

output [3:0] scan_en_1; //串行扫描数码管组1的位选择信号（高有效）
output [3:0] scan_en_0; //串行扫描数码管组0的位选择信号（高有效）
output [6:0] data_1_7seg; //驱动数码管组1的7段电平信号（低有效），低两位数码管扫描显示所选商品价格的高位和低位
output [6:0] data_0_7seg; //驱动数码管组0的7段电平信号（低有效），高两位扫描显示投入钱币金额的高位和低位，低两位扫描显示找零金额的高位和低位

wire rstn;
wire suren;


wire[4:0] price; //所选商品价格。为便于观察其变化，声明为输出，内存价格
wire[6:0] sum; //投入钱币的总金额,按分计，内存钱数
wire[6:0]returned; //找零金额或是投入钱币小于商品价格时退回所投钱币

wire [7:0] dis_price ; //所选商品价格的高位和低位BCD码
wire [7:0] dis_money; //投入钱币金额的高位和低位BCD码
wire [7:0] dis_returned ; //找零金额的高位和低位BCD码

wire [3:0] scan_data_1;
wire [3:0] scan_data_0;

wire clk_1Hz; //1Hz时钟信号
wire clk_1kHz; //数码管扫描基准时钟，Tclk=1ms
//module button(clk_1kHz,pbn,signal);
button button_rstn(clk_1kHz,rst_button,rstn);
button button_suren(clk_1kHz,sure_button,suren);

clkdiv myclkdiv(clk,clk_1kHz, clk_1Hz);

//module vendor_core(clk_1Hz,clk_1kHz,rstn,suren,goods,money,led_warn,led,led_half_out,price,sum,returned,dis_price,dis_money,dis_returned,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);
vendor_core vendor_for_top(clk_1Hz,clk_1kHz,rstn,suren,goods,money,led_warn,led,led_half_out,price,sum,returned,dis_price,dis_money,dis_returned,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);




endmodule

//module vendor_core(clk_1Hz,clk_1kHz,rstn,suren,goods,money,led_warn,led,led_half_out,price,sum,returned,dis_price,dis_money,dis_returned,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);

module vendor_sim(clk_1Hz,clk_1kHz,rst_button,sure_button,goods,money,led_warn,led,led_half_out,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);
input clk_1Hz; //1Hz时钟信号
input clk_1kHz; //数码管扫描基准时钟，Tclk=1ms
input rst_button; //系统复位信号（负脉冲）
input sure_button; //确认购买信号（负脉冲）
input [3:0] goods; //某1位为"1"时选择某种商品，从最低到最高分别对应价格为5角、1元、1.5元和2元的商品
input [2:0] money; //选择投入的钱币面值，001：5角，010：1元，100：5元。可以同时投入多种面值钱币，3种钱币共8种组合


output led_warn; //钱不足时告警指示灯（低有效）
output [3:0] led; //LED显示消费者购买的商品（低有效），从最低位到最高位分别对应价格为5角、1元、1.5元和2元的商品
output led_half_out; //找零指示灯（低有效）

output [3:0] scan_en_1; //串行扫描数码管组1的位选择信号（高有效）
output [3:0] scan_en_0; //串行扫描数码管组0的位选择信号（高有效）
output [6:0] data_1_7seg; //驱动数码管组1的7段电平信号（低有效），低两位数码管扫描显示所选商品价格的高位和低位
output [6:0] data_0_7seg; //驱动数码管组0的7段电平信号（低有效），高两位扫描显示投入钱币金额的高位和低位，低两位扫描显示找零金额的高位和低位

wire rstn;
wire suren;


wire[4:0] price; //所选商品价格。为便于观察其变化，声明为输出，内存价格
wire[6:0] sum; //投入钱币的总金额,按分计，内存钱数
wire[6:0]returned; //找零金额或是投入钱币小于商品价格时退回所投钱币

wire [7:0] dis_price ; //所选商品价格的高位和低位BCD码
wire [7:0] dis_money; //投入钱币金额的高位和低位BCD码
wire [7:0] dis_returned ; //找零金额的高位和低位BCD码

wire [3:0] scan_data_1;
wire [3:0] scan_data_0;

//module button(clk_1kHz,pbn,signal);
button button_rstn(clk_1kHz,rst_button,rstn);
button button_suren(clk_1kHz,sure_button,suren);

//module vendor_core(clk_1Hz,clk_1kHz,rstn,suren,goods,money,led_warn,led,led_half_out,price,sum,returned,dis_price,dis_money,dis_returned,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);
vendor_core vendor_for_sim(clk_1Hz,clk_1kHz,rstn,suren,goods,money,led_warn,led,led_half_out,price,sum,returned,dis_price,dis_money,dis_returned,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);




endmodule
