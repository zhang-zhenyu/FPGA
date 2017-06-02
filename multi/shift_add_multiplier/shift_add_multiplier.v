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
module shift_add_multiplier(clk,clrn,start,a,b,load_a,load_b,p,done,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0,data_1_7seg,data_0_7seg);
input clk; //ϵͳʱ�ӣ�50MHz
input clrn; //�첽��λ�źţ������壩
input start; //��������
input [7:0] a; //������
input [7:0] b; //����
input load_a; //װ�ر��������ź�
input load_b; //װ�س������ź�
output [15:0] p; //���յĳ˻�
output done; //������ɱ�־
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
//module multiplier(clk_10kHz,clrn,start,a,b,load_a,load_b,p,done,p_BCD,state,a_lshift_r,b_rshift_r,sum,z);
multiplier my_multiplier(clk_10kHz,clrn,start,a,b,load_a,load_b,p,done,p_BCD,state,a_lshift_r,b_rshift_r,sum,z);
scan my_scan(clk_1kHz, clrn,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0);
p7seg p7seg1(scan_data_1,data_1_7seg);
p7seg p7seg2(scan_data_0,data_0_7seg);



endmodule


module shift_add_multiplier_sim(clk_10kHz,clk_1kHz,clrn,start,a,b,load_a,load_b,p,done,p_BCD,scan_data_1,scan_en_1,scan_data_0,scan_en_0,data_1_7seg,data_0_7seg);
input clk_10kHz; //ϵͳʱ�ӣ�50MHz
input clk_1kHz;
input clrn; //�첽��λ�źţ������壩
input start; //��������
input [7:0] a; //������
input [7:0] b; //����
input load_a; //װ�ر��������ź�
input load_b; //װ�س������ź�
output [15:0] p; //���յĳ˻�
output done; //������ɱ�־
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
multiplier my_multiplier(clk_10kHz,clrn,start,a,b,load_a,load_b,p,done,p_BCD,state,a_lshift_r,b_rshift_r,sum,z);
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
				scan_en_0<=0;
				scan_data_0<=0;
				
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

always @(posedge clk, negedge clrn)
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



module multiplier(clk_10kHz,clrn,start,a,b,load_a,load_b,p,done,p_BCD,state,a_lshift_r,b_rshift_r,sum,z);

input clk_10kHz; //�˷�������ģ��Ļ�׼ʱ��
input clrn; //�첽��λ
input start; //��������
input [7:0] a; //������
input [7:0] b; //����
input load_a; //װ�ر��������ź�
input load_b; //װ�س������ź�

output reg[15:0] p; //���յĳ˻�
output reg done; //������ɱ�־
output reg[19:0] p_BCD;//���ճ˻�p��BCD�룬�Ա����������ʾ

output reg[1:0]state; //״̬���ĵ�ǰ״̬
//integer j; //���������Ƶ�ѭ������
//integer k; //�������Ƶ�ѭ������
output reg[15:0] a_lshift_r;//���������ƼĴ�����load_a=1ʱ��a_lshift_r= {{8{1'b0}},a}
output reg[7:0] b_rshift_r; //�������ƼĴ�����load_b=1ʱ��b_rshift_r=b
output reg [15:0] sum; //���ֻ�
output reg z; //Ϊ1ʱ��ʾ����ȫ��������ɣ�������Ϊ0

parameter S1=2'b00, S2=2'b01, S3=2'b10;//state������״̬��S1װ�����ݣ�S2�������㣬S3��ʾ�������

//reg load_complete,flag_a,flag_b;


//��a��״̬��ת�ƺ�״̬�Ĵ�����ʱ���߼���
always @(posedge clk_10kHz or negedge clrn)
	begin
		if(clrn==0)
			begin
				state<=S1;
				
				/*load_complete<=0;
				flag_a<=0;
				flag_b<=0;*/
			end
		else
			case(state)
			S1:
				begin
					if(start==1)
						begin
							state<=S2;
						end 
				end
			S2:
				begin
					if(z)
						state<=S3;
					else
						state<=S2;
				end
			S3:
				begin
					if(start)
						state<=S3;
					else
						state<=S1;
				end
		endcase
	end

//��b��״̬�������ʱ���߼���
always @(posedge clk_10kHz or negedge clrn)
	if(!clrn)
	begin
		z<=0;
		done<=0;
		p<=0;
		a_lshift_r<=0;
		b_rshift_r<=0;
		sum<=0;
	end
	else
	begin
		case(state)
			S1:
				begin //�� װ�ز�����
					if(load_a)
						begin
							a_lshift_r<={8'b0000_0000,a};
							//flag_a<=1;
						end
					if(load_b)
						begin
							b_rshift_r<=b;
							//flag_b<=1;
						end
					/*if(flag_a&&flag_b)
						begin
							load_complete<=1;
						end*/
				end
			S2:
				begin //�� ���г˷�����
					//������ʱ���������ɳ���������������������ɣ�������Ϊ0ʱ��ʹ��־λz=1����״̬������ת����һ״̬S3
					if(b_rshift_r[0]) 
						sum<=sum+a_lshift_r; //ֻ�г������λΪ1ʱ��a����iλ�Ľ���벿�ֻ����
						
					a_lshift_r<=a_lshift_r<<1;//ÿ��ʱ�ӱ���������1λ
					b_rshift_r<=b_rshift_r>>1;//ÿ��ʱ�ӳ�������1λ
					
					if(b_rshift_r==0) 
						begin
							p<=sum; //���յĳ˻�
							z<=1;
						end
				end
			S3: //�� �˷��������
				begin
					done<=1;	
				end
		endcase
	end

//����z��־λ
//assign z=����; //zΪ1ʱ��ʾ����ȫ��������ɣ�������Ϊ0

//��c�������ճ˻��Ķ�����ֵת��ΪBCD��
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


