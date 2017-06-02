`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:24:48 04/21/2017
// Design Name:   encoder
// Module Name:   C:/Users/zhenyu/Documents/ise/system/BM/bm_test.v
// Project Name:  BM
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: encoder
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module bm_test;

	// Inputs
	reg data_in;
	reg clk_8M;
	reg clk_2M;
	reg clrn;

	// Outputs
	wire [15:0] out;
	wire [2:0] error;
	wire out_enable;
	wire [1:0]word_type;
	
	//�м��������
	wire [3:0]count_zero;//��0����
	wire [3:0]test_zero;//��⵽12��1֮��Ķ�0����
	wire [3:0]zero_judge;//�����ж��յ�12��1֮��֮ǰ��12��0�Ǿ�Ĭ����ͬ��ͷ
	wire [3:0]count_one;//��1����
	wire [1:0]syn;
	wire [1:0]syn01_state;
	//reg [1:0]syn10_state;
	wire [4:0]word_count;//���ڼ������е�λ
	wire [16:0]word_store;//�洢17λ����
	wire [7:0]mid_byte;
	wire [2:0]mid_byte_count;
	//reg mid_byte_result;//����������
	wire complete;//����byte��λ��ȡ���
	wire byte_encode;//mid_byte ����

	
	
	//integer i;

	// Instantiate the Unit Under Test (UUT)
	encoder uut (
		.data_in(data_in), 
		.clk_8M(clk_8M), 
		.clrn(clrn), 
		.out(out), 
		.error(error),
		.out_enable(out_enable),
		.word_type(word_type)
	);
	
	assign count_zero=uut.count_zero;
	assign count_one=uut.count_one;
	assign zero_judge=uut.zero_judge;
	assign test_zero=uut.test_zero;
	assign syn=uut.syn;
	assign syn01_state=uut.syn01_state;
	assign word_count=uut.word_count;
	assign word_store=uut.word_store;
	assign mid_byte=uut.mid_byte;
	assign mid_byte_count=uut.mid_byte_count;
	assign complete=uut.complete;
	assign byte_encode=uut.byte_encode;
	
	initial begin
		// Initialize Inputs
		data_in = 0;
		//clk_8M = 0;
		clrn = 0;
		//i=0;
		
		#100 clrn<=1;
		// Wait 100 ns for global reset to finish
		
      #2000 data_in=0;//2100��ʼ-3600
		#1500 data_in=1;//3600-5100,ͬ��ͷ��01
		
		#1500 
			data_in=0;//4600-5600
		#500 
			data_in=1;//1,0 
		
		#500 data_in=0;
		#500 data_in=1;//2,0
		
		#500 data_in=1;
		#500 data_in=0;//3,1
		
		#500 data_in=1;
		#500 data_in=0;//4,1
		
		#500 data_in=0;
		#500 data_in=1;//5,0
		
		#500 data_in=1;
		#500 data_in=0;//6,1
		
		#500 data_in=0;
		#500 data_in=1;//7,0
		
		#500 data_in=1;#500 data_in=0;//8
		
		#500 data_in=1;#500 data_in=0;//9
		
		#500 data_in=0;#500 data_in=1;//10
		#500 data_in=0;#500 data_in=1;//11
		#500 data_in=0;#500 data_in=1;//12
		#500 data_in=0;#500 data_in=1;//13
		#500 data_in=0;#500 data_in=1;//14
		#500 data_in=1;#500 data_in=0;//15
		#500 data_in=0;#500 data_in=1;//16
		#500 data_in=0;#500 data_in=1;//17
		#500 data_in=0;
		
		//��һ����
	   #20000 data_in=0;//2100��ʼ-3600
		#1500 data_in=1;//3600-5100,ͬ��ͷ��01
		
		#1500 data_in=1;//4600-5600
						#500 
		data_in=0;//1,1 
						#500 
		data_in=0;
		#500 data_in=1;//2,0
		
		#500 data_in=1;
		#500 data_in=0;//3,1
		
		#500 data_in=1;
		#500 data_in=0;//4,1
		
		#500 data_in=0;
		#500 data_in=1;//5,0
		
		#500 data_in=1;
		#500 data_in=0;//6,1
		
		#500 data_in=0;
		#500 data_in=1;//7,0
		
		#500 data_in=1;#500 data_in=0;//8
		
		#500 data_in=1;#500 data_in=0;//9
		
		#500 data_in=0;#500 data_in=1;//10
		#500 data_in=0;#500 data_in=1;//11
		#500 data_in=0;#500 data_in=1;//12
		#500 data_in=0;#500 data_in=1;//13
		#500 data_in=0;#500 data_in=1;//14
		#500 data_in=1;#500 data_in=0;//15
		#500 data_in=0;#500 data_in=1;//16
		#500 data_in=0;#500 data_in=1;//17
		#500 data_in=0;
		
		//��һ����
	   #20000 data_in=0;//2100��ʼ-3600
		#10 data_in=1;//3600-5100,ͬ��ͷ��01
		
		#1500 data_in=0;//4600-5600
		
		#1500 
		
		data_in=0;//4600-5600
						#500 
		data_in=1;//1,0 
						#500 
		data_in=0;
		#500 data_in=1;//2,0
		
		#500 data_in=1;
		#500 data_in=0;//3,1
		
		#500 data_in=1;
		#500 data_in=0;//4,1
		
		#500 data_in=0;
		#500 data_in=1;//5,0
		
		#500 data_in=1;
		#500 data_in=0;//6,1
		
		#500 data_in=0;
		#500 data_in=1;//7,0
		
		#500 data_in=1;#500 data_in=0;//8
		
		#500 data_in=1;#500 data_in=0;//9
		
		#500 data_in=0;#500 data_in=1;//10
		#500 data_in=0;#500 data_in=1;//11
		#500 data_in=0;#500 data_in=1;//12
		#500 data_in=0;#500 data_in=1;//13
		#500 data_in=0;#500 data_in=1;//14
		#500 data_in=1;#500 data_in=0;//15
		#500 data_in=0;#500 data_in=1;//16
		#500 data_in=0;#500 data_in=1;//17
		#1000 data_in=0;
		
		//��һ����
	   #20000 data_in=0;//2100��ʼ-3600
		#10 data_in=1;//3600-5100,ͬ��ͷ��01
		
		#1500 data_in=0;//4600-5600
		
		#1500 
		
		data_in=1;//4600-5600
						#500 
		data_in=0;//1,0 
						#500 
		data_in=0;
		#500 data_in=1;//2,0
		
		#500 data_in=1;
		#500 data_in=0;//3,1
		
		#500 data_in=1;
		#500 data_in=0;//4,1
		
		#500 data_in=0;
		#500 data_in=1;//5,0
		
		#500 data_in=1;
		#500 data_in=0;//6,1
		
		#500 data_in=0;
		#500 data_in=1;//7,0
		
		#500 data_in=1;#500 data_in=0;//8
		
		#500 data_in=1;#500 data_in=0;//9
		
		#500 data_in=0;#500 data_in=1;//10
		#500 data_in=0;#500 data_in=1;//11
		#500 data_in=0;#500 data_in=1;//12
		#500 data_in=0;#500 data_in=1;//13
		#500 data_in=0;#500 data_in=1;//14
		#500 data_in=1;#500 data_in=0;//15
		#500 data_in=0;#500 data_in=1;//16
		#500 data_in=0;#500 data_in=1;//17
		#1000 data_in=0;
		
		#10000 data_in=0;

		
		$stop;
		// Add stimulus here

	end
	
	/*
	always @(posedge clk_2M)
	begin
		if(i<1000)
			begin
			end
	end
	*/
	
	initial 
	begin
	clk_8M = 0;
	forever #62.5 clk_8M<=~clk_8M;
	end
	
	initial 
	begin
	clk_2M = 0;
	forever #250 clk_2M<=~clk_2M;
	end
      
endmodule

