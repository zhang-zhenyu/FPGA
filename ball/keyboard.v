`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:35:20 05/14/2017 
// Design Name: 
// Module Name:    keyboard 
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
module keyboard(clk_50MHz,reset,kb_clk,kb_data,upl,downl);
input clk_50MHz;		//ϵͳʱ�ӣ�750kHz
input reset;	//ϵͳ��λ�źţ�����Ч
input kb_clk;	//���ʱ���ߣ�˫���źţ���ʵ��ٶ�Ϊ20kHz
input kb_data;	//��������ߣ�˫���ź�
output upl;	
output downl;
//output reg valid; //Ϊ���ڷ��棬����Ϊ���
//output reg[10:0] senddata; //��λ�Ĵ������ݴ�����Ҫ���͵�ʹ�����Ϊ���ڷ��棬����Ϊ���

//�м����
reg kb_clk_filtered;//���˺�ļ���ʱ���źţ������½���ʱ��ȡ��������
reg [7:0] filter; //���˱�����������������8 ��ʱ���ź�
reg clk_25MHz; //��50MHz ����Ƶ�õ���25MHz ʱ���ź�
reg read_char; //��ȡ���ݱ�־λ��Ϊ"1"ʱ��ʾ���ڶ�ȡ����֡
reg ready_set; //��ȡ������ɱ�־λ����ȡ8 λ�������ʱ��"1"
reg got_f0; //Ϊ"1"ʱ��ʾ�Ѷ���f0H���������룩
reg [3:0] in_cnt; //���ѽ��ռ������ݵ�λ��������8 ������λ��1 λУ��λ��
reg [8:0] shift_in; //��λ�Ĵ�����������ʱ�洢��ȡ��һ֡9 λ����
reg [7:0] scan_code;//�洢8 λɨ����
reg got_f0_ttl;

// �� �����¡�A����S����ʱ������upl ��downl �ź�
assign upl=((scan_code==8'h1C)&&(got_f0 == 1'b0))?1:0; //������A ��ʱ
assign downl=((scan_code==8'h1B)&&(got_f0 == 1'b0))?1:0; //������S ��ʱ

// �� ����Ƶ���õ�Ƶ��Ϊ25MHz ��ʱ���ź�clk_25MHz
always @ (posedge clk_50MHz,negedge reset)
	begin
		if(!reset)
			begin
				clk_25MHz<=0;
			end
		else 
			begin
				clk_25MHz<=~clk_25MHz;
			end
	end
	
// �� Ϊ�����źŸ��ţ����˴Ӽ��̴��������ԭʼʱ���ź�
always @ (posedge clk_25MHz)
	begin
		filter<={kb_clk,filter[7:1]};
		if(filter==8'b11111111)
			begin
				kb_clk_filtered<=1'b1;
			end
		else if(filter==8'b00000000)
			begin
				kb_clk_filtered<=1'b0;
			end
	end //����kb_clk_filtered

// �� �ڹ��˺�ļ���ʱ�ӵ��½����������ռ������ݣ��ؼ�����
always @ (negedge kb_clk_filtered or negedge reset)
	begin
		if (!reset) //ϵͳ��λʱ�������
			begin
				read_char<=0;// read_char��ready_set��got_f0 ��in_cnt��scan_code ����
				ready_set<=0;
				got_f0<=0;
				in_cnt<=0;
				scan_code<=0;
				got_f0_ttl<=0;
			end
		else //��λ���
			begin
				if ((kb_data == 1'b 0) && (read_char == 1'b 0))//0 Ϊ��ʼλ����ʼ��ȡ����
					begin
						read_char<=1;
						ready_set<=0;
					end // read_char ��1��ready_set ��0
				else
					begin
						if (read_char == 1'b 1) //���ѿ�ʼ��ȡ����֡
							begin
								if (in_cnt < 4'd9) //���ѽ������ݵ�λ��С��9
									begin //�����8 ������λ��У��λ
										shift_in[8:0] <= {kb_data,shift_in[8:1]};
										in_cnt <= in_cnt + 1'b 1;
									end
								else //���Ѷ�ȡ��һ֡
									begin
										if (shift_in[7:0] == 8'hf0) 
											begin
												got_f0 <= 1'b1;
												got_f0_ttl<=1;
											end
										else if(got_f0_ttl==1)
											begin
												got_f0_ttl<=got_f0_ttl-1;
											end
										else 
											begin
												got_f0 <= 1'b0;
											end
										scan_code<=shift_in[7:0];//����ȡ��8 λ���������ɨ����
										in_cnt<=0;// read_char ���㣬ready_set ��"1"��in_cnt ����
										read_char<=0;
										ready_set<=1;
									end
							end
					end
			end
	end
endmodule
