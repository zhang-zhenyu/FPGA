`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:52:20 05/17/2017 
// Design Name: 
// Module Name:    sp7seg 
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
module p7seg(data,out);
input [3:0]data ; //�߶����������
output reg[6:0] out; //�߶�������ֶ������out[6:0]�����λout[6]�����λout[0]

always @(data) //����ֻд��always���������û�в��Σ�
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
			out <= 7'b1000000;//��dataΪ4'hA~4'hFʱ���������ʾ����0
	endcase

endmodule
