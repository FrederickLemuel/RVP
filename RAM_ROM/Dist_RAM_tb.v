`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:05:23 02/17/2016
// Design Name:   Dist_RAM
// Module Name:   /home/lemy/Project-8thSem/Code/Memory/Dist_RAM_tb.v
// Project Name:  Memory
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Dist_RAM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Dist_RAM_tb;

	// Inputs
	reg [5:0] a;
	reg [15:0] d;
	reg clk;
	reg we;

	// Outputs
	wire [15:0] spo;

	// Instantiate the Unit Under Test (UUT)
	Dist_RAM uut (
		.a(a), 
		.d(d), 
		.clk(clk), 
		.we(we), 
		.spo(spo)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		d = 0;
		clk = 0;
		we = 0;

		// Wait 100 ns for global reset to finish
		#5;
		//////////////
		we=1;
		d=16'haa;
		
		#5;
		a=1;
		d=16'hcc;
		
		#5;
		we=0;
		a=0;
		
		#5;
		a=2;
		we=1;
		d=16'h22;
		
		#5;
		we=0;
		a=1;
		#5;
		a=2;
		
		#5;
		$finish;
        
		// Add stimulus here

	end
	
	always
		#2 clk=~clk;
      
endmodule

