//encoder模块用于同步，实现串并转换的功能，输出紫的类型和type

module encoder(data_in,clk_8M,clrn,out,error,out_enable,word_type);
	input data_in;
	input clk_8M;
	input clrn;
	output [15:0] out;
	output [2:0]error;
	output out_enable;//输出使能，out的值有效,下降沿触发
	output [1:0]word_type;
	/*
		译码器中对指令字和状态字不做区别：为方便以后拓展，设置两位来区分
		00	无效
		01	数据字
		10 状态字或者指令字
	*/
	
	/*
	000	正常；
	001	同步错误；
	010   同步完成后，若对于某一个byte进行曼彻斯特解码时，出现非0xfff000或者0x000fff的情况，报此错误代码；
	011   奇偶校验出错
	
	
	*/
	reg [2:0]error;
	reg [15:0] out;
	reg [3:0]count_zero;//对0计数
	reg [3:0]test_zero;//检测到12个1之后的对0计数
	reg [3:0]zero_judge;//用于判定收到12个1之后，之前的12个0是静默还是同步头
	reg [3:0]count_one;//对1计数
	reg [1:0]syn;//同步,00同步前，01数据字同步头，10状态字同步头
	reg [1:0]syn01_state;
	//reg [1:0]syn10_state;
	reg [4:0]word_count;//用于计数字中的位
	reg [16:0]word_store;//存储17位的字
	reg [7:0]mid_byte;
	reg [2:0]mid_byte_count;
	//reg mid_byte_result;//采样译码结果
	reg complete;//字中byte八位读取完成
	reg byte_encode;//曼彻斯特解码完成后，生成的结果，并将该结果写入word_store,进行输出
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
			else if(syn==2'b00)//同步前，先0后1为数据字，先1后0位指令字或状态字
				begin
					if(!data_in)//data_in采样为0
						begin
							if(count_one==0)
								begin//静默状态是0，对检测到的0只存储，不处理
									if(count_zero==11)//第12个0来到时，
										begin
											count_zero<=count_zero;
										end
									else 
										begin
											count_zero<=count_zero+1;
										end
								end
							else//count_one已经检测到过，不为0
								begin
									if(count_one==12)//已经检测到同步头，需要判断是那种同步头
										begin
											if(count_zero!=11)
												begin
													if(test_zero==11)//同步头10被确认
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
											else//已经存在对count_zero的计数，需要判定,在次只能判定同步头10这种情况，另一种情况需要在data_in==1里面给出
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
									else//未探测到同步头,对检测到的1 
										begin
											count_zero<=1;
											count_one<=0;
											test_zero<=0;
											zero_judge<=0;
										end
								end
						end
					else//data_in采样为1
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
							else if(count_one==12)//连续采样出13个1，可以判定
								begin
									if(count_zero==11)
										begin
											syn<=2'b01;
											count_zero<=0;
											count_one<=0;
											test_zero<=0;
											syn01_state<=first1;
										end
									else//同步错误
										begin
											error<=3'b001;//001同步错误，连续采样出13个1，却并没有采到足够多的0
										end
								end
							else 
								begin
									count_one<=count_one+1;
								end
						end
				end
			else if(syn==2'b01)
			//数据字，三种情形，13个1判断同步头过程中用掉一个1，直接从第2位开始计数;00
			//用掉4个0,1个1；01
			//之后的正常工作;10;
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
					//out_enable<=1;//使能输出
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
							error<=3'b010;//表明同步后的读取的数据有错误
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
			
	always @(posedge word_complete)//传输完成，奇偶校验成功则使能out_enable，否则报奇偶校验错
		begin
			if(~^word_store[16:1]==word_store[0])//正常
				begin
					out_enable<=1;
				end
			else
				begin
					error<=3'b011;
					out_enable<=1;//为了将错误代码继续上传，于是仍然将out_enabl置位
				end
		end
		
	
endmodule

module  message_writer(word_in,word_type,enable,clrn,error_in,message_complete,message_type,error_out);//识别总线活动
	input [15:0] word_in;
	input [1:0] word_type;
	input enable;
	input clrn;
	input [2:0]error_in;
	
	output message_complete;
	output [3:0]message_type;
	/*
		0000	静默状态
		0001  控制器向远程终端
		0010	远程终端向控制器
		0011  远程终端向远程终端
		0100  不带数据字的方式指令
		0101	带数据字的方式指令（发送）
		0110	带数据字的方式指令（接收）
		0111	广播：控制器向远程终端的传输
		1000	广播：远程终端向远程终端的传输
		1001	广播：不带数据字的方式指令
		1010	广播：带数据字的方式指令
		1011  未知状态
	*/
	output[2:0]error_out;
	
	reg [1:0]command_count;
	reg [4:0]rt_add;//远程终端地址
	reg [4:0]mode;//数据字计数/方式代码
	reg [4:0]sub_system;//子系统号、方式代码标志
	
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
			rt_add<=word_in[15:11];//远程终端编号
			sub_system<=word_in[9:5];//子系统编号或者是否为方式指令
			mode<=word_in[4:0];//方式代码或者数据字计数
		end
	else //无清零和错误时，指令字或状态字，数据字
		begin
			case(word_type)
			2'b10://指令字或者状态字
				begin
					if(command_count==0)//判别为指令字，有漏洞
						begin
							if(word_in[15:11]==5'b00000)//不采用全0字段，若全0，设置为未知
								begin
									word_type<=4'b1011;
								end
							else if(word_in[15:11]==5'b11111)//广播的四种情况
								begin
								
								end
							else //非广播的六种情况
								begin
									if(sub_system==5'b00000||sub_system==5'b11111)//方式指令的三种情况
										begin
											
										end
									else//数据通信的三种情况
										begin
											if(word_in[10]==0)//远程终端接收
												begin
													
												end
											else//远程终端发送
												begin
													word_type<=4'b0010;
												end
										end
								end
						end
					else//状态字
						begin
						
						end
				end
			2'b01://数据字
				begin
					
				end
			default:
				begin
					message_type<=0;
				end
			endcase
		end
	
endmodule

//顶层文件
module bm_sim(data_in,clk_8M,clrn,message_type);
	input data_in;
	input clk_8M;
	input clrn;

	output[3:0] message_type;
	/*
		0000	静默状态
		0001  控制器向远程终端
		0010	远程终端向控制器
		0011  远程终端向远程终端
		0100  不带数据字的方式指令
		0101	带数据字的方式指令（发送）
		0110	带数据字的方式指令（接收）
		0111	广播：控制器向远程终端的传输
		1000	广播：远程终端向远程终端的传输
		1001	广播：不带数据字的方式指令
		1010	广播：带数据字的方式指令
	*/
	

endmodule 

