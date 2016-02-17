`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:46:47 02/17/2016
// Design Name:   dist_ROM
// Module Name:   /home/lemy/Project-8thSem/Code/Memory/dist_ROM_tb.v
// Project Name:  Memory
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: dist_ROM
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module dist_ROM_tb;

	// Inputs
	reg [5:0] a;
	// Outputs
	wire [15:0] spo;
	
	integer j;
	// Instantiate the Unit Under Test (UUT)
	dist_ROM uut (
		.a(a), 
		.spo(spo)
	);

	initial begin
		// Initialize Inputs
		a =6'bx;
		// Wait 100 ns for global reset to finish
		#5;
		
		for(j=0;j<=16;j=j+1)
		begin
			a=j;
			#5;
		end
		$finish;
	end	
      
endmodule

