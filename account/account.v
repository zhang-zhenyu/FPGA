`timescale 1ns / 1ps

//������ģ��
module account(clk_1kHz,clk_4Hz,card,on,category, set_money_high,set_money_mid,set_money_low,clrn,disptime,dispmoney,read, write,warn,cut, speaker);
	input clk_1kHz,clk_4Hz;//���Է�Ƶ��ģ���ʱ���źţ�Ƶ�ʷֱ�Ϊ1kHz��4Hz
	input card; //�������źţ���������ʱ��Ϊ�ߵ�ƽ�����γ���Ϊ�͵�ƽ
	input on; //��ͨ�źţ��ӵ绰�ַ����������źţ��ߵ�ƽʱ��ʾ��·�ѽ�ͨ���͵�ƽʱ��ʾ��·δ��ͨ
	input [1:0] category; //�������࣬�ӵ绰�ַ����������źţ�"01"��ʾ�л���"10"��ʾ������"11"��ʾ�ػ�
	input set_money_high; //����Ч�����ÿ��н��İ�λ����λΪ�ǣ�ÿ��һ�¼�1
	input set_money_mid; //����Ч�����ÿ��н���ʮλ����λΪ�ǣ�ÿ��һ�¼�1
	input set_money_low; //����Ч�����ÿ��н��ĸ�λ����λΪ�ǣ�ÿ��һ�¼�1
	input clrn; //�����źţ�����Ч��
	output reg [7:0] disptime; //��ʾ����ͨ����ʱ������4λ�͵�4λ�ֱ�ΪBCD�����������λΪ���ӣ������������ʾ�����ʱ��Ϊ59����
	output [11:0] dispmoney;//��ʾ��������4λ���м�4λ�͵�4λ�ֱ�ΪBCD�����������λΪ�ǣ������������ʾ���������Ϊ99.9Ԫ
	output read; //�����źţ����绰������ʱ��ߣ���ʱ����
	output reg write; //д���źţ����������ص���ʱд��
	output reg warn; //����������ʱ�����ĸ澯�źţ�����Ч���澯15s���Ϊ�͵�ƽ
	output reg cut; //�Զ��жϵ�ǰͨ���źš�ƽʱΪ�ͣ����澯ʱ��ﵽ15sʱcut���
	output speaker; //�澯�ź���������������
	
	integer cnt1; //��ͨ��ʱ�����
	reg min_clk; //��ʱ�ӣ�Ϊ�����źţ���д����ʱ��
	wire [11:0] money; //���ڼƷѣ�����������min_clkΪʱ���źţ���4λ���м�4λ�͵�4λ�ֱ����BCD�������
	//wire [11:0] money;
	reg[9:0] realmoney;//money���ڴ�ֵ
	integer cnt_warning; //���ڼƸ澯ʱ��
	reg flag; //���澯��15��ʱ��flagΪ1���Ա�ʹwarn����
	
	//��assign���ֵĵط���������Ҫ���ұ�����Ϊwire��
	assign dispmoney =card?money:0; //ֻҪ�绰��һ���룬����ʾ�������
	assign read = card?1:0; //ֻҪ�绰��һ���룬����������źţ��ߵ�ƽ��
	assign speaker=warn&clk_1kHz; //�澯�ź���������������
	
	assign money[3:0]=realmoney%10;
	assign money[7:4]=(realmoney%100)/10;
	assign money[11:8]=realmoney/100;
	
	
	//1������ͨ����ʱ��ͨ���ƷѵĻ�׼ʱ���ź�min_clk
	always @(posedge clk_4Hz)
		begin
			if(card && on) //�����Ѳ����ҵ绰�ֽ�ͨ��·
				begin
					if(cnt1==59)//��cnt1��ʼ��1���������Ƶ�59s����cnt1���㣬����min_clk
						begin
							cnt1<=0;
							min_clk<=1;
						end
					else 
						begin
							cnt1<=cnt1+1;
							min_clk<=0;
						end
				end
			else 
				begin
					cnt1<=0;
					min_clk<=0;
				end
		end
		
	//2����ͨ����ʱ
	always @(negedge clk_4Hz or negedge clrn)
		begin
			if (!clrn) 
				begin
					disptime<=8'd0;
					//cnt1<=0;
				end
			else if(card && on) //�����Ѳ����ҵ绰�ֽ�ͨ��·
				begin
					if(min_clk) //��ͨ��ʱ�乻1���ӣ���disptime��ʼ��1������ע��Ϊbcd������
						begin
							if(disptime[3:0]==9)
								begin
									disptime[3:0]<=0;
									disptime[7:4]<=disptime[7:4]+1;
								end
							else
								begin
									disptime[3:0]<=disptime[3:0]+1;
								end
						end
					else 
						disptime<=disptime;//һ��Ҫ�д˾䣬������min_clk��Ϊ0�����һ��ʱ������disptimeҲ��Ϊ0
				end
			else
				disptime<=0;
		end
		
	// 3��������ÿ��ڵĽ���ֵ��ͨ���Ʒ�
	always @(negedge clk_4Hz or negedge clrn)
		begin
			if (!clrn)//����������
				begin
					realmoney<=0;
					flag<=0;
					write<=0;
					cut<=0;
					warn<=0;
				end
			//a.���ÿ��ڵĽ���ֵ
			/*
			else if (!set_money_low) 
				begin
					if (money[3:0]==9)
						money[3:0]<=4'h0;
					else 
						money[3:0]<=money[3:0]+4'h1;
				end
			//����Ԫλ��ʮԪλ
			else if(!set_money_mid)
				begin
					if(money[7:4]==9)
						money[7:4]<=4'h0;
					else 
						money[7:4]<=money[7:4]+4'h1;
				end
			else if(!set_money_high)
				begin
					if(money[11:8]==9)
						money[11:8]<=4'h0;
					else 
						money[11:8]<=money[11:8]+4'h1;
				end
			*/
			
			else //���ÿ��ڳ�ֵ
			if(!set_money_low)
				begin
					realmoney<=realmoney+1;
				end
			else if(!set_money_mid)
				begin
					realmoney<=realmoney+10;
				end
			else if(!set_money_high)
				begin
					realmoney<=realmoney+100;
				end
			else
			//b.ͨ���Ʒ�
			if(card && on) //�����Ѳ�������·�ѽ�ͨ
				begin
					if(min_clk) //��ͨ��ʱ�乻1����
						case (category)
							2'b01: //��1��������Ϊ�л�
								begin
									if(realmoney<12'd3) //�� ���������<3�ǣ���澯
										begin
											warn<=1;
											write<=0;
										end
									else //�� ���������>3�ǣ�����л��Ʒ�
										begin
											realmoney<=realmoney-3;
											write<=1; 
											warn<=0; //�� ׼��д����warn��0
										end
								end
							2'b10: //��2��������Ϊ����
								begin
									if(realmoney<12'd6) //�� ���������<6�ǣ���澯
										begin
											warn<=1;
											write<=0;
										end
									else //�� ���������>6�ǣ�����л��Ʒ�
										begin
											realmoney<=realmoney-6;
											write<=1; 
											warn<=0; //�� ׼��д����warn��0
										end
								end
							2'b11:
								begin
									realmoney<=realmoney;
									warn<=0;
								end
							default:
								begin
									realmoney<=realmoney;
									warn<=0;
								end
						endcase
					else //��min_clk=0
						begin
							write<=0; //��д��
							if(flag) 
								warn<=0; //���澯ʱ��ﵽ15s, ��warn��Ϊ�͵�ƽ
							if(warn) //���и澯�ź�
								begin
									if(cnt_warning==15)
										begin 
											cut<=1;
											flag<=1;
											cnt_warning<=0;
										end //���Ƶ�15s�����Զ��ж�ͨ����flag��1
									else
										begin
											cnt_warning<=cnt_warning+1;
											flag<=0;
										end//��δ��15s����cnt_warning��1����, flag��0
								end
							else //ûwarning
								begin 
									cnt_warning<=0; 
									cut<=0; 
									flag<=0;
								end
						end
				end
			else //�����Ѱγ�����·δ��ͨ�����һЩ�źŽ��и�λ
				begin 
					write<=0; 
					warn<=0;
					cnt_warning<=0;
					cut<=0; 
					flag<=0;
				end
		end
		
endmodule


//��Ƶ��������50M��ʱ�ӣ����1K��4Hz
module clkdiv(clkin, clrn, clk_1kHz, clk_4Hz);
input clkin;
input clrn;
output reg clk_1kHz;
output reg clk_4Hz;

parameter count_width= 50000;

reg[14:0] count1;
reg[7:0] count2;

always @(posedge clkin, negedge clrn) //5000��Ƶ
	begin
		if(!clrn)
			begin
				count1<=0;
				clk_1kHz<=0;
			end
		else 
			begin
				if(count1==count_width/2-1)
				begin
					clk_1kHz<=~clk_1kHz;
					count1<=0;
				end
				else
				begin
					count1<=count1+1;
					//clk_10kHz<=~clk_10kHz;
				end
			end
	end

always @(posedge clk_1kHz, negedge clrn)
	begin
		if(!clrn)
			begin
				count2<=0;
				clk_4Hz<=0;
			end
		else if(count2==124)
		begin
			clk_4Hz<=~clk_4Hz;
			count2<=0;
		end
		else
			begin
			count2<=count2+1; 
			//clk_1kHz=~clk_1kHz;
			end
	end
endmodule


//scanģ��,1kHz���룬
module scan(clk, clrn,datain,scan_data,scan_en);
input clk; //1kHzʱ���ź�
input clrn;
input[11:0] datain; //����
output reg[3:0] scan_data; //�����������0������ɨ����ʾ��BCD���ź�
output reg[2:0] scan_en; //����ɨ���������0��λѡ���źţ�����Ч��

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
				if(state==2) 
					state<=0; //״̬����״̬ת��
				else 
					state<=state+1'b1;
				case(state) //��������ܵ������źź�λѡ���ź�
					0://���λ�����������ʾ���λ
						begin
							scan_data<=datain[11:8];
							scan_en<=3'b100;
						end 
					1:
						begin
							scan_data<=datain[7:4];
							scan_en<=3'b010;
						end
					2:
						begin
							scan_data<=datain[3:0];
							scan_en<=4'b001;
						end
					/*3:
						begin
							scan_data<=secm[3:0];
							scan_en<=4'b0001;
						end
					*/
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



module account_for_sim(clk_1kHz,clk_4Hz,card,on,category,set_money_high,set_money_mid, set_money_low, clrn, read_out,write_out, warn_out, cut_out, speaker_out, scan_en_1,disptime_7seg, scan_en_0,dispmoney_7seg);

input clk_1kHz,clk_4Hz; //���Է�Ƶ��ģ���ʱ���źţ�Ƶ�ʷֱ�Ϊ1kHz��4Hz
input card; //�������źţ���������ʱ��Ϊ�ߵ�ƽ�����γ���Ϊ�͵�ƽ
input on; //��ͨ�źţ��ӵ绰�ַ����������źţ��ߵ�ƽʱ��ʾ��·�ѽ�ͨ���͵�ƽʱ��ʾ��·δ��ͨ
input [1:0] category; //�������࣬�ӵ绰�ַ����������źţ�"01"��ʾ�л���"10"��ʾ������"11"��ʾ�ػ�
input set_money_high; //����Ч�����ÿ��н��İ�λ����λΪ�ǣ�ÿ��һ�¼�1
input set_money_mid; //����Ч�����ÿ��н���ʮλ����λΪ�ǣ�ÿ��һ�¼�1
input set_money_low; //����Ч�����ÿ��н��ĸ�λ����λΪ�ǣ�ÿ��һ�¼�1
input clrn; //�����źţ�����Ч��
output read_out; //�����źţ�����Ч
output write_out; //д���źţ�����Ч
output warn_out; //����������ʱ�����ĸ澯�źš������л�ʱ���������3�ǣ��򳤻�ʱ���������6�ǣ���������澯�źš�����Ч���澯15s���Ϊ�ߵ�ƽ
output cut_out; //�Զ��жϵ�ǰͨ���źţ����澯ʱ��ﵽ15sʱcut���
output speaker_out; //�澯�ź���������������������Ч
output [2:0] scan_en_1; //����ɨ���������1��λѡ���źţ������λ�����λ�ֱ�ѡ���������Ĵ������ҵ�2������3���͵�4���������
output[6:0] disptime_7seg; //disptime��4λɨ�����ݾ���7������������������������1
output [2:0] scan_en_0; //����ɨ���������0��λѡ���źţ������λ�����λ�ֱ�ѡ���������Ĵ������ҵ�2������3���͵�4���������
output[6:0] dispmoney_7seg; //dispmoney��4λɨ�����ݾ���7������������������������0

wire[7:0] disptime; //��ʾ����ͨ����ʱ����Ҫ���棩����λΪ���ӣ������������ʾ�����ʱ��Ϊ59����
wire[11:0] dispmoney; //��ʾ������Ҫ���棩����λΪ�ǣ������������ʾ���������Ϊ99.9Ԫ
wire[11:0] data_in_1; //��disptime[7:0]����Ϊ12λ����Ϊscan.v��data_inΪ12λ��
wire[3:0] scan_data_1; //�����������1������ɨ����ʾ��BCD���źţ�Ҫ���棩�������λ�����ɨ����ʾͨ��ʱ��ĸ�λ�͵�λ
wire[3:0] scan_data_0; //�����������0������ɨ����ʾ��BCD���źţ�Ҫ���棩������λ�����ɨ����ʾ��������ʮԪλ��Ԫλ�ͽ�λ
wire read; //�����źţ����绰������ʱ��ߣ���ʱ����
wire write; //д���źţ����������ص���ʱд��
wire warn; //����������ʱ�����ĸ澯�ź�
wire cut; //�Զ��жϵ�ǰͨ���źţ����澯ʱ��ﵽ15sʱcut���
wire speaker; //�澯�ź���������������

//��1�����ú�����ģ��
//module account(clk_1kHz,clk_4Hz,card,on,category, set_money_high,set_money_mid,set_money_low,clrn,disptime,dispmoney,read, write,warn,cut, speaker);
account my_account(clk_1kHz,clk_4Hz,card,on,category, set_money_high,set_money_mid,set_money_low,clrn, disptime, dispmoney ,read, write, warn, cut, speaker);
//��2�����������ɨ����ʾ��ģ��
assign data_in_1 = {4'b0000,disptime}; //��disptime[7:0]����Ϊ12λ

//module scan(clk, clrn,datain,scan_data,scan_en);

scan my_scan1(clk_1kHz, clrn, data_in_1, scan_data_1, scan_en_1); //ɨ����ʾͨ��ʱ��
scan my_scan2(clk_1kHz, clrn, dispmoney, scan_data_0, scan_en_0); //ɨ����ʾ�������


//��3�������߶�������ģ��
//module p7seg(data,out);

p7seg my_p7seg1(scan_data_1,disptime_7seg); //��ͨ��ʱ���߶�����
p7seg my_p7seg2(scan_data_0,dispmoney_7seg); //�Կ�������߶�����

//��4��������LED������ź�read��write��warn��cut��speaker�����࣬ʹ���Ϊ����Ч
assign read_out=!read;
assign write_out=!write;
assign warn_out=!warn;
assign cut_out=!cut;
assign speaker_out=speaker;

//��������

endmodule 


module account_top(clk,card,on,category,set_money_high,set_money_mid, set_money_low, clrn, read_out,write_out, warn_out, cut_out, speaker_out, scan_en_1,disptime_7seg, scan_en_0,dispmoney_7seg);

input clk;
input card; //�������źţ���������ʱ��Ϊ�ߵ�ƽ�����γ���Ϊ�͵�ƽ
input on; //��ͨ�źţ��ӵ绰�ַ����������źţ��ߵ�ƽʱ��ʾ��·�ѽ�ͨ���͵�ƽʱ��ʾ��·δ��ͨ
input [1:0] category; //�������࣬�ӵ绰�ַ����������źţ�"01"��ʾ�л���"10"��ʾ������"11"��ʾ�ػ�
input set_money_high; //����Ч�����ÿ��н��İ�λ����λΪ�ǣ�ÿ��һ�¼�1
input set_money_mid; //����Ч�����ÿ��н���ʮλ����λΪ�ǣ�ÿ��һ�¼�1
input set_money_low; //����Ч�����ÿ��н��ĸ�λ����λΪ�ǣ�ÿ��һ�¼�1
input clrn; //�����źţ�����Ч��
output read_out; //�����źţ�����Ч
output write_out; //д���źţ�����Ч
output warn_out; //����������ʱ�����ĸ澯�źš������л�ʱ���������3�ǣ��򳤻�ʱ���������6�ǣ���������澯�źš�����Ч���澯15s���Ϊ�ߵ�ƽ
output cut_out; //�Զ��жϵ�ǰͨ���źţ����澯ʱ��ﵽ15sʱcut���
output speaker_out; //�澯�ź���������������������Ч
output [2:0] scan_en_1; //����ɨ���������1��λѡ���źţ������λ�����λ�ֱ�ѡ���������Ĵ������ҵ�2������3���͵�4���������
output[6:0] disptime_7seg; //disptime��4λɨ�����ݾ���7������������������������1
output [2:0] scan_en_0; //����ɨ���������0��λѡ���źţ������λ�����λ�ֱ�ѡ���������Ĵ������ҵ�2������3���͵�4���������
output[6:0] dispmoney_7seg; //dispmoney��4λɨ�����ݾ���7������������������������0

wire clk_1kHz,clk_4Hz; //���Է�Ƶ��ģ���ʱ���źţ�Ƶ�ʷֱ�Ϊ1kHz��4Hz
wire[7:0] disptime; //��ʾ����ͨ����ʱ����Ҫ���棩����λΪ���ӣ������������ʾ�����ʱ��Ϊ59����
wire[11:0] dispmoney; //��ʾ������Ҫ���棩����λΪ�ǣ������������ʾ���������Ϊ99.9Ԫ
wire[11:0] data_in_1; //��disptime[7:0]����Ϊ12λ����Ϊscan.v��data_inΪ12λ��
wire[3:0] scan_data_1; //�����������1������ɨ����ʾ��BCD���źţ�Ҫ���棩�������λ�����ɨ����ʾͨ��ʱ��ĸ�λ�͵�λ
wire[3:0] scan_data_0; //�����������0������ɨ����ʾ��BCD���źţ�Ҫ���棩������λ�����ɨ����ʾ��������ʮԪλ��Ԫλ�ͽ�λ
wire read; //�����źţ����绰������ʱ��ߣ���ʱ����
wire write; //д���źţ����������ص���ʱд��
wire warn; //����������ʱ�����ĸ澯�ź�
wire cut; //�Զ��жϵ�ǰͨ���źţ����澯ʱ��ﵽ15sʱcut���
wire speaker; //�澯�ź���������������

//module clkdiv(clkin, clrn, clk_1kHz, clk_4Hz);
clkdiv my_clkdiv(clk,clrn,clk_1kHz,clk_4Hz);

//��1�����ú�����ģ��
//module account(clk_1kHz,clk_4Hz,card,on,category, set_money_high,set_money_mid,set_money_low,clrn,disptime,dispmoney,read, write,warn,cut, speaker);
account my_account(clk_1kHz,clk_4Hz,card,on,category, set_money_high,set_money_mid,set_money_low,clrn,disptime,dispmoney,read, write,warn,cut, speaker);
//��2�����������ɨ����ʾ��ģ��
assign data_in_1 = {4'b0000,disptime}; //��disptime[7:0]����Ϊ12λ

//module scan(clk, clrn,datain,scan_data,scan_en);

scan my_scan1(clk_1kHz, clrn, data_in_1, scan_data_1, scan_en_1); //ɨ����ʾͨ��ʱ��
scan my_scan2(clk_1kHz, clrn, dispmoney, scan_data_0, scan_en_0); //ɨ����ʾ�������


//��3�������߶�������ģ��
//module p7seg(data,out);

p7seg my_p7seg1(scan_data_1,disptime_7seg); //��ͨ��ʱ���߶�����
p7seg my_p7seg2(scan_data_0,dispmoney_7seg); //�Կ�������߶�����

//��4��������LED������ź�read��write��warn��cut��speaker�����࣬ʹ���Ϊ����Ч
assign read_out=!read;
assign write_out=!write;
assign warn_out=!warn;
assign cut_out=!cut;
assign speaker_out=speaker;

//��������

endmodule 




