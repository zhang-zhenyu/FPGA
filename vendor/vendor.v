`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:28:32 04/26/2017 
// Design Name: 
// Module Name:    vendor 
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
module vendor_core(clk_1Hz,clk_1kHz,rstn,suren,goods,money,led_warn,led,led_half_out,price,sum,returned,dis_price,dis_money,dis_returned,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);
	
input clk_1Hz; //1Hzʱ���ź�
input clk_1kHz; //�����ɨ���׼ʱ�ӣ�Tclk=1ms
input rstn; //ϵͳ��λ�źţ������壩
input suren; //ȷ�Ϲ����źţ������壩
input [3:0] goods; //ĳ1λΪ"1"ʱѡ��ĳ����Ʒ������͵���߷ֱ��Ӧ�۸�Ϊ5�ǡ�1Ԫ��1.5Ԫ��2Ԫ����Ʒ
input [2:0] money; //ѡ��Ͷ���Ǯ����ֵ��001��5�ǣ�010��1Ԫ��100��5Ԫ������ͬʱͶ�������ֵǮ�ң�3��Ǯ�ҹ�8�����


output reg led_warn; //Ǯ����ʱ�澯ָʾ�ƣ�����Ч��
output [3:0] led; //LED��ʾ�����߹������Ʒ������Ч���������λ�����λ�ֱ��Ӧ�۸�Ϊ5�ǡ�1Ԫ��1.5Ԫ��2Ԫ����Ʒ
output reg led_half_out; //����ָʾ�ƣ�����Ч��

output reg [4:0] price; //��ѡ��Ʒ�۸�Ϊ���ڹ۲���仯������Ϊ������ڴ�۸�
output reg[6:0] sum; //Ͷ��Ǯ�ҵ��ܽ��,���ּƣ��ڴ�Ǯ��
output reg[6:0]returned; //���������Ͷ��Ǯ��С����Ʒ�۸�ʱ�˻���ͶǮ��

output [7:0] dis_price ; //��ѡ��Ʒ�۸�ĸ�λ�͵�λBCD��
output [7:0] dis_money; //Ͷ��Ǯ�ҽ��ĸ�λ�͵�λBCD��
output [7:0] dis_returned ; //������ĸ�λ�͵�λBCD��

output [3:0] scan_en_1; //����ɨ���������1��λѡ���źţ�����Ч��
output [3:0] scan_en_0; //����ɨ���������0��λѡ���źţ�����Ч��
output [6:0] data_1_7seg; //�����������1��7�ε�ƽ�źţ�����Ч��������λ�����ɨ����ʾ��ѡ��Ʒ�۸�ĸ�λ�͵�λ
output [6:0] data_0_7seg; //�����������0��7�ε�ƽ�źţ�����Ч��������λɨ����ʾͶ��Ǯ�ҽ��ĸ�λ�͵�λ������λɨ����ʾ������ĸ�λ�͵�λ
wire[3:0] scan_data_1;
wire [3:0] scan_data_0;

//�м����


reg read_complete;
reg [2:0] times; //���ڶ԰���ȷ�Ϲ�������ʱ�������5����Զ����ص���ʼ״̬
//reg finished;


assign dis_price[7:4]=price/10;
assign dis_price[3:0]=price%10;
assign dis_money[7:4]=sum/10;
assign dis_money[3:0]=sum%10;
assign dis_returned[7:4]=returned/10;
assign dis_returned[3:0]=returned%10;

assign led[3]=~goods[3];
assign led[2]=~goods[2];
assign led[1]=~goods[1];
assign led[0]=~goods[0];

//module scan(clk, clrn,dsec,sec,secd,secm ,scan_data,scan_en);
scan my_scan0(clk_1kHz,rstn,dis_money[7:4],dis_money[3:0],dis_returned[7:4],dis_returned[3:0],scan_data_1,scan_en_1);
scan my_scan1(clk_1kHz,rstn,4'b0000,4'b0000,dis_price[7:4],dis_price[3:0] ,scan_data_0,scan_en_0);

//module p7seg(data,out);
p7seg my_p7seg1(scan_data_1,data_1_7seg);
p7seg my_p7seg0(scan_data_0,data_0_7seg);

always @(negedge rstn,negedge suren, posedge clk_1Hz)
	begin
		if(!rstn)
			begin
				sum<=0;
				price<=0;
				read_complete<=0;
				times<=0;
				returned<=0;
				//finished<=0;
				//returned<=0;
				//scan_en_1=0;
				//scan_en_0=0;
			end
		else //if(!read_complete)
			//begin
				if(!suren)
					begin
						sum<=50*money[2]+10*money[1]+5*money[0];
						price<=goods[3]*20+goods[2]*15+goods[1]*10+goods[0]*5;
						read_complete<=1;
						
					end
			//end
		else if(read_complete==1)
			begin
				if(times==5)
					 begin
						read_complete<=0;
						//finished<=1;
						times<=0;
						led_warn<=1;
						led_half_out<=1;
						sum<=0;
						price<=0;
						returned<=0;
					end
				else
					begin
						times<=times+1;
						//finished<=0;
						if(sum>=price)//Ǯ��
							begin
								led_warn<=1;
								led_half_out<=0;
								returned<=sum-price;
							end
						else//Ǯ����
							begin
								led_warn<=0;
								led_half_out<=1;
								returned<=0;
							end
					end
					
				
			end
		
		
		
	end
	

/*always@(negedge read_complete)
	begin
		sum<=0;
		price<=0;
		returned<=0;
	end

*/



endmodule

//1kHz���룬
module scan(clk, clrn,dsec,sec,secd,secm ,scan_data,scan_en);
input clk; //1kHzʱ���ź�
input clrn;
input[3:0] dsec,sec,secd,secm; //���λ�����λ���ٷ����λ���ٷ����λ
output reg[3:0] scan_data; //�����������0������ɨ����ʾ��BCD���ź�
output reg[3:0] scan_en; //����ɨ���������0��λѡ���źţ�����Ч��

reg[1:0] state;

always @(posedge clk or negedge clrn)
	begin
		if (!clrn) //�첽����
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
							scan_data<=dsec[3:0];
							scan_en<=4'b1000;
						end 
					1:
						begin
							scan_data<=sec[3:0];
							scan_en<=4'b0100;
						end
					2:
						begin
							scan_data<=secd[3:0];
							scan_en<=4'b0010;
						end
					3:
						begin
							scan_data<=secm[3:0];
							scan_en<=4'b0001;
						end
				endcase
			end
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

//��Ƶ��������50M��ʱ�ӣ����1K��1
module clkdiv(clkin,clk_1kHz, clk_1Hz);
input clkin;
//input clrn;
output reg clk_1kHz;
output reg clk_1Hz;

parameter count_width= 5000;

reg clk_10kHz;
reg[12:0] count1;
reg[3:0] count2;
reg[8:0] count3;

always @(posedge clkin) //5000��Ƶ
	begin
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

always @(posedge clk_10kHz)
	begin
		
	if(count2==4)
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
	
always @(posedge clk_1kHz)
	begin
		if(count3==499)
		begin
			clk_1Hz<=~clk_1Hz;
			count3<=0;
		end
		else
			begin
			count3<=count3+1; 
			//clk_1kHz=~clk_1kHz;
			end
	end
endmodule


//����������ֻ��Ӧ���������µĵ�һ�������壬�����һ�����һ���ģ�120ms���ĸ������ź�
module button(clk_1kHz,pbn,signal);
parameter count_width=121;

input clk_1kHz,pbn;
output reg signal;

reg[6:0] cnt;
reg enable;

always @(posedge clk_1kHz)
	begin
		if(enable)//enable��Ч
			begin
				cnt=cnt+1;
				//signal=1;
				if(cnt==121)
					begin
						cnt=0;
						enable=0;
						signal=1;
					end
			end
		else if(!pbn)
			begin
				cnt=0;
				enable=1;
				signal=0;
			end
		else 
			begin
				cnt=0;
				enable=0;
				signal=1;
			end
	end
	
endmodule



module vendor_top(clk,rst_button,sure_button,goods,money,led_warn,led,led_half_out,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);
input clk; //1Hzʱ���ź�
//input clk_1kHz; //�����ɨ���׼ʱ�ӣ�Tclk=1ms
input rst_button; //ϵͳ��λ�źţ������壩
input sure_button; //ȷ�Ϲ����źţ������壩
input [3:0] goods; //ĳ1λΪ"1"ʱѡ��ĳ����Ʒ������͵���߷ֱ��Ӧ�۸�Ϊ5�ǡ�1Ԫ��1.5Ԫ��2Ԫ����Ʒ
input [2:0] money; //ѡ��Ͷ���Ǯ����ֵ��001��5�ǣ�010��1Ԫ��100��5Ԫ������ͬʱͶ�������ֵǮ�ң�3��Ǯ�ҹ�8�����


output led_warn; //Ǯ����ʱ�澯ָʾ�ƣ�����Ч��
output [3:0] led; //LED��ʾ�����߹������Ʒ������Ч���������λ�����λ�ֱ��Ӧ�۸�Ϊ5�ǡ�1Ԫ��1.5Ԫ��2Ԫ����Ʒ
output led_half_out; //����ָʾ�ƣ�����Ч��

output [3:0] scan_en_1; //����ɨ���������1��λѡ���źţ�����Ч��
output [3:0] scan_en_0; //����ɨ���������0��λѡ���źţ�����Ч��
output [6:0] data_1_7seg; //�����������1��7�ε�ƽ�źţ�����Ч��������λ�����ɨ����ʾ��ѡ��Ʒ�۸�ĸ�λ�͵�λ
output [6:0] data_0_7seg; //�����������0��7�ε�ƽ�źţ�����Ч��������λɨ����ʾͶ��Ǯ�ҽ��ĸ�λ�͵�λ������λɨ����ʾ������ĸ�λ�͵�λ

wire rstn;
wire suren;


wire[4:0] price; //��ѡ��Ʒ�۸�Ϊ���ڹ۲���仯������Ϊ������ڴ�۸�
wire[6:0] sum; //Ͷ��Ǯ�ҵ��ܽ��,���ּƣ��ڴ�Ǯ��
wire[6:0]returned; //���������Ͷ��Ǯ��С����Ʒ�۸�ʱ�˻���ͶǮ��

wire [7:0] dis_price ; //��ѡ��Ʒ�۸�ĸ�λ�͵�λBCD��
wire [7:0] dis_money; //Ͷ��Ǯ�ҽ��ĸ�λ�͵�λBCD��
wire [7:0] dis_returned ; //������ĸ�λ�͵�λBCD��

wire [3:0] scan_data_1;
wire [3:0] scan_data_0;

wire clk_1Hz; //1Hzʱ���ź�
wire clk_1kHz; //�����ɨ���׼ʱ�ӣ�Tclk=1ms
//module button(clk_1kHz,pbn,signal);
button button_rstn(clk_1kHz,rst_button,rstn);
button button_suren(clk_1kHz,sure_button,suren);

clkdiv myclkdiv(clk,clk_1kHz, clk_1Hz);

//module vendor_core(clk_1Hz,clk_1kHz,rstn,suren,goods,money,led_warn,led,led_half_out,price,sum,returned,dis_price,dis_money,dis_returned,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);
vendor_core vendor_for_top(clk_1Hz,clk_1kHz,rstn,suren,goods,money,led_warn,led,led_half_out,price,sum,returned,dis_price,dis_money,dis_returned,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);




endmodule

//module vendor_core(clk_1Hz,clk_1kHz,rstn,suren,goods,money,led_warn,led,led_half_out,price,sum,returned,dis_price,dis_money,dis_returned,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);

module vendor_sim(clk_1Hz,clk_1kHz,rst_button,sure_button,goods,money,led_warn,led,led_half_out,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);
input clk_1Hz; //1Hzʱ���ź�
input clk_1kHz; //�����ɨ���׼ʱ�ӣ�Tclk=1ms
input rst_button; //ϵͳ��λ�źţ������壩
input sure_button; //ȷ�Ϲ����źţ������壩
input [3:0] goods; //ĳ1λΪ"1"ʱѡ��ĳ����Ʒ������͵���߷ֱ��Ӧ�۸�Ϊ5�ǡ�1Ԫ��1.5Ԫ��2Ԫ����Ʒ
input [2:0] money; //ѡ��Ͷ���Ǯ����ֵ��001��5�ǣ�010��1Ԫ��100��5Ԫ������ͬʱͶ�������ֵǮ�ң�3��Ǯ�ҹ�8�����


output led_warn; //Ǯ����ʱ�澯ָʾ�ƣ�����Ч��
output [3:0] led; //LED��ʾ�����߹������Ʒ������Ч���������λ�����λ�ֱ��Ӧ�۸�Ϊ5�ǡ�1Ԫ��1.5Ԫ��2Ԫ����Ʒ
output led_half_out; //����ָʾ�ƣ�����Ч��

output [3:0] scan_en_1; //����ɨ���������1��λѡ���źţ�����Ч��
output [3:0] scan_en_0; //����ɨ���������0��λѡ���źţ�����Ч��
output [6:0] data_1_7seg; //�����������1��7�ε�ƽ�źţ�����Ч��������λ�����ɨ����ʾ��ѡ��Ʒ�۸�ĸ�λ�͵�λ
output [6:0] data_0_7seg; //�����������0��7�ε�ƽ�źţ�����Ч��������λɨ����ʾͶ��Ǯ�ҽ��ĸ�λ�͵�λ������λɨ����ʾ������ĸ�λ�͵�λ

wire rstn;
wire suren;


wire[4:0] price; //��ѡ��Ʒ�۸�Ϊ���ڹ۲���仯������Ϊ������ڴ�۸�
wire[6:0] sum; //Ͷ��Ǯ�ҵ��ܽ��,���ּƣ��ڴ�Ǯ��
wire[6:0]returned; //���������Ͷ��Ǯ��С����Ʒ�۸�ʱ�˻���ͶǮ��

wire [7:0] dis_price ; //��ѡ��Ʒ�۸�ĸ�λ�͵�λBCD��
wire [7:0] dis_money; //Ͷ��Ǯ�ҽ��ĸ�λ�͵�λBCD��
wire [7:0] dis_returned ; //������ĸ�λ�͵�λBCD��

wire [3:0] scan_data_1;
wire [3:0] scan_data_0;

//module button(clk_1kHz,pbn,signal);
button button_rstn(clk_1kHz,rst_button,rstn);
button button_suren(clk_1kHz,sure_button,suren);

//module vendor_core(clk_1Hz,clk_1kHz,rstn,suren,goods,money,led_warn,led,led_half_out,price,sum,returned,dis_price,dis_money,dis_returned,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);
vendor_core vendor_for_sim(clk_1Hz,clk_1kHz,rstn,suren,goods,money,led_warn,led,led_half_out,price,sum,returned,dis_price,dis_money,dis_returned,scan_en_1,scan_en_0,data_1_7seg,data_0_7seg);




endmodule
