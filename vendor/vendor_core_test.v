`timescale 1us / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:32:40 04/26/2017
// Design Name:   vendor_core
// Module Name:   C:/Users/zhenyu/Documents/ise/system/vendor/vendor_core_test.v
// Project Name:  vendor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vendor_core
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vendor_core_test;

	// Inputs
	reg clk_1Hz;
	reg clk_1kHz;
	reg rstn;
	reg suren;
	reg [3:0] goods;
	reg [2:0] money;

	// Outputs
	wire led_warn;
	wire [3:0] led;
	wire led_half_out;
	wire [4:0] price;
	wire [6:0] sum;
	wire [6:0] returned;
	wire [7:0] dis_price;
	wire [7:0] dis_money;
	wire [7:0] dis_returned;
	wire [3:0] scan_en_1;
	wire [3:0] scan_en_0;
	wire [6:0] data_1_7seg;
	wire [6:0] data_0_7seg;

	// Instantiate the Unit Under Test (UUT)
	vendor_core uut (
		.clk_1Hz(clk_1Hz), 
		.clk_1kHz(clk_1kHz), 
		.rstn(rstn), 
		.suren(suren), 
		.goods(goods), 
		.money(money), 
		.led_warn(led_warn), 
		.led(led), 
		.led_half_out(led_half_out), 
		.price(price), 
		.sum(sum), 
		.returned(returned), 
		.dis_price(dis_price), 
		.dis_money(dis_money), 
		.dis_returned(dis_returned),
		.scan_en_1(scan_en_1), 
		.scan_en_0(scan_en_0), 
		.data_1_7seg(data_1_7seg), 
		.data_0_7seg(data_0_7seg)
	);

	initial begin
		// Initialize Inputs
		clk_1Hz = 0;
		clk_1kHz = 0;
		rstn = 1;
		suren = 1;
		goods = 0;
		money = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rstn=0;
		
		#1000;
		rstn=1;
		
		
		#1000 money=3'b011;
		goods=4'b0010;
		#200 suren=0;
		#50  suren=1;
		
		#5000 money=0;
		goods=0;
		
        
		// Add stimulus here

	end
	
	initial 
	begin
		clk_1kHz=0;
		forever
		#500 clk_1kHz=~clk_1kHz;
	end
	
	initial 
	begin
		clk_1Hz=0;
		forever
		#500000 clk_1Hz=~clk_1Hz;
	end
      
endmodule

