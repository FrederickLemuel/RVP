module Exec(
    input [31:0] Operand1,		//Holds the value of the 1st operand in the instruction
    input [31:0] Operand2,    //Holds the value of the 2nd operand in the instruction
    output reg [31:0] Out,    //Holds the value to written into the destination register
    input [3:0] Operation     //Input to the ALU that specifies the operation to be performed
    );
	 
	parameter ADD=4'b0000,     //Set 4 digit binary values for the operations to performed
				 SUB=4'b0001,
             XOR=4'b0010,
				 OR=4'b0011,
				 AND=4'b0100,
				 SLT=4'b0101,
				 LLS=4'b0110,
				 LRS=4'b0111,
				 ARS=4'b1000;
	
	always@(*)
	
		begin
		 case (Operation) 
			
			ADD : Out = Operand1 + Operand2; 			//Adds first and second operand
			SUB : Out = Operand1 - Operand2; 			//Subtracts the second operand from the first
			XOR : Out = Operand1 ^ Operand2; 			//Perfroms XOR on the two operands
			OR  : Out = Operand1 | Operand2; 			//Perfroms OR on the two operands
			AND : Out = Operand1 & Operand2; 			//Performs AND on the two operands
			SLT : begin
					 if(Operand1 < Operand2)		//SLT sets the output to 1 if the first operand is less than the second and zero otherwise
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
	  
endmodule
