`timescale 1ns / 1ps

`define ALU_CTRL_WIDTH 5
`define INSTRUCTION_WIDTH 31

//Define the states
`define FETCH 0
`define DECODE 1
`define BRANCH_S 2
`define BCOND1 3
`define JALR_S 4
`define JALR2 5
`define JAL_S 6
`define JAL2 7
`define ALU2PC 8
`define AUIPC_S 9
`define WRITE_BACK 10
`define LUI_S 11
`define STORE_S 12
`define STORE_MEM 13
`define LOAD_S 14
`define LOAD2 15
`define I_TYPE_S 16
`define R_TYPE_S 17

//Define the opcodes for each instruction type
`define LUI 5'b01101
`define AUIPC 5'b00101
`define JAL 5'b11011
`define JALR 5'b11001
`define BRANCH 5'b11000
`define LOAD 5'b00000
`define STORE 5'b01000
`define I_TYPE 5'b00100
`define R_TYPE 5'b01100


module cntl_mc( input [4:0] opcode,
		input [(`INSTRUCTION_WIDTH-1):0] instruction,
		input bcond,
		input clk,
		input rst,
		output reg k,
		output reg i_d_mem,
		output reg mem_r,
		output reg mem_w,
		output reg op1_sel,
		output reg [1:0] op2_sel,
		output reg [1:0] alu_demux,
		output reg wr_reg_mux,
		output reg wr_en,
		output reg load_ir,
		output reg pc_update,
		output reg load_mdr,
		output reg [(`ALU_CTRL_WIDTH-1):0] alu_ctrl,
		output reg [1:0] mem_size
    );
	 
	 integer i;	 
	 
	 
	 reg [12:0] micro_inst [0:17];
	 reg [4:0] state;
	 reg [4:0] next_state;
	 
	initial
		begin
			micro_inst[0]=13'b01000000xx11x;
			micro_inst[1]=13'bxxxxxxxxxxxxx;
			micro_inst[2]=13'bxxx101xxxxx0x;
			micro_inst[3]=13'bxxx010xxxxx1x;
			micro_inst[4]=13'bxxxxxx0101xxx;
			micro_inst[5]=13'bxxx110xxxxx1x;
			micro_inst[6]=13'bxxxxxx0101xxx;
			micro_inst[7]=13'bxxx010xxxxx1x;
			micro_inst[8]=13'bxxxxxx00xxxxx;
			micro_inst[9]=13'bxxx010xxxxx1x;
			micro_inst[10]=13'bxxxxxx0101xxx;
			micro_inst[11]=13'bxxxx10xxxxxxx;
			micro_inst[12]=13'bxxx110xxxxx1x;
			micro_inst[13]=13'b1x1xxx10xxxxx;
			micro_inst[14]=13'bxxx110xxxxx1x;
			micro_inst[15]=13'b11xxxx1011xx1;
			micro_inst[16]=13'bxxx110xxxxx0x;
			micro_inst[17]=13'bxxx101xxxxx0x;
		end
	//initial $readmemb("microinst.txt",micro_inst);

//Assign the state	
	always@(posedge clk)
	begin
		if(rst==1)
			begin
				state<=`FETCH;
				{i_d_mem,mem_r,mem_w,op1_sel,op2_sel,alu_demux,
					wr_reg_mux,wr_en,load_ir,pc_update,load_mdr}<=micro_inst[`FETCH];
			end
		
		else
			begin
				state<=next_state;
				{i_d_mem,mem_r,mem_w,op1_sel,op2_sel,alu_demux,
					wr_reg_mux,wr_en,load_ir,pc_update,load_mdr}<=cntl_sig;
			end
	end
	
	always @(state or bcond)		
		begin
			case(state)			
			`FETCH:begin
			  next_state=`DECODE;
			end
			`DECODE:begin
			     case(instruction[6:2])
			       `BRANCH:begin
			          next_state=`BRANCH_S;								
			        end									  
				
				`JALR:begin
			     	  next_state=`JALR_S;					
				 end
				
				`JAL:begin
				  next_state=`JAL_S;								 
				end
				
				`AUIPC:begin
				  next_state=`AUIPC_S;			 
				end
				
				`LUI:begin
				  next_state=`LUI_S;				 
				end
				
				`STORE:begin
				  next_state=`STORE_S;			 
				end
				
				`LOAD:begin
				  next_state=`LOAD_S;			 
				end
									
				`I_TYPE:begin
				  next_state=`I_TYPE_S;								 
				end
				
				`R_TYPE:begin
				  next_state=`R_TYPE_S;				 
				end	
			     endcase							
			  alu_memory_ctrl(alu_ctrl,mem_size,instruction);
			end
			
			`BRANCH_S:begin
			  if(bcond==0)
			   next_state=`FETCH;
			  else
			   next_state=`BCOND1;							
			 end
			
			`BCOND1:begin
			   next_state=`ALU2PC;
			end
			
			`JALR_S:begin
			   next_state=`JALR2;
			end
			
			`JALR2:begin
			  next_state=`ALU2PC;
			end
			
			`JAL_S:begin
			  next_state=`JAL2;
			end
			
			`JAL2:begin
			  next_state=`ALU2PC;	
			end
			
			`ALU2PC:begin
			   next_state=`FETCH;
			end
			
			`AUIPC_S:begin
			   next_state=`WRITE_BACK;
			end
			
			`WRITE_BACK:begin
			   next_state=`FETCH;
			end
			
			`LUI_S:begin
			   next_state=`WRITE_BACK;
			end
			
			`STORE_S:begin
			  next_state=`STORE_MEM;
			end
			
			`STORE_MEM:begin
			   next_state=`FETCH;
			end
			
			`LOAD_S:begin
			   next_state=`LOAD2;
			end
			
			`LOAD2:begin
			  next_state=`FETCH;
			end
    			
    			`I_TYPE_S:begin
			   next_state=`WRITE_BACK;
			end
			
			`R_TYPE_S:begin
			   next_state=`WRITE_BACK;
			end
			
			default:begin
			  next_state=`FETCH;
			end
			endcase
			
		  cntl_sig=micro_inst[next_state];
			
		end
		
task alu_memory_ctrl(output [4:0]alu_op,[1:0]memory_size,
		     input [(`INSTRUCTION_WIDTH-1):0]inst);
 begin
	if (inst[1:0] == 2'b11) begin
			//determine the type of instruction
			case (inst[6:2])			
				//R-type
				`R_TYPE: begin
					//set the alu_ctrl signal to be the packed version of
					//bit(3) = inst[31] and remaining bits = funct3 field as specified in the ISA
					//bit(3) = 1 distinguishes between SUB and ADD
					//bit(3) = 1 ==> SUB
					//bit(4) = 0 (No branching)
					//ALU control signal
					alu_op = {1'b0,inst[30], inst[14:12]};
					memory_size = 2'bxx;					
				end
				
				//I-type
				`JALR: begin
					//ALU control signal
					//copy the MSB bits of the opcode for JALR to the alu_ctrl signal
					alu_op = inst[6:2];					
					memory_size = 2'bxx;					
				end
									
				`LOAD: begin
					//ALU control signal
					//set the ALU control to add operation
					//The operand obtained from the register is added to the immediate value
					//no branching
					alu_op = {(`ALU_CTRL_WIDTH){1'b0}};
					
					//data memory size
					//size depends on the instruction
					memory_size = inst[13:12];					
				end
				
				`I_TYPE: begin
					
					if(inst[14:12] == 3'b010 || inst[14:12] == 3'b011) begin
						//Instructions that involve subtract operation (SLTI and SLTIU respectively)
						//ALU control signal
						//set LSB 3 bits to the "funct3" field
						//bit 3 = 1'b1 to indicate stubract operation
						//bit 4 = 0 (no branching)
						alu_op = {1'b0, 1'b1, inst[14:12]};
					end
					
					else begin
						//Other ALU instruction
						//ALU control signal
						//set the alu_ctrl signal to {2'b00, "funct3"}
						//bit3 = 1'b0, no subtract operation
						//MSB (bit 4) = 1'b0, no branching
						alu_op = {2'b00, inst[14:12]};
					end		
					
					memory_size = 2'bxx;						
				end	
				
				//S-type
				`STORE: begin
					//ALU control signal
					//set the ALU control signal to add "rs1" to immediate value
					//no subtract
					//no branching
					alu_op = {(`ALU_CTRL_WIDTH){1'b0}};
					//data memory size
					//data is written to data memory
					memory_size = inst[13:12];					
				end
				
				//SB-type
				`BRANCH: begin
					//ALU control signal
					//set the alu_ctrl signal to {1'b1, 1'b0, "funct3"}
					//bit3 = 1'b0, no subtract instructions (I-type)
					//MSB (bit 4) = 1'b1, branch
					alu_op = {1'b1, 1'b0, inst[14:12]};					
					//data memory size
					//data is not written to data memory
					memory_size = 2'bxx;					
				end
				
				//U-type
				`LUI: begin
					//ALU control signal
					//The immediate value is written to rd in case of LUI
					//For AUIPC no ALU operation is to performed. Hence set to 'x'
			
						//ensure that the top two bits of alu_ctrl = 2'b11 to avoid conflict with other instructions
						//set the bottom 3 bits to be 0, to convey that it is the LUI instruction to the ALU					
						alu_op = 5'b11000;
						d_memory_size = 2'bxx;
					end
					
				`AUIPC:begin
						alu_op = {(`ALU_CTRL_WIDTH){1'bx}};
						memory_size = 2'bxx;
				end				
				
				//UJ-type
				`JAL:begin
					//For JAL no ALU operation is to performed. Hence set to 'x'
					alu_op = {(`ALU_CTRL_WIDTH){1'bx}};					
					memory_size = 2'bxx;					
				end			

				//default
				default: begin
					//ALU control signal
					//don't care
					alu_op = {(`ALU_CTRL_WIDTH){1'bx}};					
					memory_size = 2'bxx;					
					end				
			endcase
		end
			
			else begin
				//ALU control signal
				//don't care
				alu_ctrl = {(`ALU_CTRL_WIDTH){1'bx}};			
				//data memory size
				//data is not written to data memory
				//don't care
				d_mem_size = 2'bxx;			
		  end
 end
endtask 



endmodule
