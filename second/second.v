`timescale 1ns / 1ps

module second(clk, startstopn, clrn,data_out,scan_en,cn);

input clk; //ϵͳʱ���źţ�f=50MHz��
input startstopn; //��/ͣ�źţ������壩
input clrn; //��λ�źţ������壩
output [6:0] data_out; //�����������0��7�ε�ƽ�źţ�����Ч����data_out[6:0]
output [3:0] scan_en; //����ɨ���������0��λѡ���źţ�����Ч�����Ӹߵ��ͷֱ�ѡ������������ұߵ������
output cn;//����ӵĽ�λ�ź�

wire clk_10kHz; //10kHzʱ���źţ�Ҫ���棩
wire clk_1kHz; //1kHzʱ���źţ�Ҫ���棩
wire startstopn_out; //��������������İ�������ź�
wire TFF_clk; //�Ծ�������������İ�������ź�startstopn_out���࣬ʹ���Ϊ������
wire [6:0] cnt_debounce; //�԰���������ʱ�ļ�����

reg enable; //T'FF������źţ���startstopn_out�źŷ�ת��Ϊ1ʱ���������Ϊ0ʱ��ͣ����

//�����м����Ҫ����
wire clko; //��Ƶ��·��ģ��clkdiv100.v�����ʱ���źţ�T=0.01s
wire [3:0] dsec; //���λBCD�������
wire [3:0] sec; //���λBCD�������
wire [3:0] secd; //�ٷ����λBCD�������
wire [3:0] secm; //�ٷ����λBCD�������
wire[3:0] scan_data; //�����������0������ɨ����ʾ��BCD���ź�


assign TFF_clk = ~startstopn_out; //�м�ڵ㣬��startstopn_out���࣬ʹ�½�����Ч��Ϊ��������Ч��TFF_clk��ΪT'FF��ʱ���ź�

always @(posedge TFF_clk or negedge clrn)
	begin
		if(!clrn) 
			enable<=0; //clrnΪ�첽�����źţ�����Ч
		else 
			enable<=~enable; //��һ��startstopn��enable��תһ�Σ��൱��T'FF
	end
	
	
//��2�����÷�Ƶ����button��bcdcnt��scan��p7seg��ģ��
//module clkdiv(clkin, clrn, clk_10kHz, clk_1kHz);
clkdiv my_clkdiv(clk,clrn,clk_10kHz,clk_1kHz);

//module clkdiv100(clkin, en, clrn, clkout);
//��Ƶ��2������ 10k�����100Hz, enΪ1������������enΪ0ʱ��ͣ����
clkdiv100 my_clkdiv100(clk_10kHz,enable,clrn,clko);

//module button(clk_1kHz,pbn,signal);
button my_button(clk_1kHz,startstopn,startstopn_out);

//module bcdcnt(clkin,clrn, dsec,sec,secd,secm,cn);
bcdcnt my_bcdcnt(clko,clrn,dsec,sec,secd,secm,cn);

//1kHz���룬
//module scan(clk, clrn,dsec,sec,secd,secm ,scan_data,scan_en);
scan my_scan(clk_1kHz,clrn,dsec,sec,secd,secm,scan_data,scan_en);

//module p7seg(data,out);
p7seg my_p7seg(scan_data,data_out);


//����


endmodule


//��Ƶ��1������50M��ʱ�ӣ����10K��1K
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

//��Ƶ��2������ 10k�����100Hz, enΪ1������������enΪ0ʱ��ͣ����
module clkdiv100(clkin, en, clrn, clkout);
input clkin;
input en;
input clrn;
output reg clkout;
reg[6:0] count;

always @(posedge clkin, negedge clrn,negedge en)
	begin
		if(!clrn)
			begin
				count<=0;
				clkout<=0;
			end
		else if(en==0)
			begin
				count<=count;
			end
		else if(count==49)
			begin
				clkout<=~clkout;
				count<=0;
			end
		else
			begin
				count<=count+1;
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

//BCD������������� 100Hzʱ��
module bcdcnt(clkin,clrn, dsec,sec,secd,secm,cn);
input clkin,clrn;
output reg[3:0] dsec,sec,secd,secm;
output reg cn;

always @(posedge clkin or negedge clrn)
	begin	
		if (!clrn) // 1���첽����
			begin
				cn<=0;//��λ�źź͸�����������
				dsec<=0;
				sec<=0;
				secd<=0;
				secm<=0;
			end
		else //2������������4��if����Ƕ��
			begin
				if(secm[3:0]==9) //�ٷ����λ�Ƿ�Ϊ9��
					begin
						secm[3:0]<=0;
						if(secd[3:0]==9) //�ٷ����λ�Ƿ�Ϊ9��
							begin
								secd[3:0]<=0;
								if(sec==9)
									begin
										sec<=0;
										if(dsec==5)
											begin
												cn<=1;
												dsec<=0;
												sec<=0;
												secd<=0;
												secm<=0;			
											end
										else
											begin
												dsec<=dsec+1;
											end
									end
								else
									begin
										sec<=sec+1;
									end
							end
						else
							begin
								secd<=secd+1;
							end
					end
				else
					begin
						secm<=secm+1;
					end
			end			
	end
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





 
