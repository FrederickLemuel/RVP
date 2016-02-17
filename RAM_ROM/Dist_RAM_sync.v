`define MEM_SIZE 32
`define MEM_DEPTH 32

module Dist_RAM_sync(
  a,
  d,
  clk,
  we,
  qspo_ce,
  qspo_srst,
  qspo
);

input [5 : 0] a;
input [(`MEM_SIZE-1) : 0] d;
input clk;
input we;
input qspo_ce;
input qspo_srst;
output [(`MEM_SIZE-1) : 0] qspo;

// synthesis translate_off

  DIST_MEM_GEN_V7_2 #(
    .C_ADDR_WIDTH(6),
    .C_DEFAULT_DATA("0"),
    .C_DEPTH(`MEM_DEPTH),
    .C_FAMILY("spartan6"),
    .C_HAS_CLK(1),
    .C_HAS_D(1),
    .C_HAS_DPO(0),
    .C_HAS_DPRA(0),
    .C_HAS_I_CE(0),
    .C_HAS_QDPO(0),
    .C_HAS_QDPO_CE(0),
    .C_HAS_QDPO_CLK(0),
    .C_HAS_QDPO_RST(0),
    .C_HAS_QDPO_SRST(0),
    .C_HAS_QSPO(1),
    .C_HAS_QSPO_CE(1),
    .C_HAS_QSPO_RST(0),
    .C_HAS_QSPO_SRST(1),
    .C_HAS_SPO(0),
    .C_HAS_SPRA(0),
    .C_HAS_WE(1),
    .C_MEM_INIT_FILE("no_coe_file_loaded"),
    .C_MEM_TYPE(1),
    .C_PARSER_TYPE(1),
    .C_PIPELINE_STAGES(0),
    .C_QCE_JOINED(0),
    .C_QUALIFY_WE(0),
    .C_READ_MIF(0),
    .C_REG_A_D_INPUTS(0),
    .C_REG_DPRA_INPUT(0),
    .C_SYNC_ENABLE(1),
    .C_WIDTH(`MEM_SIZE)
  )
  inst (
    .A(a),
    .D(d),
    .CLK(clk),
    .WE(we),
    .QSPO_CE(qspo_ce),
    .QSPO_SRST(qspo_srst),
    .QSPO(qspo),
    .DPRA(),
    .SPRA(),
    .I_CE(),
    .QDPO_CE(),
    .QDPO_CLK(),
    .QSPO_RST(),
    .QDPO_RST(),
    .QDPO_SRST(),
    .SPO(),
    .DPO(),
    .QDPO()
  );

// synthesis translate_on

endmodule
