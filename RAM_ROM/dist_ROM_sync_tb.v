`define MEM_SIZE 32
`define ADDRESS_SIZE 6

module dist_ROM_sync_tb;

	// Inputs
	reg [(`ADDRESS_SIZE-1):0] a;
	reg clk;
	reg qspo_ce;

	// Outputs
	wire [(`MEM_SIZE-1):0] qspo;
	
	integer j;

	// Instantiate the Unit Under Test (UUT)
	dist_ROM_sync uut (
		.a(a), 
		.clk(clk), 
		.qspo_ce(qspo_ce), 
		.qspo(qspo)
	);

	initial
	begin
		// Initialize Inputs
		a = 6'bx;
		clk = 0;
		qspo_ce = 0;
		#5;
		qspo_ce=1;
		// Wait 100 ns for global reset to finish
		for(j=0;j<=16;j=j+1)
		begin
			a=j;
			#5;
		end
		$finish;
	end
	
	always
	   #2 clk=~clk;
      
endmodule

