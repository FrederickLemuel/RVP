//The operations contain 5 bits
//Branch/LUI/JALR:MSB=1
//Other ALU instructions:MSB=0
//MSB is ignored in the macros definition

//Set 4 digit binary values for the operations to performed
//ALU operations
`define ADD 4'b0000     
`define SUB 4'b1000
'define XOR 4'b0100
'define OR 4'b0011
'define AND 4'b0111

//Set Less-than. Signed values of operands are considered
'define SLT 4'b0010  
//Unsigned Set Less Than
'define SLTU 4'b0110  
//Logical Left-shift
'define LLS 4'b0001   
//Logical right-shift
'define LRS 4'b0101
//Arithmetic right-shift 
`define ARS 4'b1101

//Branch instructions
`define BEQ 4'b0000	
`define BNE 4'b0001	
`define BLT 4'b0100		
`define BLTU 4'b0110			 
`define BGE 4'b0101		
`define BGEU 4'b0111

//Jump instruction and load upper immediate
`define JALR 4'b1001		
`defineLUI 4'b1000

'define DATA_MEM_WORD_SIZE 32
'define REGISTER_WIDTH 32
`define ALU_CTRL_WIDTH 5
				 
module Exec(
    input [(`REGISTER_WIDTH-1):0] Operand1,		//Holds the value of the 1st operand in the instruction
    input [(`REGISTER_WIDTH-1):0] Operand2,    //Holds the value of the 2nd operand in the instruction
	 input [(`ALU_CTRL_WIDTH-1):0] Operation,     //Input to the ALU that specifies the operation to be performed
	 output reg bcond,
    output reg [(`DATA_MEM_WORD_SIZE-1):0] Out     //Holds the value to written into the destination register    
    );
	 
	 reg flag;
	 
	always@(*)	
	begin
		//Branch instruction if MSB of Operation is set
		if(Operation[`ALU_CTRL_WIDTH]==1)
		begin
		  
		   flag=(Operand1==Operand2);
			//Case block for branch instructions and JALR	
			case(Operation[(`ALU_CTRL_WIDTH-2):0])
									
       		                `BEQ: bcond=flag;
				`BNE: bcond=~flag;
				`BGE: begin				 
						 if($signed(Operand1)>=$signed(Operand2))
						  bcond=1;						
						 else
						  bcond=0;
					   end
				 		
			        `BGEU:begin
						 if(Operand1>=Operand2)
						  bcond=1;
						 else
						  bcond=0;
					   end
				`BLT: begin
						if($signed(Operand1)<$signed(Operand2))
						bcond=1;						
						else					
						bcond=0;
					  end	
				`BLTU:begin
						 if(Operand1<Operand2)
						  bcond=1;						
						 else		
					     bcond=0;
					   end
				`JALR:begin
				       Out=(Operand1+Operand2);
						 Out[0]=1'b0;
						end
				`LUI: begin
						 Out=Operand2;
					  end						
				default: bcond=0;
				
			endcase
		end
		
		else
		//Case block for ALU operations
		begin
			
			case(Operation[3:0])
				`ADD : Out = Operand1 + Operand2; 			//Adds first and second operand
				`SUB : Out = Operand1 - Operand2; 			//Subtracts the second operand from the first
				`XOR : Out = Operand1 ^ Operand2; 			//Perfroms XOR on the two operands
				`OR  : Out = Operand1 | Operand2; 			//Perfroms OR on the two operands
				`AND : Out = Operand1 & Operand2; 			//Performs AND on the two operands
				`SLTU : begin
						if(Operand1 < Operand2)				//(Unsigned)SLTU sets the output to 1 if the first operand is less than the second and zero otherwise
							Out=1;
						else
							Out=0;							 
						end
				`SLT : begin
						if($signed(Operand1) < $signed(Operand2))	//(Signed)SLT sets the output to 1 if the first operand is less than the second and zero otherwise
							Out=1;
						else
							Out=0;							 
						end		
				`LLS : Out = Operand1 << Operand2[4:0]; 	//Shifts the 1st operand left by the value held in the lowest 5 bits of the second operand, filling the lowest bits with 0's
				`LRS : Out = Operand1 >> Operand2[4:0]; 	//Shifts the 1st operand right by the value held in the lowest 5 bits of the second operand, filling the lowest bits with 0's
				`ARS : Out = Operand1 >>> Operand2[4:0];	//Shifts the 1st operand right by the value held in the lowest 5 bits of the second operand, filling the lowest bits with the sign bit			
				default: Out={(`DATA_MEM_WORD_SIZE){1'bx}};
			 endcase			
      end		 
	end	  
endmodule
