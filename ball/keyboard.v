`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:35:20 05/14/2017 
// Design Name: 
// Module Name:    keyboard 
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
module keyboard(clk_50MHz,reset,kb_clk,kb_data,upl,downl);
input clk_50MHz;		//系统时钟，750kHz
input reset;	//系统复位信号，低有效
input kb_clk;	//鼠标时钟线，双向信号，本实验假定为20kHz
input kb_data;	//鼠标数据线，双向信号
output upl;	
output downl;
//output reg valid; //为便于仿真，声明为输出
//output reg[10:0] senddata; //移位寄存器，暂存主机要发送的使能命令，为便于仿真，声明为输出

//中间变量
reg kb_clk_filtered;//过滤后的键盘时钟信号，在其下降沿时读取键盘数据
reg [7:0] filter; //过滤变量，存放最近的连续8 个时钟信号
reg clk_25MHz; //从50MHz 二分频得到的25MHz 时钟信号
reg read_char; //读取数据标志位，为"1"时表示正在读取数据帧
reg ready_set; //读取数据完成标志位，读取8 位数据完成时置"1"
reg got_f0; //为"1"时表示已读入f0H（读到断码）
reg [3:0] in_cnt; //对已接收键盘数据的位数计数（8 个数据位及1 位校验位）
reg [8:0] shift_in; //移位寄存器，用于临时存储读取的一帧9 位数据
reg [7:0] scan_code;//存储8 位扫描码
reg got_f0_ttl;

// ① 当按下【A】或【S】键时，产生upl 或downl 信号
assign upl=((scan_code==8'h1C)&&(got_f0 == 1'b0))?1:0; //当按下A 键时
assign downl=((scan_code==8'h1B)&&(got_f0 == 1'b0))?1:0; //当按下S 键时

// ② 二分频，得到频率为25MHz 的时钟信号clk_25MHz
always @ (posedge clk_50MHz,negedge reset)
	begin
		if(!reset)
			begin
				clk_25MHz<=0;
			end
		else 
			begin
				clk_25MHz<=~clk_25MHz;
			end
	end
	
// ③ 为避免信号干扰，过滤从键盘传输过来的原始时钟信号
always @ (posedge clk_25MHz)
	begin
		filter<={kb_clk,filter[7:1]};
		if(filter==8'b11111111)
			begin
				kb_clk_filtered<=1'b1;
			end
		else if(filter==8'b00000000)
			begin
				kb_clk_filtered<=1'b0;
			end
	end //产生kb_clk_filtered

// ④ 在过滤后的键盘时钟的下降沿主机接收键盘数据（关键！）
always @ (negedge kb_clk_filtered or negedge reset)
	begin
		if (!reset) //系统复位时不允许读
			begin
				read_char<=0;// read_char、ready_set、got_f0 、in_cnt、scan_code 清零
				ready_set<=0;
				got_f0<=0;
				in_cnt<=0;
				scan_code<=0;
				got_f0_ttl<=0;
			end
		else //复位完成
			begin
				if ((kb_data == 1'b 0) && (read_char == 1'b 0))//0 为起始位，开始读取数据
					begin
						read_char<=1;
						ready_set<=0;
					end // read_char 置1，ready_set 置0
				else
					begin
						if (read_char == 1'b 1) //若已开始读取数据帧
							begin
								if (in_cnt < 4'd9) //若已接收数据的位数小于9
									begin //则读入8 个数据位及校验位
										shift_in[8:0] <= {kb_data,shift_in[8:1]};
										in_cnt <= in_cnt + 1'b 1;
									end
								else //若已读取完一帧
									begin
										if (shift_in[7:0] == 8'hf0) 
											begin
												got_f0 <= 1'b1;
												got_f0_ttl<=1;
											end
										else if(got_f0_ttl==1)
											begin
												got_f0_ttl<=got_f0_ttl-1;
											end
										else 
											begin
												got_f0 <= 1'b0;
											end
										scan_code<=shift_in[7:0];//将读取的8 位数据输出到扫描码
										in_cnt<=0;// read_char 清零，ready_set 置"1"，in_cnt 清零
										read_char<=0;
										ready_set<=1;
									end
							end
					end
			end
	end
endmodule
