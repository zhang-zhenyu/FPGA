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
//scanģ��,1kHz���룬
module scan(clk_1kHz,reset,datain,scan_data,scan_en);
input clk_1kHz; //1kHzʱ���ź�
input reset;
input[15:0] datain; //����
output reg[3:0] scan_data; //�����������0������ɨ����ʾ��BCD���ź�
output reg[3:0] scan_en; //����ɨ���������0��λѡ���źţ�����Ч��

reg[1:0] state;

always @(posedge clk_1kHz or negedge reset)
	begin
		if (!reset) //�첽����
			begin
				state<=0;//......state��scan_data��scan_en����
				scan_data<=0;
				scan_en<=0;
			end
		else
			begin
				if(state==3) 
					state<=0; //״̬����״̬ת��
				else 
					state<=state+1'b1;
				case(state) //��������ܵ������źź�λѡ���ź�
					0://���λ�����������ʾ���λ
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
