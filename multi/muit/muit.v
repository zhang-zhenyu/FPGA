`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:58:41 04/18/2017 
// Design Name: 
// Module Name:    muit 
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
module muit(a,b,outcome);

parameter n=8;
input  [n-1:0]a;
input  [n-1:0]b;
output [2*n-1:0] outcome;

assign outcome=a*b;


endmodule
