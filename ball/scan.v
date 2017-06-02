`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:37:22 05/18/2017 
// Design Name: 
// Module Name:    scan 
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
//scan模块,1kHz输入，
module scan(clk_1kHz,reset,datain,scan_data,scan_en);
input clk_1kHz; //1kHz时钟信号
input reset;
input[15:0] datain; //输入
output reg[3:0] scan_data; //驱动数码管组0的用于扫描显示的BCD码信号
output reg[3:0] scan_en; //串行扫描数码管组0的位选择信号（高有效）

reg[1:0] state;

always @(posedge clk_1kHz or negedge reset)
	begin
		if (!reset) //异步清零
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
							scan_data<=datain[15:12];
							scan_en<=4'b1000;
						end 
					1:
						begin
							scan_data<=datain[11:8];
							scan_en<=4'b0100;
						end
					2:
						begin
							scan_data<=datain[7:4];
							scan_en<=4'b0010;
						end
					3:
						begin
							scan_data<=datain[3:0];
							scan_en<=4'b0001;
						end
					
				endcase
			end
		end
		
endmodule
