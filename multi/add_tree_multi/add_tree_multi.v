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
input clk; //ϵͳʱ�ӣ�50MHz
input clrn; //�첽��λ�źţ������壩
//input start; //��������
input [7:0] a; //������
input [7:0] b; //����
//input load_a; //װ�ر��������ź�
//input load_b; //װ�س������ź�
output [15:0] p; //���յĳ˻�
//output done; //������ɱ�־
output[19:0] p_BCD; //���ճ˻�p��BCD�룬�Ա����������ʾ
output[3:0] scan_data_1; //�����������1������ɨ����ʾ��BCD���źţ�������ʾ�˻�����λBCD��
output scan_en_1; //�������1���λ����ܵ�λѡ���ź�
output[3:0] scan_data_0; //�����������0������ɨ����ʾ��BCD���źţ�����ɨ����ʾ��ʾ�˻���ǧ���١�ʮ����λBCD��
output[3:0] scan_en_0; //����ɨ���������0��λѡ���źţ������λ�����λ�ֱ�ѡ���������0�Ĵ������ҵ�1����2������3���͵�4���������
output[6:0] data_1_7seg; //scan_data_1����7������������������������1��7�ε�ƽ�ź�
output[6:0] data_0_7seg; //scan_data_0����7������������������������0��7�ε�ƽ�ź�

wire clk_10kHz; //�����˷�������ģ��Ļ�׼ʱ��
wire clk_1kHz; //���������ɨ����ʾ��ģ��Ļ�׼ʱ��

//module clkdiv(clkin, clrn, clk_10kHz, clk_1kHz);
clkdiv my_clkdiv(clk, clrn, clk_10kHz, clk_1kHz);

//module add_tree(clk_10kHz,clrn,a,b,p,p_BCD);
add_tree my_add_tree(clk_10kHz,clrn,a,b,p,p_BCD);
scan my_scan(clk_1kHz, clrn,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0);
p7seg p7seg1(scan_data_1,data_1_7seg);
p7seg p7seg2(scan_data_0,data_0_7seg);



endmodule


module add_tree_sim(clk_10kHz,clk_1kHz,clrn,a,b,p,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0,data_1_7seg,data_0_7seg);
input clk_10kHz; //ϵͳʱ�ӣ�50MHz
input clk_1kHz;
input clrn; //�첽��λ�źţ������壩
//input start; //��������
input [7:0] a; //������
input [7:0] b; //����
//input load_a; //װ�ر��������ź�
//input load_b; //װ�س������ź�
output [15:0] p; //���յĳ˻�
//output done; //������ɱ�־
output[19:0] p_BCD; //���ճ˻�p��BCD�룬�Ա����������ʾ
output[3:0] scan_data_1; //�����������1������ɨ����ʾ��BCD���źţ�������ʾ�˻�����λBCD��
output scan_en_1; //�������1���λ����ܵ�λѡ���ź�
output[3:0] scan_data_0; //�����������0������ɨ����ʾ��BCD���źţ�����ɨ����ʾ��ʾ�˻���ǧ���١�ʮ����λBCD��
output[3:0] scan_en_0; //����ɨ���������0��λѡ���źţ������λ�����λ�ֱ�ѡ���������0�Ĵ������ҵ�1����2������3���͵�4���������
output[6:0] data_1_7seg; //scan_data_1����7������������������������1��7�ε�ƽ�ź�
output[6:0] data_0_7seg; //scan_data_0����7������������������������0��7�ε�ƽ�ź�

//wire clk_10kHz; //�����˷�������ģ��Ļ�׼ʱ��
//wire clk_1kHz; //���������ɨ����ʾ��ģ��Ļ�׼ʱ��

//module clkdiv(clkin, clrn, clk_10kHz, clk_1kHz);
//clkdiv my_clkdiv(clk, clrn, clk_10kHz, clk_1kHz);
//module multiplier(clk_10kHz,clrn,start,a,b,load_a,load_b,p,done,p_BCD,state,a_lshift_r,b_rshift_r,sum,z);
add_tree my_add_tree(clk_10kHz,clrn,a,b,p,p_BCD);
scan my_scan(clk_1kHz, clrn,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0);
p7seg p7seg1(scan_data_1,data_1_7seg);
p7seg p7seg2(scan_data_0,data_0_7seg);

endmodule

//��Ƶ��������50M��ʱ�ӣ����10K��1K
module clkdiv(clkin, clrn, clk_10kHz, clk_1kHz);
input clkin;
input clrn;
output reg clk_10kHz;
output reg clk_1kHz;

parameter count_width= 5000;

reg[12:0] count1;
reg[3:0] count2;

always @(posedge clkin, negedge clrn) //5000��Ƶ
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



//1kHz���룬
module scan(clk, clrn,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0);
/*input clk; //1kHzʱ���ź�
input clrn;
input[3:0] dsec,sec,secd,secm; //���λ�����λ���ٷ����λ���ٷ����λ
output reg[3:0] scan_data; //�����������0������ɨ����ʾ��BCD���ź�
output reg[3:0] scan_en; //����ɨ���������0��λѡ���źţ�����Ч��*/

input clk; //�����ɨ����ʾ�Ļ�׼ʱ��
input clrn; //��λ�źţ�����Ч
input[19:0] p_BCD; //���Գ˷�������ģ�飬�˷���������BCD��
output reg[3:0] scan_data_1;//�����������1������ɨ����ʾ��BCD���ź�
output reg scan_en_1; //����ɨ���������1�����λ��ʹ���ź�
output reg[3:0] scan_data_0;//�����������0������ɨ����ʾ��BCD���ź�
output reg [3:0] scan_en_0; //����ɨ���������0��λѡ���źţ������λ�����λ�ֱ�ѡ���������0�Ĵ������ҵ�1����2������3���͵�4���������


reg[1:0] state;
parameter s0=2'd0, s1=2'd1, s2=2'd2, s3=2'd3;

always @(posedge clk or negedge clrn)
	begin
		if (!clrn) //�첽����
			begin
				state<=s0;//......state��scan_data��scan_en����
				
				scan_data_0<=0;
				scan_en_0<=0;
				//scan_data_1<=0;
			   //scan_en_1<=0;
			end
		else
			begin
				if(state==3) 
					state<=0; //״̬����״̬ת��
				else 
					state<=state+1'b1;
					//scan_data_1<=p_BCD[19:16];
					//scan_en_1<=1;
				case(state) //��������ܵ������źź�λѡ���ź�
					0://���λ�����������ʾ���λ
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
input [3:0]data ; //�߶����������
output reg[6:0] out; //�߶�������ֶ������out[6:0]�����λout[6]�����λout[0]

always @(data ) //����ֻд��always���������û�в��Σ�
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



module add_tree(clk_10kHz,clrn,a,b,p,p_BCD);

//��������źŶ��壺
input clk_10kHz; //�˷�������ģ��Ļ�׼ʱ��
input clrn; //�첽��λ�źţ������壩
input [7:0] a; //������
input [7:0] b; //����
output [15:0] p; //���յĳ˻�
output reg[19:0] p_BCD; //���ճ˻�p��BCD�룬�Ա����������ʾ

//�м������
reg[14:0] temp0; //�Ĵ������ݴ�a����b[7]��������7λ�Ľ��
reg[13:0] temp1; //�Ĵ������ݴ�a����b[6]��������6λ�Ľ��
reg[12:0] temp2; //�Ĵ������ݴ�a����b[5]��������5λ�Ľ��
reg[11:0] temp3; //�Ĵ������ݴ�a����b[4]��������4λ�Ľ��
reg[10:0] temp4; //�Ĵ������ݴ�a����b[3]��������3λ�Ľ��
reg[9:0] temp5; //�Ĵ������ݴ�a����b[2]��������2λ�Ľ��
reg[8:0] temp6; //�Ĵ������ݴ�a����b[1]��������1λ�Ľ��
reg[7:0] temp7; //�Ĵ������ݴ�a����b[0]�Ľ��

wire[15:0] out1; //��1���ӷ��������=temp0+temp1
wire[13:0] out2; //��1���ӷ��������=temp2+temp3
wire[11:0] out3; //��1���ӷ��������=temp4+temp5
wire[9:0] out4; //��1���ӷ��������=temp6+temp7
wire[15:0] c1; //��2���ӷ��������=out1+out2
wire[11:0] c2; //��2���ӷ��������=out3+out4

//��a���ú���ʵ��8��1�˷������㱻����a�����b��ÿһλ�ĳ˻�
function[7:0] mult8x1;
	input[7:0] operand;
	input sel; //���������λ
	begin
		mult8x1=(sel)?(operand):8'b00000000; 
	end
endfunction

//��b�����ú���ʵ�ֲ�����b��λ�������a��ˣ�Ȼ�����ƣ�����ݴ浽�Ĵ�����
always @(posedge clk_10kHz or negedge clrn)
	if(!clrn)//���Ĵ�������
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
		
	//��c���ӷ�������
	assign out1=temp0+temp1; //��1���ӷ���
	assign out2=temp2+temp3;
	assign out3=temp5+temp4;
	assign out4=temp6+temp7;
	
	assign c1=out1+out2; //��2���ӷ���
	assign c2=out3+out4;
	
	assign p = c1 + c2; //���ճ˻�

//��d�������ճ˻��Ķ�����ֵת��ΪBCD��
always @(posedge clk_10kHz,negedge clrn)
	if(!clrn)
		begin
			p_BCD<=0;
		end
	else
	begin	
		p_BCD[19:16]<=p/10000; //��λBCD��
		p_BCD[15:12]<=p/1000%10;//ǧλBCD��
		p_BCD[11:8]<=(p/100)%10; //��λBCD�롣�ѵ�
		p_BCD[7:4]<=p/10%10;//ʮλBCD��
		p_BCD[3:0]<=p%10; //��λBCD��
	end


endmodule 


