module Exec_Branch_v1(
    input [31:0] Operand1,		//Holds the value of the 1st operand in the instruction
    input [31:0] Operand2,    //Holds the value of the 2nd operand in the instruction
	 input [3:0] Operation,    //Input to the ALU that specifies the operation to be performed
	 input [2:0] BranchCond,   //Specifies the branch condition
	 input branch,					//A flag which indicates the execution of branch instruction
	 input [31:0] offset,      //Holds the offset value to compute the new address
	 input [31:0] curr_pc,		//Holds the current value of the program counter
	 output reg bcond,			//
    output reg [31:0] Out,    //Holds the value to written into the destination register
	 output reg [31:0] pc    	//Value of the new location from where the next instruction is to be fetched
    );	 
	 
	 wire flag;
	 wire [31:0] pc_temp;
	 
	parameter ADD=4'b0000,     //Set 4 digit binary values for the operations to performed
				 SUB=4'b1000,
				 XOR=4'b0100,
				 OR=4'b0011,
				 AND=4'b0111,
				 SLT=4'b0010,     //Set Less-than
				 LLS=4'b0001,     //Logical Left-shift
				 LRS=4'b0101,	   //Logical right-shift
				 ARS=4'b1101;     //Arithmetic right-shift
				 
	parameter BEQ=3'b000,
				 BNE=3'b001,
				 BLT=3'b100,
				 BGT=3'b101;
	
	always@(*)	
		begin
		
		//If block for execution of branch instructions
	   if(branch==1)		 
		 begin			
			flag=(Operand1==Operand2);
			
			case(BranchCond)
			
			 BEQ: bcond=flag;
			 BNE: bcond=~flag;
			 BGT: if(Operand1<Operand2)
			        bcond=1;
			 BLT: if(Operand1>Operand2)
			        bcond=1;
			 default:bcond=1'bx;
			 
			endcase
			
			pc_temp=bcond?(curr_pc+4+offset):curr_pc+4;			
	    end
		 
		 else if(jump==1)
		  begin
		  		 //Add code for jump here
		  end

		
		//Else block for execution of instructions apart from branch and jump		
		else
			begin
			
			 case (Operation) 			
			  ADD : Out = Operand1 + Operand2; 			//Adds first and second operand
			  SUB : Out = Operand1 - Operand2; 			//Subtracts the second operand from the first
			  XOR : Out = Operand1 ^ Operand2; 			//Perfroms XOR on the two operands
			  OR  : Out = Operand1 | Operand2; 			//Perfroms OR on the two operands
			  AND : Out = Operand1 & Operand2; 			//Performs AND on the two operands
			  SLT : begin
				   	 if(Operand1 < Operand2)				//SLT sets the output to 1 if the first operand is less than the second and zero otherwise
				   		Out=1;
					   else
						Out=32'b0;							 
					  end
			  LLS : Out = Operand1 << Operand2[4:0]; 	//Shifts the 1st operand left by the value held in the lowest 5 bits of the second operand, filling the lowest bits with 0's
			  LRS : Out = Operand1 >> Operand2[4:0]; 	//Shifts the 1st operand right by the value held in the lowest 5 bits of the second operand, filling the lowest bits with 0's
			  ARS : Out = Operand1 >>> Operand2[4:0];	//Shifts the 1st operand right by the value held in the lowest 5 bits of the second operand, filling the lowest bits with the sign bit
			
		     default: Out=32'bx;
			
          endcase 				
			end	
	   end
		
endmodule
