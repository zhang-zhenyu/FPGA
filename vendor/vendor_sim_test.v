`timescale 1us / 1ns

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:31:02 04/26/2017
// Design Name:   vendor_sim
// Module Name:   C:/Users/zhenyu/Documents/ise/system/vendor/vendor_sim_test.v
// Project Name:  vendor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: vendor_sim
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module vendor_sim_test;

	// Inputs
	reg clk_1Hz;
	reg clk_1kHz;
	reg rst_button;
	reg sure_button;
	reg [3:0] goods;
	reg [2:0] money;

	// Outputs
	wire led_warn;
	wire [3:0] led;
	wire led_half_out;
	wire [3:0] scan_en_1;
	wire [3:0] scan_en_0;
	wire [6:0] data_1_7seg;
	wire [6:0] data_0_7seg;
	
	wire rstn;
	wire suren;
	
	
	wire[4:0] price; //所选商品价格。为便于观察其变化，声明为输出，内存价格
wire[6:0] sum; //投入钱币的总金额,按分计，内存钱数
wire[6:0]returned; //找零金额或是投入钱币小于商品价格时退回所投钱币

wire [7:0] dis_price ; //所选商品价格的高位和低位BCD码
wire [7:0] dis_money; //投入钱币金额的高位和低位BCD码
wire [7:0] dis_returned ; //找零金额的高位和低位BCD码


assign rstn=uut.button_rstn.signal;
assign suren=uut.button_suren.signal;

assign dis_price=uut.dis_price;
assign dis_money=uut.dis_money;
assign dis_returned=uut.dis_returned;

assign price=uut.price;
assign sum=uut.sum;
assign returned=uut.returned;
	// Instantiate the Unit Under Test (UUT)
	vendor_sim uut (
		.clk_1Hz(clk_1Hz), 
		.clk_1kHz(clk_1kHz), 
		.rst_button(rst_button), 
		.sure_button(sure_button), 
		.goods(goods), 
		.money(money), 
		.led_warn(led_warn), 
		.led(led), 
		.led_half_out(led_half_out), 
		.scan_en_1(scan_en_1), 
		.scan_en_0(scan_en_0), 
		.data_1_7seg(data_1_7seg), 
		.data_0_7seg(data_0_7seg)
	);

	initial begin
		// Initialize Inputs
		//clk_1Hz = 0;
		//clk_1kHz = 0;
		
		//uut.rstn=1;
		//uut.suren=1;
		
		//rstn=1;
		rst_button = 1;
		sure_button = 1;
		goods = 0;
		money = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		#100;
		rst_button=0;
		
		#1100;
		rst_button=1;
		
		#200000;
		rst_button=0;
		
		#1100;
		rst_button=1;
		#200000;
		
		#1000 money=3'b011;
		goods=4'b0010;
		
		#200 sure_button=0;
		#5000  sure_button=1;
		
		#5000000 money=0;
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

