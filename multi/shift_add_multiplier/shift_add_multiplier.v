`timescale 1us / 1ns
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:24:38 04/18/2017 
// Design Name: 
// Module Name:    shift_add_multiplier 
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
module shift_add_multiplier(clk,clrn,start,a,b,load_a,load_b,p,done,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0,data_1_7seg,data_0_7seg);
input clk; //系统时钟，50MHz
input clrn; //异步复位信号（负脉冲）
input start; //启动计算
input [7:0] a; //被乘数
input [7:0] b; //乘数
input load_a; //装载被乘数的信号
input load_b; //装载乘数的信号
output [15:0] p; //最终的乘积
output done; //运算完成标志
output[19:0] p_BCD; //最终乘积p的BCD码，以便于数码管显示
output[3:0] scan_data_1; //驱动数码管组1的用于扫描显示的BCD码信号，用于显示乘积的万位BCD码
output scan_en_1; //数码管组1最低位数码管的位选择信号
output[3:0] scan_data_0; //驱动数码管组0的用于扫描显示的BCD码信号，用于扫描显示显示乘积的千、百、十、个位BCD码
output[3:0] scan_en_0; //串行扫描数码管组0的位选择信号，从最高位到最低位分别选择数码管组0的从左往右第1个、2个、第3个和第4个的数码管
output[6:0] data_1_7seg; //scan_data_1经过7段译码后的输出，驱动数码管组1的7段电平信号
output[6:0] data_0_7seg; //scan_data_0经过7段译码后的输出，驱动数码管组0的7段电平信号

wire clk_10kHz; //用作乘法计数子模块的基准时钟
wire clk_1kHz; //用作数码管扫描显示子模块的基准时钟

//module clkdiv(clkin, clrn, clk_10kHz, clk_1kHz);
clkdiv my_clkdiv(clk, clrn, clk_10kHz, clk_1kHz);
//module multiplier(clk_10kHz,clrn,start,a,b,load_a,load_b,p,done,p_BCD,state,a_lshift_r,b_rshift_r,sum,z);
multiplier my_multiplier(clk_10kHz,clrn,start,a,b,load_a,load_b,p,done,p_BCD,state,a_lshift_r,b_rshift_r,sum,z);
scan my_scan(clk_1kHz, clrn,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0);
p7seg p7seg1(scan_data_1,data_1_7seg);
p7seg p7seg2(scan_data_0,data_0_7seg);



endmodule


module shift_add_multiplier_sim(clk_10kHz,clk_1kHz,clrn,start,a,b,load_a,load_b,p,done,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0,data_1_7seg,data_0_7seg);
input clk_10kHz; //系统时钟，50MHz
input clk_1kHz;
input clrn; //异步复位信号（负脉冲）
input start; //启动计算
input [7:0] a; //被乘数
input [7:0] b; //乘数
input load_a; //装载被乘数的信号
input load_b; //装载乘数的信号
output [15:0] p; //最终的乘积
output done; //运算完成标志
output[19:0] p_BCD; //最终乘积p的BCD码，以便于数码管显示
output[3:0] scan_data_1; //驱动数码管组1的用于扫描显示的BCD码信号，用于显示乘积的万位BCD码
output scan_en_1; //数码管组1最低位数码管的位选择信号
output[3:0] scan_data_0; //驱动数码管组0的用于扫描显示的BCD码信号，用于扫描显示显示乘积的千、百、十、个位BCD码
output[3:0] scan_en_0; //串行扫描数码管组0的位选择信号，从最高位到最低位分别选择数码管组0的从左往右第1个、2个、第3个和第4个的数码管
output[6:0] data_1_7seg; //scan_data_1经过7段译码后的输出，驱动数码管组1的7段电平信号
output[6:0] data_0_7seg; //scan_data_0经过7段译码后的输出，驱动数码管组0的7段电平信号

//wire clk_10kHz; //用作乘法计数子模块的基准时钟
//wire clk_1kHz; //用作数码管扫描显示子模块的基准时钟

//module clkdiv(clkin, clrn, clk_10kHz, clk_1kHz);
//clkdiv my_clkdiv(clk, clrn, clk_10kHz, clk_1kHz);
//module multiplier(clk_10kHz,clrn,start,a,b,load_a,load_b,p,done,p_BCD,state,a_lshift_r,b_rshift_r,sum,z);
multiplier my_multiplier(clk_10kHz,clrn,start,a,b,load_a,load_b,p,done,p_BCD,state,a_lshift_r,b_rshift_r,sum,z);
scan my_scan(clk_1kHz, clrn,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0);
p7seg p7seg1(scan_data_1,data_1_7seg);
p7seg p7seg2(scan_data_0,data_0_7seg);

endmodule

//分频器，进入50M的时钟，输出10K，1K
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



//1kHz输入，
module scan(clk, clrn,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0);
/*input clk; //1kHz时钟信号
input clrn;
input[3:0] dsec,sec,secd,secm; //秒高位、秒低位、百分秒高位、百分秒低位
output reg[3:0] scan_data; //驱动数码管组0的用于扫描显示的BCD码信号
output reg[3:0] scan_en; //串行扫描数码管组0的位选择信号（高有效）*/

input clk; //数码管扫描显示的基准时钟
input clrn; //复位信号，低有效
input[19:0] p_BCD; //来自乘法运算子模块，乘法运算结果的BCD码
output reg[3:0] scan_data_1;//驱动数码管组1的用于扫描显示的BCD码信号
output reg scan_en_1; //串行扫描数码管组1的最低位的使能信号
output reg[3:0] scan_data_0;//驱动数码管组0的用于扫描显示的BCD码信号
output reg [3:0] scan_en_0; //串行扫描数码管组0的位选择信号，从最高位到最低位分别选择数码管组0的从左往右第1个、2个、第3个和第4个的数码管


reg[1:0] state;
parameter s0=2'd0, s1=2'd1, s2=2'd2, s3=2'd3;

always @(posedge clk or negedge clrn)
	begin
		if (!clrn) //异步清零
			begin
				state<=s0;//......state、scan_data和scan_en清零
				scan_en_0<=0;
				scan_data_0<=0;
				
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
							scan_data_0<=p_BCD[15:12];
							scan_en_0<=4'b1000;
						end 
					1:
						begin
							scan_data_0<=p_BCD[11:8];
							scan_en_0<=4'b0100;
						end
					2:
						begin
							scan_data_0<=p_BCD[7:4];
							scan_en_0<=4'b0010;
						end
					3:
						begin
							scan_data_0<=p_BCD[3:0];
							scan_en_0<=4'b0001;
						end
				endcase
			end
		end

always @(posedge clk, negedge clrn)
	if(!clrn)
		begin
			scan_data_1<=0;
			scan_en_1<=0;
		end
	else
		begin
			scan_data_1<=p_BCD[19:16];
			scan_en_1<=1;
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



module multiplier(clk_10kHz,clrn,start,a,b,load_a,load_b,p,done,p_BCD,state,a_lshift_r,b_rshift_r,sum,z);

input clk_10kHz; //乘法计数子模块的基准时钟
input clrn; //异步复位
input start; //启动计算
input [7:0] a; //被乘数
input [7:0] b; //乘数
input load_a; //装载被乘数的信号
input load_b; //装载乘数的信号

output reg[15:0] p; //最终的乘积
output reg done; //运算完成标志
output reg[19:0] p_BCD;//最终乘积p的BCD码，以便于数码管显示

output reg[1:0]state; //状态机的当前状态
//integer j; //被乘数左移的循环变量
//integer k; //乘数右移的循环变量
output reg[15:0] a_lshift_r;//被乘数左移寄存器，load_a=1时，a_lshift_r= {{8{1'b0}},a}
output reg[7:0] b_rshift_r; //乘数右移寄存器，load_b=1时，b_rshift_r=b
output reg [15:0] sum; //部分积
output reg z; //为1时表示乘数全部右移完成，乘数变为0

parameter S1=2'b00, S2=2'b01, S3=2'b10;//state的三个状态，S1装载数据，S2进行运算，S3表示运算完成

//reg load_complete,flag_a,flag_b;


//（a）状态的转移和状态寄存器（时序逻辑）
always @(posedge clk_10kHz or negedge clrn)
	begin
		if(clrn==0)
			begin
				state<=S1;
				
				/*load_complete<=0;
				flag_a<=0;
				flag_b<=0;*/
			end
		else
			case(state)
			S1:
				begin
					if(start==1)
						begin
							state<=S2;
						end 
				end
			S2:
				begin
					if(z)
						state<=S3;
					else
						state<=S2;
				end
			S3:
				begin
					if(start)
						state<=S3;
					else
						state<=S1;
				end
		endcase
	end

//（b）状态机输出（时序逻辑）
always @(posedge clk_10kHz or negedge clrn)
	if(!clrn)
	begin
		z<=0;
		done<=0;
		p<=0;
		a_lshift_r<=0;
		b_rshift_r<=0;
		sum<=0;
	end
	else
	begin
		case(state)
			S1:
				begin //① 装载操作数
					if(load_a)
						begin
							a_lshift_r<={8'b0000_0000,a};
							//flag_a<=1;
						end
					if(load_b)
						begin
							b_rshift_r<=b;
							//flag_b<=1;
						end
					/*if(flag_a&&flag_b)
						begin
							load_complete<=1;
						end*/
				end
			S2:
				begin //② 进行乘法运算
					//持续的时钟周期数由乘数决定，当乘数右移完成，乘数变为0时，使标志位z=1，则状态机将跳转到下一状态S3
					if(b_rshift_r[0]) 
						sum<=sum+a_lshift_r; //只有乘数最低位为1时，a左移i位的结果与部分积相加
						
					a_lshift_r<=a_lshift_r<<1;//每个时钟被乘数左移1位
					b_rshift_r<=b_rshift_r>>1;//每个时钟乘数右移1位
					
					if(b_rshift_r==0) 
						begin
							p<=sum; //最终的乘积
							z<=1;
						end
				end
			S3: //③ 乘法运算完成
				begin
					done<=1;	
				end
		endcase
	end

//设置z标志位
//assign z=……; //z为1时表示乘数全部右移完成，乘数变为0

//（c）将最终乘积的二进制值转换为BCD码
always @(posedge clk_10kHz,negedge clrn)
	if(!clrn)
		begin
			
			p_BCD<=0;
		end
	else
	begin	
		p_BCD[19:16]<=p/10000; //万位BCD码
		p_BCD[15:12]<=p/1000%10;//千位BCD码
		p_BCD[11:8]<=(p/100)%10; //百位BCD码。难点
		p_BCD[7:4]<=p/10%10;//十位BCD码
		p_BCD[3:0]<=p%10; //个位BCD码
	end


endmodule 


