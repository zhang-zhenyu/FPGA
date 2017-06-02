`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:22:42 05/17/2017 
// Design Name: 
// Module Name:    music 
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
module music(reset,clk_6MHz,clk_10Hz,LftWin,RgtWin,speaker);
input reset;
input clk_6MHz;
input clk_10Hz;
input LftWin;
input RgtWin;
output reg speaker;

wire ring_pulse; //为LftCollision与RgtCollision的或
//reg [3:0] level_cnt; //对脉冲信号转换为电平信号的时间计数
//reg ring_level; //将LftCollision或RgtCollision脉冲信号转换为电平信号
reg[5:0] counter; //时长计数器，用于控制每个音符的时长
reg[3:0] high,mid,low; //分别用于显示高音、中音和低音音符
reg[13:0] origen,divider; //音调分频预置数，音调分频计数器
//wire carry; //divider计满标志

// ① 将脉冲信号转换为 一个长度将脉冲信号转换为 一个长度1秒的电平信号
assign ring_pulse=LftWin||RgtWin; //只有 40ns宽（见 宽（见 Ball.v）


// ② 记谱，根据时长计数器的值 决定高音、中和低
always @(posedge clk_10Hz)
	begin
		if (!ring_pulse) 
			counter<=0;
		else
			begin
				if(counter==30)//只有在 ring_level为"1"时 counter加 1计数 ,且最多计到 9
					counter<=30;
				else
					begin
						counter<=counter+1;
					end
			end
		case(counter) //记谱
			6'd1: {high,mid,low}=12'h010; //中音 3
			6'd2: {high,mid,low}=12'h020; //中音 3
			6'd3: {high,mid,low}=12'h030; //中音 3
			6'd4: {high,mid,low}=12'h040; //中音 3
			6'd5: {high,mid,low}=12'h050; //中音 3
			6'd6: {high,mid,low}=12'h060; //中音 3
			6'd7: {high,mid,low}=12'h070; //中音 3
			6'd8: {high,mid,low}=12'h010; //中音 3
			6'd9: {high,mid,low}=12'h020; //中音 3
			6'd10: {high,mid,low}=12'h030; //中音 3
			6'd11: {high,mid,low}=12'h040; //中音 3
			6'd12: {high,mid,low}=12'h050; //中音 3
			6'd13: {high,mid,low}=12'h060; //中音 3
			6'd14: {high,mid,low}=12'h070; //中音 3
			6'd15: {high,mid,low}=12'h010; //中音 3
			6'd16: {high,mid,low}=12'h020; //中音 3
			6'd17: {high,mid,low}=12'h030; //中音 3
			6'd18: {high,mid,low}=12'h040; //中音 3
			6'd19: {high,mid,low}=12'h050; //中音 3
			6'd20: {high,mid,low}=12'h060; //中音 3
			6'd21: {high,mid,low}=12'h070; //中音 3
			6'd22: {high,mid,low}=12'h010; //中音 3
			6'd23: {high,mid,low}=12'h020; //中音 3
			6'd24: {high,mid,low}=12'h030; //中音 3
			6'd25: {high,mid,low}=12'h040; //中音 3
			6'd26: {high,mid,low}=12'h050; //中音 3
			6'd27: {high,mid,low}=12'h060; //中音 3
			6'd28: {high,mid,low}=12'h070; //中音 3
			6'd29: {high,mid,low}=12'h010; //中音 3
			6'd30: {high,mid,low}=12'h000; //中音 3
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
		else if(!ring_pulse)
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
				else if(divider==origen/2-1)
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
