//encoderģ������ͬ����ʵ�ִ���ת���Ĺ��ܣ�����ϵ����ͺ�type

module encoder(data_in,clk_8M,clrn,out,error,out_enable,word_type);
	input data_in;
	input clk_8M;
	input clrn;
	output [15:0] out;
	output [2:0]error;
	output out_enable;//���ʹ�ܣ�out��ֵ��Ч,�½��ش���
	output [1:0]word_type;
	/*
		�������ж�ָ���ֺ�״̬�ֲ�������Ϊ�����Ժ���չ��������λ������
		00	��Ч
		01	������
		10 ״̬�ֻ���ָ����
	*/
	
	/*
	000	������
	001	ͬ������
	010   ͬ����ɺ�������ĳһ��byte��������˹�ؽ���ʱ�����ַ�0xfff000����0x000fff����������˴�����룻
	011   ��żУ�����
	
	
	*/
	reg [2:0]error;
	reg [15:0] out;
	reg [3:0]count_zero;//��0����
	reg [3:0]test_zero;//��⵽12��1֮��Ķ�0����
	reg [3:0]zero_judge;//�����ж��յ�12��1֮��֮ǰ��12��0�Ǿ�Ĭ����ͬ��ͷ
	reg [3:0]count_one;//��1����
	reg [1:0]syn;//ͬ��,00ͬ��ǰ��01������ͬ��ͷ��10״̬��ͬ��ͷ
	reg [1:0]syn01_state;
	//reg [1:0]syn10_state;
	reg [4:0]word_count;//���ڼ������е�λ
	reg [16:0]word_store;//�洢17λ����
	reg [7:0]mid_byte;
	reg [2:0]mid_byte_count;
	//reg mid_byte_result;//����������
	reg complete;//����byte��λ��ȡ���
	reg byte_encode;//����˹�ؽ�����ɺ����ɵĽ���������ý��д��word_store,�������
	reg out_enable;
	reg [1:0]word_type;
	reg word_complete;
	//reg [4:0]out_enable_count;
	
	//syn01_state:
	parameter first1=2'b00;
	parameter first5=2'b01;
	parameter normal=2'b10;
	
	always @(posedge clk_8M,negedge clrn)
		begin
			if(!clrn)
				begin
					count_zero<=0;
					count_one<=0;
					syn<=0;
					test_zero<=0;
					zero_judge<=0;
					syn01_state<=0;
					word_count<=0;
					word_store<=0;
					mid_byte<=0;
					mid_byte_count<=0;
					complete<=0;
					out<=0;
					error<=0;
					byte_encode<=0;
					out_enable<=0;
					word_type<=2'b00;
					word_complete<=0;
					//out_enable_count<=0;
				end
			else if(syn==2'b00)//ͬ��ǰ����0��1Ϊ�����֣���1��0λָ���ֻ�״̬��
				begin
					if(!data_in)//data_in����Ϊ0
						begin
							if(count_one==0)
								begin//��Ĭ״̬��0���Լ�⵽��0ֻ�洢��������
									if(count_zero==11)//��12��0����ʱ��
										begin
											count_zero<=count_zero;
										end
									else 
										begin
											count_zero<=count_zero+1;
										end
								end
							else//count_one�Ѿ���⵽������Ϊ0
								begin
									if(count_one==12)//�Ѿ���⵽ͬ��ͷ����Ҫ�ж�������ͬ��ͷ
										begin
											if(count_zero!=11)
												begin
													if(test_zero==11)//ͬ��ͷ10��ȷ��
														begin
															syn<=2'b10;
															count_zero<=0;
															count_one<=0;
															test_zero<=0;
															zero_judge<=0;
														end
													else 
														begin
															test_zero<=test_zero+1;
														end
												end
											else//�Ѿ����ڶ�count_zero�ļ�������Ҫ�ж�,�ڴ�ֻ���ж�ͬ��ͷ10�����������һ�������Ҫ��data_in==1�������
												begin
													if(zero_judge==11)
														begin
															syn<=2'b10;
															count_zero<=0;
															count_one<=0;
															test_zero<=0;
															zero_judge<=0;
														end
													else
														begin
															zero_judge<=zero_judge+1;
														end
												end
										end
									else//δ̽�⵽ͬ��ͷ,�Լ�⵽��1 
										begin
											count_zero<=1;
											count_one<=0;
											test_zero<=0;
											zero_judge<=0;
										end
								end
						end
					else//data_in����Ϊ1
						begin
							if(zero_judge==4)
								begin
									syn<=2'b01;
									count_zero<=1;
									count_one<=0;
									test_zero<=0;
									zero_judge<=0;
									syn01_state<=first5;
								end
							else if(count_one==12)//����������13��1�������ж�
								begin
									if(count_zero==11)
										begin
											syn<=2'b01;
											count_zero<=0;
											count_one<=0;
											test_zero<=0;
											syn01_state<=first1;
										end
									else//ͬ������
										begin
											error<=3'b001;//001ͬ����������������13��1��ȴ��û�вɵ��㹻���0
										end
								end
							else 
								begin
									count_one<=count_one+1;
								end
						end
				end
			else if(syn==2'b01)
			//�����֣��������Σ�13��1�ж�ͬ��ͷ�������õ�һ��1��ֱ�Ӵӵ�2λ��ʼ����;00
			//�õ�4��0,1��1��01
			//֮�����������;10;
				begin
					/*if(word_count==16)
						begin
							complete<=1;
							syn<=0;
							word_count<=0;
						end
					else
						begin
							word_count<=word_count+1;
						end*/
					word_type<=2'b01;
					case(syn01_state)
					first1:
						begin
							if(mid_byte_count==6)
								begin
									mid_byte<=8'b0000_0001|mid_byte;
									syn01_state<=normal;
									mid_byte_count<=0;
									complete<=1;
								end
							else 
								begin
									mid_byte[mid_byte_count+1]<=data_in;
									mid_byte_count<=mid_byte_count+1;
								end
						end
					first5:
						begin
							if(mid_byte_count==2)
								begin
									mid_byte<=8'b1111_0000|mid_byte;
									syn01_state<=normal;
									mid_byte_count<=0;
									complete<=1;
								end
							else 
								begin
									mid_byte[mid_byte_count+5]<=data_in;
									mid_byte_count<=mid_byte_count+1;
								end
						end
					normal:
						begin
							if(mid_byte_count==7)
								begin
									mid_byte[7]<=data_in;
									syn01_state<=normal;
									mid_byte_count<=0;
									complete<=1;
								end
							else 
								begin
									mid_byte[mid_byte_count]<=data_in;
									mid_byte_count<=mid_byte_count+1;
								end
						end
					endcase
				end
			else if(syn==2'b10)
				begin	
					word_type<=2'b10;
					if(mid_byte_count==7)
						begin
							mid_byte[7]<=data_in;
							//syn01_state<=normal;
							mid_byte_count<=0;
							complete<=1;
						end
					else 
						begin
							mid_byte[mid_byte_count]<=data_in;
							mid_byte_count<=mid_byte_count+1;
						end
					
				end
		end
	
	always@(posedge complete)
		//if(complete)
		begin
			if(word_count==16)
				begin
					syn<=0;
					word_count<=0;
					mid_byte<=0;
					if(mid_byte==8'b00001111)
						begin
							word_store[16-word_count]<=1;
							byte_encode<=1;
						end
					else if(mid_byte==8'b11110000)
						begin
							word_store[16-word_count]<=0;
							byte_encode<=0;
						end
					else 
						begin
							error<=3'b010;
						end
					out<=word_store[16:1];
					//out_enable<=1;//ʹ�����
					word_complete<=1;
				end
			else
				begin
					word_count<=word_count+1;
					//complete<=0;
					if(mid_byte==8'b00001111)
						begin
							word_store[16-word_count]<=1;
							byte_encode<=1;
						end
					else if(mid_byte==8'b11110000)
						begin
							word_store[16-word_count]<=0;
							byte_encode<=0;
						end
					else 
						begin
							error<=3'b010;//����ͬ����Ķ�ȡ�������д���
						end
				end
		end
	
	always @(negedge clk_8M)
			begin
				complete<=0;
				word_complete<=0;
				/*if(out_enable)
					begin
						if(out_enable_count==31)
					end*/
				out_enable<=0;
				error<=0;
					
			end
			
	always @(posedge word_complete)//������ɣ���żУ��ɹ���ʹ��out_enable��������żУ���
		begin
			if(~^word_store[16:1]==word_store[0])//����
				begin
					out_enable<=1;
				end
			else
				begin
					error<=3'b011;
					out_enable<=1;//Ϊ�˽������������ϴ���������Ȼ��out_enabl��λ
				end
		end
		
	
endmodule

module  message_writer(word_in,word_type,enable,clrn,error_in,message_complete,message_type,error_out);//ʶ�����߻
	input [15:0] word_in;
	input [1:0] word_type;
	input enable;
	input clrn;
	input [2:0]error_in;
	
	output message_complete;
	output [3:0]message_type;
	/*
		0000	��Ĭ״̬
		0001  ��������Զ���ն�
		0010	Զ���ն��������
		0011  Զ���ն���Զ���ն�
		0100  ���������ֵķ�ʽָ��
		0101	�������ֵķ�ʽָ����ͣ�
		0110	�������ֵķ�ʽָ����գ�
		0111	�㲥����������Զ���ն˵Ĵ���
		1000	�㲥��Զ���ն���Զ���ն˵Ĵ���
		1001	�㲥�����������ֵķ�ʽָ��
		1010	�㲥���������ֵķ�ʽָ��
		1011  δ֪״̬
	*/
	output[2:0]error_out;
	
	reg [1:0]command_count;
	reg [4:0]rt_add;//Զ���ն˵�ַ
	reg [4:0]mode;//�����ּ���/��ʽ����
	reg [4:0]sub_system;//��ϵͳ�š���ʽ�����־
	
	always @(posedge enable, negedge clrn)
	if(!clrn)
		begin
			message_complete<=0;
			message_type<=0;
			command_count<=0;
		end
	else if(error_in!=0)
		begin
			error_out<=error_in;
			rt_add<=word_in[15:11];//Զ���ն˱��
			sub_system<=word_in[9:5];//��ϵͳ��Ż����Ƿ�Ϊ��ʽָ��
			mode<=word_in[4:0];//��ʽ������������ּ���
		end
	else //������ʹ���ʱ��ָ���ֻ�״̬�֣�������
		begin
			case(word_type)
			2'b10://ָ���ֻ���״̬��
				begin
					if(command_count==0)//�б�Ϊָ���֣���©��
						begin
							if(word_in[15:11]==5'b00000)//������ȫ0�ֶΣ���ȫ0������Ϊδ֪
								begin
									word_type<=4'b1011;
								end
							else if(word_in[15:11]==5'b11111)//�㲥���������
								begin
								
								end
							else //�ǹ㲥���������
								begin
									if(sub_system==5'b00000||sub_system==5'b11111)//��ʽָ����������
										begin
											
										end
									else//����ͨ�ŵ��������
										begin
											if(word_in[10]==0)//Զ���ն˽���
												begin
													
												end
											else//Զ���ն˷���
												begin
													word_type<=4'b0010;
												end
										end
								end
						end
					else//״̬��
						begin
						
						end
				end
			2'b01://������
				begin
					
				end
			default:
				begin
					message_type<=0;
				end
			endcase
		end
	
endmodule

//�����ļ�
module bm_sim(data_in,clk_8M,clrn,message_type);
	input data_in;
	input clk_8M;
	input clrn;

	output[3:0] message_type;
	/*
		0000	��Ĭ״̬
		0001  ��������Զ���ն�
		0010	Զ���ն��������
		0011  Զ���ն���Զ���ն�
		0100  ���������ֵķ�ʽָ��
		0101	�������ֵķ�ʽָ����ͣ�
		0110	�������ֵķ�ʽָ����գ�
		0111	�㲥����������Զ���ն˵Ĵ���
		1000	�㲥��Զ���ն���Զ���ն˵Ĵ���
		1001	�㲥�����������ֵķ�ʽָ��
		1010	�㲥���������ֵķ�ʽָ��
	*/
	

endmodule 

