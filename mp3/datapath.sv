import lc3b_types::*;

module datapath
(
    input logic clk,

    /* Control Signals */
    output lc3b_opcode opcode,
    input lc3b_control_word control_word,

    /* IF Signals */
    output logic          if_read,       // Assign 1
    output logic          if_write,      // Assign 0
    output lc3b_mem_wmask if_wmask,      // Assign 2'b11
    output lc3b_word      if_address,    // PC
    output lc3b_word      if_wdata,      // 16'h0000
    input  logic          if_resp,       // Loads IR
    input  lc3b_word      if_rdata,      // Instruction
    
    /* MEM Signals */
    output logic          mem_read,
    output logic          mem_write,
    output lc3b_mem_wmask mem_wmask,
    output lc3b_word      mem_address,
    output lc3b_word      mem_wdata,
    input  logic          mem_resp,
    input  lc3b_word      mem_rdata
);

    /* control signals */
/**    input logic               load_pc,
    input logic               load_ir,
    input logic               load_regfile,
    input logic               load_mar,
    input logic               load_mdr,
    input logic               load_cc,
    input lc3b_pcmux_sel      pcmux_sel,
    input logic               storemux_sel,
    input lc3b_alumux_sel     alumux_sel,
    input lc3b_regfilemux_sel regfilemux_sel,
    input lc3b_addr2mux_sel   addr2mux_sel,
    input lc3b_addr1mux_sel   addr1mux_sel,
    input lc3b_marmux_sel     marmux_sel,
    input lc3b_mdrmux_sel     mdrmux_sel,
    input lc3b_aluop          aluop,
    input lc3b_destmux_sel    destmux_sel,*/

    /* Input Ports */
/*    input logic clk,
    input lc3b_word mem_rdata,*/
    
    /* Output Ports */
/*    output lc3b_word    mem_address,
    output lc3b_word    mem_wdata,
    output logic        branch_enable,
    output lc3b_opcode  opcode,
    output lc3b_imm_bit imm_bit,
    output lc3b_jsr_bit jsr_bit,
    output lc3b_shift_flags shift_flags*/

/* declare internal signals */
lc3b_reg sr1;
lc3b_reg sr2;
lc3b_reg dest;
lc3b_reg destmux_out;
lc3b_reg storemux_out;
lc3b_word sr1_out;
lc3b_word sr2_out;

lc3b_offset6 offset6;
lc3b_offset9 offset9;
lc3b_offset11 offset11;
lc3b_trapvect8 trapvect8;
lc3b_imm5 imm5;
lc3b_imm4 imm4;
lc3b_word adj6_out;
lc3b_word adj9_out;
lc3b_word adj11_out;
lc3b_word zext8_out;
lc3b_word mdr_zext;
lc3b_word sext5_out;
lc3b_word pcmux_out;
lc3b_word alumux_out;
lc3b_word regfilemux_out;
lc3b_word marmux_out;
lc3b_word mdrmux_out;
lc3b_word alu_out;
lc3b_word pc_out;
lc3b_word br_add_out;
lc3b_word pc_plus2_out;
lc3b_word addr1mux_out;
lc3b_word addr2mux_out;
lc3b_nzp  gencc_out;
lc3b_nzp  cc_out;

// IR Signals for Each Statge
lc3b_ir_signals ir_signals;
lc3b_ir_signals ir_signals_ID;
lc3b_ir_signals ir_signals_EX;
lc3b_ir_signals ir_signals_MEM;
lc3b_ir_signals ir_signals_WB;

// Control Words for Each Statge
lc3b_control_word control_word_ID;
lc3b_control_word control_word_EX;
lc3b_control_word control_word_MEM;
lc3b_control_word control_word_WB;


/* -----------------------------------------------------------
   -----------------------------------------------------------
                       INSTRUCTION FETCH
   -----------------------------------------------------------
   -----------------------------------------------------------*/

/*
 * PC
 */
mux4 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(br_add_out),
    .c(alu_out),
    .d(mem_wdata),
    .f(pcmux_out)
);
register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);
mux4 addr2mux
(
    .sel(addr2mux_sel),
    .a(16'h0000),
    .b(adj6_out),
    .c(adj9_out),
    .d(adj11_out),
    .f(addr2mux_out)
);
mux2 addr1mux
(
    .sel(addr1mux_sel),
    .a(pc_out),
    .b(sr1_out),
    .f(addr1mux_out)
);

always_comb
begin : branch_add
    br_add_out = addr1mux_out + addr2mux_out;
end : branch_add

always_comb
begin : pc_plus_two
    pc_plus2_out = pc_out + 16'h0002;
end : pc_plus_two


/*
 * IR
 */
ir _ir
(
    .clk(clk),
    .load(if_resp),
    .in(if_rdata),
    .opcode(ir_signals.opcode),
    .dest(ir_signals.dest),
    .src1(ir_signals.sr1),
    .src2(ir_signals.sr2),
    .imm_bit(ir_signals.imm_bit),
    .shift_flags(ir_signals.shift_flags),
    .imm4(ir_signals.imm4),
    .jsr_bit(ir_signals.jsr_bit),
    .adj6(ir_signals.adj6),
    .adj9(ir_signals.adj9),
    .adj11(ir_signals.adj11),
    .zext8(ir_signals.zext8),
    .sext5(ir_signals.sext5),
    .mdr_zext(ir_signals.mdr_zext),
);



/* -----------------------------------------------------------
   -----------------------------------------------------------
                       INSTRUCTION DECODE
   -----------------------------------------------------------
   -----------------------------------------------------------*/
/*
 * REG FILE
 */
regfile _regfile
(
    .clk(clk),
    .load(load_regfile),   // WB statge
    .in(regfilemux_out),
    .src_a(storemux_out),
    .src_b(sr2),
    .dest(destmux_out),
    .reg_a(sr1_out),
    .reg_b(sr2_out)
);


/*
 * StoreMux + Destmux
 */
mux2 #(.width(3)) storemux 
(
    .sel(control_word.storemux_sel),
    .a(ir_signals_ID.sr1),
    .b(ir_signals_ID.dest),
    .f(storemux_out)
);
mux2 #(.width(3)) destmux
(
    .sel(control_word.destmux_sel),
    .a(ir_signals_ID.dest),
    .b(3'b111),
    .f(destmux_out)
);


/* Stage Regs */
register #(.width($bits(lc3b_control_word))) control_word_reg_idex
(
    .clk(clk),
    .load(1'b1),
    .in(control_word),
    .out(control_word_EX),
);
register #(.width(16)) source_operand_a_idex
(
    .clk(),
    .load(),
    .in(),
    .out()
);
register #(.width(16)) source_operand_b_idex
(
    .clk(),
    .load(),
    .in(),
    .out()   
);
register #(.width($bits(lc3b_ir_signals))) ir_signals_reg_idex
(
    .clk(),
    .load(),
    .in(),
    .out()
);


/* -----------------------------------------------------------
   -----------------------------------------------------------
                       EXECUTE
   -----------------------------------------------------------
   -----------------------------------------------------------*/
/*
 * ALU
 */
alu _alu
(
    .aluop(aluop),
    .a(sr1_out),
    .b(alumux_out),
    .f(alu_out)
);
mux8 alumux
(
    .sel(alumux_sel),
    .a(sr2_out),
    .b(adj6_out),
    .c(sext5_out),
    .d({10'b0000000000, offset6}),
    .e({12'h000,imm4}),
    .g(16'h0000),
    .h(16'h0000),
    .i(16'h0000),
    .f(alumux_out)
);

/* Stage Regs */
register #(.width($bits(lc3b_control_word))) control_word_reg_exmem
(
    .clk(),
    .load(),
    .in(),
    .out()
);
register #(.width(16)) reg_alu_out
(
    .clk(),
    .load(),
    .in(),
    .out()
);
register #(.width($bits(lc3b_ir_signals))) ir_signals_reg_exmem
(
    .clk(),
    .load(),
    .in(),
    .out()
);

/* -----------------------------------------------------------
   -----------------------------------------------------------
                       MEM
   -----------------------------------------------------------
   -----------------------------------------------------------*/
/*
 * MAR
 */ 
mux4 marmux
(
    .sel(marmux_sel),
    .a(alu_out),
    .b(br_add_out),
    .c(zext8_out),
    .d(mem_wdata),
    .f(marmux_out)
);
register mar
(
    .clk(clk),
    .load(load_mar),
    .in(marmux_out),
    .out(mem_address)
);

/*
 * MDR
 */
mux4 mdrmux
(
    .sel(mdrmux_sel),
    .a(alu_out),
    .b(mem_rdata),
    .c({alu_out[7:0],alu_out[7:0]}),
    .d(16'h0000),
    .f(mdrmux_out)
);
register mdr
(
    .clk(clk),
    .load(load_mdr),
    .in(mdrmux_out),
    .out(mem_wdata)
);


/* Stage Regs */
register #(.width($bits(lc3b_control_word))) control_word_reg_memwb
(
    .clk(),
    .load(),
    .in(),
    .out()
);
register #(.width($bits(lc3b_ir_signals))) ir_signals_reg_memwb
(
    .clk(),
    .load(),
    .in(),
    .out()
);

/* -----------------------------------------------------------
   -----------------------------------------------------------
                       WRITEBACK
   -----------------------------------------------------------
   -----------------------------------------------------------*/




endmodule : datapath
