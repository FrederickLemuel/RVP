`timescale 1ns / 1ps

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
`define LOAD_WRITE 16
`define I_TYPE_S 17
`define R_TYPE_S 18

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
		input bcond,
		input clk,
		input rst,
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
		output reg [4:0] current_state
    );
	 
	 integer i;	 
	 reg [4:0] states[0:18];
	 reg [4:0] state_trans[0:4];
	 reg [2:0] cnt=0;
	 reg[2:0] no_states;
	 reg [12:0] cntl_sig;
	 
	 reg [12:0] micro_inst [0:18];
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
			micro_inst[15]=13'b11xxxx10xxxx1;
			micro_inst[16]=13'bxxxxxxxx1xxxx;
			micro_inst[17]=13'bxxx110xxxxx0x;
			micro_inst[18]=13'bxxx101xxxxx0x;
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
						 case(opcode)
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
						next_state=`LOAD_WRITE;
					 end
			`LOAD_WRITE:begin
							  next_state=`FETCH;
							end
			`I_TYPE_S:begin
						 next_state=`WRITE_BACK;
					  end
			`R_TYPE_S:begin
						 next_state=`WRITE_BACK;
					  end
			default:begin
					  end
					  
			endcase
			
			cntl_sig=micro_inst[next_state];
			
		end

endmodule
