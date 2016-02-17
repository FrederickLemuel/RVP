`define MEM_SIZE 32

module Dist_RAM_sync_tb;

	// Inputs
	reg [5:0] a;
	reg [(`MEM_SIZE-1):0] d;
	reg clk;
	reg we;
	reg qspo_ce;
	reg qspo_srst;

	// Outputs
	wire [(`MEM_SIZE-1):0] qspo;
	
	integer i=0;

	// Instantiate the Unit Under Test (UUT)
	Dist_RAM_sync uut (
		.a(a), 
		.d(d), 
		.clk(clk), 
		.we(we), 
		.qspo_ce(qspo_ce), 
		.qspo_srst(qspo_srst), 
		.qspo(qspo)
	);

	initial begin
		// Initialize Inputs
		a = 0;
		d = 0;
		clk = 0;
		we = 0;
		qspo_ce = 0;
		qspo_srst = 0;

		// Wait 100 ns for global reset to finish
		#5;
		//////////////
		we=1;
		
		for(i=0;i<32;i=i+1)
		begin
			a=i;
			d=i;
			#5;
		end
		
		#5;
		we=0;
		qspo_ce=1;
		a=0;
		
		#5;
		a=2;
		qspo_ce=0;
		we=1;
		d=16'h22;
		
		#5;
		we=0;
		qspo_ce=1;
		a=1;
		
		#4;
		a=2;
		
		#5;
		a=15;
		
		#5;
		$finish;

	end
	
	always
		#2 clk=~clk;
      
endmodule

