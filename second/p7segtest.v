`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:39:44 03/29/2017
// Design Name:   p7seg
// Module Name:   C:/Users/zhenyu/Documents/ise/system/encoder8_3/second/p7segtest.v
// Project Name:  second
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: p7seg
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module p7segtest;

	// Inputs
	reg [3:0] data;

	// Outputs
	wire [6:0] out;

	// Instantiate the Unit Under Test (UUT)
	p7seg uut (
		.data(data), 
		.out(out)
	);

	initial begin
		data = 0;
#20 data=4'd1;
#20 data=4'd2;
//бнбн
#20 data=4'd15;

	end
      
endmodule

