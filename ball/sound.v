`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:01:25 05/17/2017 
// Design Name: 
// Module Name:    sound 
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
module sound(reset,clk_6MHz,clk_10Hz,LftCollision,RgtCollision,speaker);

input reset;
input clk_6MHz;
input clk_10Hz;
input LftCollision;
input RgtCollision;
output reg speaker;

wire ring_pulse; //为LftCollision与RgtCollision的或
reg [4:0] level_cnt=0; //对脉冲信号转换为电平信号的时间计数
reg ring_level=0; //将LftCollision或RgtCollision脉冲信号转换为电平信号
reg[3:0] counter=0; //时长计数器，用于控制每个音符的时长
reg[3:0] high,mid,low; //分别用于显示高音、中音和低音音符
reg[14:0] origen,divider; //音调分频预置数，音调分频计数器
//wire carry; //divider计满标志

// ① 将脉冲信号转换为 一个长度将脉冲信号转换为 一个长度1秒的电平信号
assign ring_pulse=LftCollision||RgtCollision; //只有 40ns宽（见 宽（见 Ball.v）
always @(posedge clk_10Hz or posedge ring_pulse)
	begin
		if(ring_pulse&&level_cnt==0) 
			begin
				ring_level<=1;
			end
		else if(ring_level==1)
			begin
				if(level_cnt==9)//level_cnt加 1计数， 计数， 计够 10个数 后清零 后清零
					begin
						ring_level<=0;
						level_cnt<=0;
					end
				else
					begin
						level_cnt<=level_cnt+1;
					end
			end
	end

// ② 记谱，根据时长计数器的值 决定高音、中和低
always @(posedge clk_10Hz)
	begin
		if (!ring_level) 
			counter<=4'd0;
		else
			begin
				if(counter==9)//只有在 ring_level为"1"时 counter加 1计数 ,且最多计到 9
					counter<=0;
				else
					begin
						counter<=counter+1;
					end
			end
		case(counter) //记谱
			4'd1:	{high,mid,low}=12'h007; //中音 3
			4'd2: {high,mid,low}=12'h010; //中音 3
			4'd3: {high,mid,low}=12'h020; //中音 3
			4'd4: {high,mid,low}=12'h030; //中音 3
			4'd5: {high,mid,low}=12'h040; //中音 3
			4'd6: {high,mid,low}=12'h050; //中音 3
			4'd7: {high,mid,low}=12'h060; //中音 3
			4'd8: {high,mid,low}=12'h070; //中音 3
			4'd9: {high,mid,low}=12'h000; //中音 3
			
		endcase
	end

// ③ 根据高音、中和低的值 决定分频计数器预置根据决定分频计数器预置
always @(posedge clk_10Hz, negedge reset)
	begin
		if (!reset) 
			origen=9102;
		else 
			begin
				case({high,mid,low})
					12'h001: origen=22936; //低音 3
					12'h002: origen=20429; //低音 3
					12'h003: origen=18204; //低音 3
					12'h004: origen=17182; //低音 3
					12'h005: origen=15036; //低音 3
					12'h006: origen=13636; //低音 3
					12'h007: origen=12148; //低音 3
					12'h010: origen=11466; //低音 3
					12'h020: origen=10216; //低音 3
					12'h030: origen=9102; //低音 3
					12'h040: origen=8590; //低音 3
					12'h050: origen=7652; //低音 3
					12'h060: origen=6818; //低音 3
					12'h070: origen=6074; //低音 3
					12'h100: origen=5734; //低音 3
					12'h200: origen=5108; //低音 3
					12'h300: origen=4550; //低音 3
					12'h400: origen=4296; //低音 3
					12'h500: origen=3828; //低音 3
					12'h600: origen=3410; //低音 3
					12'h700: origen=3038; //低音 3
					default:
						begin
							origen=110;//休止符
						end
				endcase
			end
	end
	
// ④ 对音调分频计数，产生进位
always @(posedge clk_6MHz or negedge reset) //（a）音调分频计数 
	begin
		if (!reset)
			begin//分频计数器赋最大值
				divider<=0;
				speaker<=0;
			end
		else if(!ring_level)
			begin
				speaker<=0;
				divider<=0; //没有碰撞信号时不进行分频
			end
		else//只有在 ring_level为"1"divider加 1计数
			begin
			if(origen==110)
					begin
						speaker<=0;
					end
				else
				if(divider==origen/2-1)
					begin
						speaker<=~speaker;
						divider<=0;
					end
				else 
					begin
						divider<=divider+1;
					end
			end
	end
			
endmodule
