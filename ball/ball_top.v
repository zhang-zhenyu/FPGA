`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:03:49 05/17/2017 
// Design Name: 
// Module Name:    ball_top 
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
module ball_top(reset,clk_25MHz,clk_12MHz,kb_clk,kb_data,mouse_clk,mouse_data,reset_game,red,green,blue,speaker,h_sync,v_sync,left,right,scan_en_l,scan_en_r);
input reset;
input clk_25MHz;
input clk_12MHz;
input kb_clk;
input kb_data;
inout mouse_clk;
inout mouse_data;
input reset_game;

output red;
output green;
output blue;
output speaker;
output h_sync;
output v_sync;
output [6:0]left;
output [6:0]right;
output [3:0]scan_en_l;
output [3:0]scan_en_r;
//wire clk_6MHz;
//wire clk_10Hz;
//wire LftCollision;
//wire RgtCollision;
wire [8:0]line;
wire [9:0]pixel;
wire [10:0]senddata;

wire [8:0]PaddlePos1;
wire [8:0]PaddlePos2;

wire [3:0]Lftscore;
wire [3:0]Rgtscore;

wire [3:0]scan_data_l;
wire [3:0]scan_data_r;

//wire clk_25MHz;
//wire upl,downl;
//wire upr,downr;
//clkdiv my_clkdiv(reset,clk_25MHz,clk_12MHz,clk_6MHz,clk_10Hz);
clkdiv my_clkdiv(reset,clk_25MHz,clk_12MHz,clk_6MHz,clk_10Hz,clk_1kHz);
//clkdiv my_clkdiv(reset,clk_25MHz,clk_12MHz,clk_25MHz,clk_6MHz,clk_10Hz);
keyboard my_keyboard(clk_25MHz,reset,kb_clk,kb_data,upl,downl);
mouse my_mouse(clk_12MHz,reset,mouse_clk,mouse_data,upr,downr,valid,senddata[10:0]);
syncgen my_syncgen(reset,clk_25MHz,v_sync,h_sync,line[8:0],pixel[9:0]);

paddle my_paddle(clk_25MHz,reset,v_sync,upl,downl,line[8:0],pixel[9:0],BRPad1,PaddlePos1[8:0]);
paddle2 my_paddle2(clk_25MHz,reset,v_sync,upr,downr,line[8:0],pixel[9:0],BRPad2,PaddlePos2[8:0]);
wall2 my_walls(clk_25MHz,line[8:0],pixel[9:0],BRWall,BRIW);

ball my_ball(clk_25MHz,reset_mark,v_sync,PaddlePos1,PaddlePos2,line[8:0],pixel[9:0],BRBall,LftCollision,RgtCollision);
look my_look(clk_25MHz,BRPad1,BRPad2,BRBall,BRWall,BRIW,red,green,blue);
//module mark(Lftcollision,Rgtcollision,reset,Lftscore,Rgtscore,Lftwin,Rgtwin);
mark my_mark(LftCollision,RgtCollision,reset_mark,Lftscore[3:0],Rgtscore[3:0],LftWin,RgtWin);

sound my_sound(reset,clk_6MHz,clk_10Hz,LftCollision,RgtCollision,speaker_f);
music my_music(reset,clk_6MHz,clk_10Hz,LftWin,RgtWin,speaker_w);
//sound mysound(reset,clk_6MHz,clk_10Hz,LftCollision,RgtCollision,speaker);

//module scan(clk_1kHz,reset,datain,scan_data,scan_en);
scan my_scan_l(clk_1kHz,reset,{12'h000,Lftscore[3:0]},scan_data_l[3:0],scan_en_l[3:0]);
scan my_scan_r(clk_1kHz,reset,{12'h000,Rgtscore[3:0]},scan_data_r[3:0],scan_en_r[3:0]);
p7seg p7seg_l(scan_data_l[3:0],left);
p7seg p7seg_r(scan_data_r[3:0],right);

assign speaker=(LftWin||RgtWin)?speaker_w:speaker_f;
and and1(reset_mark,reset,reset_game);

endmodule
