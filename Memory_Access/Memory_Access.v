`define MEM_SIZE 8

module Memory_Access(
   //Data that is written to memory
	input [31:0] data,
	//The address in memory that is to be accessed
	input [2:0] add,
	//Two operands which are added
	input [31:0] op1,
	input [31:0] op2,	
	//When high data is written to memory	
	input wr_en,
	//When high data is read from memory
	input rd_en,
	input clk,
	output reg [31:0]rd_data
    );
	 
	 //8 32-bit memory locations
	 reg [31:0] mem [(`MEM_SIZE-1):0];
 always@(posedge clk)
 begin	 
	 if(wr_en==1)	
	 begin 
		mem[add]=data;		//Write data to the location specified in add
	 end
	 
	 else
		rd_data=op1+op2;	 //If wr_en is not high add the two operands and send to output port
 end
 
 always@(negedge clk)
 begin 
	 if(rd_en==1)
	 begin 
		rd_data=mem[add];//Read data from the location specified in add
	 end
 end
endmodule
