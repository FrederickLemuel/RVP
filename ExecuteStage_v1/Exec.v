module Exec(
    input [31:0] Operand1,		//Holds the value of the 1st operand in the instruction
    input [31:0] Operand2,    //Holds the value of the 2nd operand in the instruction
	 input [4:0] Operation,     //Input to the ALU that specifies the operation to be performed
	 output reg bcond,
    output reg [31:0] Out     //Holds the value to written into the destination register    
    );
	 
	 reg flag;
	 
	parameter ADD=4'b0000,     //0-Set 4 digit binary values for the operations to performed
				 SUB=4'b1000,     //8-Subtract Operand 2 from Operand1
				 XOR=4'b0100,		//4-Performs XOR operation
				 OR=4'b0011,		//3-Perform OR
				 AND=4'b0111,		//7-Perform AND
				 SLT=4'b0010,     //2-Set Less-than. Signed values of operands are considered
				 SLTU=4'b0110,		//6-Unsigned Set Less Than
				 LLS=4'b0001,     //1-Logical Left-shift
				 LRS=4'b0101,	   //5-Logical right-shift
				 ARS=4'b1101;     //13-Arithmetic right-shift
				 
	parameter BEQ=4'b0000,		//16-Set bcond to 1 if the operands are equal
				 BNE=4'b0001,		//17-Set bcond to 1 if the operands are not equal
				 BLT=4'b0100,		//20-Set bcond to 1 if the Signed value of Operand1 is less-than Signed value of operand2	
				 BLTU=4'b0110,		//22-Unsigned BLT		 
				 BGE=4'b0101,		//21-Set bcond to 1 if the Signed value of Operand1 is greater than or equal to Signed value of operand2	
				 BGEU=4'b0111,		//23-Unsigned BGE
				 JALR=4'b1001,		//25	
				 LUI=4'b1000;		//24
				 
	
	always@(*)	
	begin
		//Branch instruction if MSB of Operation is set
		if(Operation[4]==1)
		begin
		  
		   flag=(Operand1==Operand2);
			//Case block for branch instructions and JALR	
			case(Operation[3:0])
									
       		 BEQ: bcond=flag;
				 BNE: bcond=~flag;
				 BGE: begin				 
						 if($signed(Operand1)>=$signed(Operand2))
						  bcond=1;						
						 else
						  bcond=0;
					   end
				 		
			    BGEU:begin
						 if(Operand1>=Operand2)
						  bcond=1;
						 else
						  bcond=0;
					   end
				 BLT: begin
						if($signed(Operand1)<$signed(Operand2))
						bcond=1;						
						else					
						bcond=0;
					  end	
				 BLTU:begin
						 if(Operand1<Operand2)
						  bcond=1;						
						 else		
					     bcond=0;
					   end
				 JALR:begin
				       Out=(Operand1+Operand2);
						 Out[0]=1'b0;
						end
				LUI: begin
						 Out=Operand2;
					  end						
				default: bcond=0;
				
			endcase
		end
		
		else
		//Case block for ALU operations
		begin
			
			case(Operation[3:0])
				ADD : Out = Operand1 + Operand2; 			//Adds first and second operand
				SUB : Out = Operand1 - Operand2; 			//Subtracts the second operand from the first
				XOR : Out = Operand1 ^ Operand2; 			//Perfroms XOR on the two operands
				OR  : Out = Operand1 | Operand2; 			//Perfroms OR on the two operands
				AND : Out = Operand1 & Operand2; 			//Performs AND on the two operands
				SLTU : begin
						if(Operand1 < Operand2)				//(Unsigned)SLTU sets the output to 1 if the first operand is less than the second and zero otherwise
							Out=1;
						else
							Out=0;							 
						end
				SLT : begin
						if($signed(Operand1) < $signed(Operand2))	//(Signed)SLT sets the output to 1 if the first operand is less than the second and zero otherwise
							Out=1;
						else
							Out=0;							 
						end		
				LLS : Out = Operand1 << Operand2[4:0]; 	//Shifts the 1st operand left by the value held in the lowest 5 bits of the second operand, filling the lowest bits with 0's
				LRS : Out = Operand1 >> Operand2[4:0]; 	//Shifts the 1st operand right by the value held in the lowest 5 bits of the second operand, filling the lowest bits with 0's
				ARS : Out = Operand1 >>> Operand2[4:0];	//Shifts the 1st operand right by the value held in the lowest 5 bits of the second operand, filling the lowest bits with the sign bit			
				default: Out=32'bx;
			 endcase			
      end		 
	end	  
endmodule