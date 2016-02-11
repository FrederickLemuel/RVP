module Memory_Access_tb;

	// Inputs
	reg [31:0] data;
	reg [31:0] op1;
	reg [31:0] op2;
	reg [2:0] add;
	reg wr_en;
	reg rd_en;
	reg clk;

	// Outputs
	wire [31:0] rd_data;

	// Instantiate the Unit Under Test (UUT)
	Memory_Access uut (
		.data(data), 
		.add(add),
		.op1(op2),
		.op2(op2),
      .clk(clk),		
		.wr_en(wr_en), 
		.rd_en(rd_en), 
		.rd_data(rd_data)
	);
	
	integer i;

	initial
	begin
		// Initialize Inputs
		data = 0;
		add = 0;
		clk=0;
		wr_en = 0;
		rd_en = 0;
		op1=0;
		op2=0;

		// Wait 1 ns for global reset to finish
		#1;
		op1=4;
		op2=4;
		//Write data to memory		
		wr_en=1;
		for(i=0;i<=7;i=i+1)
		begin
			add=i;
			data=i;
			#5;
		end
		//Read from memory
		//wr_en is low and rd_en is high
		//The two operands are added on the +ve edge and data is read from memory location given by 'add' on the -ve edge
		wr_en=0;
		rd_en=1;
		for(i=7;i>=0;i=i-1)
		begin
			add=i;		
			#5;
		end
			
			$finish;
	end
	
	always
	 begin
		#3 clk = ~clk;
    end
      
endmodule

