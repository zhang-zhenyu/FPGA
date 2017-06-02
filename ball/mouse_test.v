`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:12:53 05/16/2017
// Design Name:   mouse
// Module Name:   C:/Users/zhenyu/Documents/ise/system/ball/mouse_test.v
// Project Name:  ball
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: mouse
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module mouse_test;

	// Inputs
	reg clk_12MHz;
	reg reset;

	// Outputs
	wire upr;
	wire downr;
	wire valid;
	wire [10:0] senddata;
	reg [10:0] send;
	

	// Bidirs
	wire ps2_clk;
	wire ps2_data;
	
	reg m_clk;
	reg m_data;
	assign ps2_clk=m_clk;
	assign ps2_data=m_data;
	
	integer i;
	reg [10:0] recedata;
	reg got_enable;

	// Instantiate the Unit Under Test (UUT)
	mouse uut (
		.clk_12MHz(clk_12MHz), 
		.reset(reset), 
		.ps2_clk(ps2_clk), 
		.ps2_data(ps2_data), 
		.upr(upr), 
		.downr(downr), 
		.valid(valid), 
		.senddata(senddata)
	);

	initial begin
		// Initialize Inputs
		//clk_12MHz = 0;
		reset = 0;
		m_clk = 1'bz;
		m_data =1'bz;
		
		i=0;
		got_enable=0;

		// Wait 100 ns for global reset to finish
		#100;
		reset=1;
		#200
		reset=0;
		
		#500
		reset=1;
      
		// Add stimulus here
		#(130000-800) m_clk=1;
		while(i<22)
			begin
				#25000 m_clk=~m_clk;
				i=i+1;
			end
			m_clk=1'bz;
			
		#100000 m_clk=1;
		i=0;
		send=11'b11_1111_1010_0;
		got_enable=1;
		while(i<22)
			begin
				#25000 m_clk=~m_clk;
				i=i+1;
			end
			m_clk=1'bz;
			
		#100000 m_clk=1;
		i=0;
		send=11'b11_0000_1001_0;
		got_enable=1;
		while(i<22)
			begin
				#25000 m_clk=~m_clk;
				i=i+1;
			end
		m_clk=1'bz;
		
		#10000 m_clk=1;
		i=0;
		send=11'b11_0000_1010_0;
		got_enable=1;
		while(i<22)
			begin
				#25000 m_clk=~m_clk;
				i=i+1;
			end
		m_clk=1'bz;
		
		#10000 m_clk=1;
		i=0;
		send=11'b11_0000_1010_0;
		got_enable=1;
		while(i<22)
			begin
				#25000 m_clk=~m_clk;
				i=i+1;
			end
		m_clk=1'bz;
		
		#100000 m_clk=1;
		i=0;
		send=11'b11_0000_1010_0;
		got_enable=1;
		while(i<22)
			begin
				#25000 m_clk=~m_clk;
				i=i+1;
			end
		m_clk=1'bz;
		
		#10000 m_clk=1;
		i=0;
		send=11'b11_0000_1010_0;
		got_enable=1;
		while(i<22)
			begin
				#25000 m_clk=~m_clk;
				i=i+1;
			end
		m_clk=1'bz;
		
		#10000 m_clk=1;
		i=0;
		send=11'b11_0000_1010_0;
		got_enable=1;
		while(i<22)
			begin
				#25000 m_clk=~m_clk;
				i=i+1;
			end
		m_clk=1'bz;
		
		
		#100000 $stop;

	end
	
	always @(negedge ps2_clk)
		begin
			if(got_enable)
			begin
				send<={1'b1,send[10:1]};
				m_data<=send[0];
			end
		end
	
	

//parameter CMD_F4=12'b10_11110100_0;//ps/2 设备使能命令，11 位（停止位1+校验位0+ F4 +起始位0）	
	always @(posedge ps2_clk)
		begin
			if(ps2_data===0)
				begin
					recedata={1'b0,recedata[10:1]};
				end
			else
				begin
					recedata={1'b1,recedata[10:1]};
				end
		end
      
	initial 
		begin
			clk_12MHz = 0;
			forever
			#40	clk_12MHz=~clk_12MHz;
		end
		
	
		
endmodule

