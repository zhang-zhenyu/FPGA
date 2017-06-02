`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   22:16:10 03/22/2017
// Design Name:   encoder32_5
// Module Name:   C:/Users/zhenyu/Documents/ise/system/encoder8_3/encoder32_5/encoder32_5test.v
// Project Name:  encoder32_5
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: encoder32_5
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module encoder32_5test;

	// Inputs
	reg EI;
	reg [31:0] I;

	// Outputs
	wire [4:0] Z;
	wire GS;
	wire EO;

	// Instantiate the Unit Under Test (UUT)
	encoder32_5 uut (
		.EI(EI), 
		.I(I), 
		.Z(Z), 
		.GS(GS), 
		.EO(EO)
	);

	initial
	begin
	EI = 0; //�������������
	I = 32'b11110000001010101111111111110000; //F02AFFF0H��I27���ȱ���
	#30 I = 32'b00001111000100101101111010010111; //0F12DE97H��I31���ȱ���
	#30 I = 32'b11111111111111111111111100001010; //FFFFFF0AH��I7���ȱ���
	#30 EI = 1; //��ֹ����������
	I = 32'b00000000000000000000111111111111; //00000FFFH
	#30 EI = 0; //�������������
	#10 I = 32'b11111111111111111111111111111110; //FFFFFFFEH��I0���ȱ���
	#30 I = 32'b11111111111111111111111111110000; //FFFFFFF0H��I3���ȱ���
	#30 I = 32'b11111111111111111111111111111111; //FFFFFFFFH��û�б�������
	#30 I = 32'b11111111000000101010000001111101; //FF02A07DH��I23���ȱ���
	#30 I = 32'b11111111111111110000100010110010; //FFFF08B2H��I15���ȱ���
	#30 I = 32'b11111111111111111111111111110000; //FFFFFFF0H��I3���ȱ���
	end
      
endmodule

