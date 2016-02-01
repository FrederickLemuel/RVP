`timescale 1ns / 1ps

module Exec_tb;

	// Inputs
	reg [31:0] Operand1;
	reg [31:0] Operand2;
	reg [3:0] Operation;

	// Outputs
	wire [31:0] Out;

	// Instantiate the Unit Under Test (UUT)
	Exec uut (
		.Operand1(Operand1), 
		.Operand2(Operand2), 
		.Out(Out), 
		.Operation(Operation)
	);
	
	initial
	begin
		// Initialize Inputs
		
		Operand1 = 0;
		Operand2 = 0;
		Operation = 4'bx;
		
		// Wait 5ns for global reset to finish
		#5;       
	   Operand1=5'b10111;
		Operand2=8'b11001010;
		
		//Monitor signals
		$monitor("Time: %g Operand 1: %d Operand 2: %d Output: %d",$time,Operand1,Operand2,Out);
		
		//Stimulus
		repeat(15)
			begin
				Operation={$random}%9;	//Genarate random numbers between 0 and 9
				#5;
			end
		#5 $finish;		
	end
endmodule

