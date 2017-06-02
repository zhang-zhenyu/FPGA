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
module add_tree_download(clk,clrn,a,b,p,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0,data_1_7seg,data_0_7seg);
input clk; //系统时钟，50MHz
input clrn; //异步复位信号（负脉冲）
//input start; //启动计算
input [7:0] a; //被乘数
input [7:0] b; //乘数
//input load_a; //装载被乘数的信号
//input load_b; //装载乘数的信号
output [15:0] p; //最终的乘积
//output done; //运算完成标志
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

//module add_tree(clk_10kHz,clrn,a,b,p,p_BCD);
add_tree my_add_tree(clk_10kHz,clrn,a,b,p,p_BCD);
scan my_scan(clk_1kHz, clrn,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0);
p7seg p7seg1(scan_data_1,data_1_7seg);
p7seg p7seg2(scan_data_0,data_0_7seg);



endmodule


module add_tree_sim(clk_10kHz,clk_1kHz,clrn,a,b,p,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0,data_1_7seg,data_0_7seg);
input clk_10kHz; //系统时钟，50MHz
input clk_1kHz;
input clrn; //异步复位信号（负脉冲）
//input start; //启动计算
input [7:0] a; //被乘数
input [7:0] b; //乘数
//input load_a; //装载被乘数的信号
//input load_b; //装载乘数的信号
output [15:0] p; //最终的乘积
//output done; //运算完成标志
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
add_tree my_add_tree(clk_10kHz,clrn,a,b,p,p_BCD);
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
				
				scan_data_0<=0;
				scan_en_0<=0;
				//scan_data_1<=0;
			   //scan_en_1<=0;
			end
		else
			begin
				if(state==3) 
					state<=0; //状态机的状态转移
				else 
					state<=state+1'b1;
					//scan_data_1<=p_BCD[19:16];
					//scan_en_1<=1;
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

always @(posedge clk,negedge clrn)
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



module add_tree(clk_10kHz,clrn,a,b,p,p_BCD);

//输入输出信号定义：
input clk_10kHz; //乘法计数子模块的基准时钟
input clrn; //异步复位信号（负脉冲）
input [7:0] a; //被乘数
input [7:0] b; //乘数
output [15:0] p; //最终的乘积
output reg[19:0] p_BCD; //最终乘积p的BCD码，以便于数码管显示

//中间变量：
reg[14:0] temp0; //寄存器，暂存a乘以b[7]后又左移7位的结果
reg[13:0] temp1; //寄存器，暂存a乘以b[6]后又左移6位的结果
reg[12:0] temp2; //寄存器，暂存a乘以b[5]后又左移5位的结果
reg[11:0] temp3; //寄存器，暂存a乘以b[4]后又左移4位的结果
reg[10:0] temp4; //寄存器，暂存a乘以b[3]后又左移3位的结果
reg[9:0] temp5; //寄存器，暂存a乘以b[2]后又左移2位的结果
reg[8:0] temp6; //寄存器，暂存a乘以b[1]后又左移1位的结果
reg[7:0] temp7; //寄存器，暂存a乘以b[0]的结果

wire[15:0] out1; //第1级加法器的输出=temp0+temp1
wire[13:0] out2; //第1级加法器的输出=temp2+temp3
wire[11:0] out3; //第1级加法器的输出=temp4+temp5
wire[9:0] out4; //第1级加法器的输出=temp6+temp7
wire[15:0] c1; //第2级加法器的输出=out1+out2
wire[11:0] c2; //第2级加法器的输出=out3+out4

//（a）该函数实现8×1乘法，计算被乘数a与乘数b的每一位的乘积
function[7:0] mult8x1;
	input[7:0] operand;
	input sel; //乘数的最低位
	begin
		mult8x1=(sel)?(operand):8'b00000000; 
	end
endfunction

//（b）调用函数实现操作数b各位与操作数a相乘，然后左移，结果暂存到寄存器中
always @(posedge clk_10kHz or negedge clrn)
	if(!clrn)//各寄存器清零
		begin
			
			//p<=0;
			temp0<=0;
			temp1<=0;
			temp2<=0;
			temp3<=0;
			temp4<=0;
			temp5<=0;
			temp6<=0;
			temp7<=0;
		end 
	else
		begin
			temp7<=mult8x1(a,b[0]);
			temp6<=((mult8x1(a,b[1]))<<1);
			temp5<=((mult8x1(a,b[2]))<<2);
			temp4<=((mult8x1(a,b[3]))<<3);
			temp3<=((mult8x1(a,b[4]))<<4);
			temp2<=((mult8x1(a,b[5]))<<5);
			temp1<=((mult8x1(a,b[6]))<<6);
			temp0<=((mult8x1(a,b[7]))<<7);
		end
		
	//（c）加法树运算
	assign out1=temp0+temp1; //第1级加法器
	assign out2=temp2+temp3;
	assign out3=temp5+temp4;
	assign out4=temp6+temp7;
	
	assign c1=out1+out2; //第2级加法器
	assign c2=out3+out4;
	
	assign p = c1 + c2; //最终乘积

//（d）将最终乘积的二进制值转换为BCD码
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


