import lc3b_types::*;

module datapath
(
    input logic clk,

    /* Control Signals */
    output lc3b_opcode opcode,
    output lc3b_imm_bit imm,
    output lc3b_jsr_bit jsr,
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

/* declare internal signals */
lc3b_reg destmux_out;
lc3b_word sr1_out, sr2_out;
lc3b_word pcmux_out;
lc3b_word alumux_out;
lc3b_word alu_out;
lc3b_word pc_out;
lc3b_word br_add_out;
lc3b_word pc_plus2_out;
lc3b_word addr1mux_out;
lc3b_word addr2mux_out;
lc3b_nzp  gencc_out;
lc3b_nzp  cc_out;
logic     branch_enable;

// Pipelined Signals:
lc3b_word source_data, source_EX, source_MEM;
lc3b_word operand_a, operand_b;
lc3b_word result_EX, result_MEM;
lc3b_word mem_result, writeback_data;

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

// Load Signals for Each Stage
logic load_ifid;
logic load_idex;
logic load_exmem;
logic load_memwb;


always_comb begin
    // Default:
    load_ifid = 0;
    load_idex = 0;
    load_exmem = 0;
    load_memwb = 0;

    if(if_resp) begin
        load_ifid = 1;
        load_idex = 1;
        load_exmem = 1;
        load_memwb = 1;
    end
end

/* -----------------------------------------------------------
   -----------------------------------------------------------
                       INSTRUCTION FETCH
   -----------------------------------------------------------
   -----------------------------------------------------------*/
/*mux4 pcmux
(
    .sel(1'b0),
    .a(pc_plus2_out),
    .b(br_add_out),
    .c(alu_out),
    .d(mem_wdata),
    .f(pcmux_out)
);*/
register pc
(
    .clk,
    .load(load_ifid),
    .in(pc_plus2_out),
    .out(pc_out)
);
/*
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
end : branch_add*/

always_comb
begin : pc_plus_two
    pc_plus2_out = pc_out + 16'h0002;
end : pc_plus_two

assign if_address = pc_out;
assign if_write = 1'b0;
assign if_read = 1'b1;
assign if_wmask = 2'b11;
assign if_wdata = 16'h0000;
assign opcode = ir_signals.opcode;
assign imm = ir_signals.imm_bit;
assign jsr = ir_signals.jsr_bit;


/*
 * IR
 */
ir _ir
(
    .clk(clk),
    .load(load_ifid),
    .in(if_rdata),
    .opcode(ir_signals.opcode),
    .dest(ir_signals.dest),
    .src1(ir_signals.src1),
    .src2(ir_signals.src2),
    .imm_bit(ir_signals.imm_bit),
    .shift_flags(ir_signals.shift_flags),
    .imm4(ir_signals.imm4),
    .jsr_bit(ir_signals.jsr_bit),
    .offset6(ir_signals.offset6),
    .adj6(ir_signals.adj6),
    .adj9(ir_signals.adj9),
    .adj11(ir_signals.adj11),
    .zext8(ir_signals.zext8),
    .sext5(ir_signals.sext5)
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
    .load(control_word_WB.load_regfile),   // WB statge
    .in(writeback_data),
    .src_a(ir_signals.src1),
    .src_b(ir_signals.src2),
    .dest(destmux_out),
    .source_idx(ir_signals.dest),
    .source_data(source_data),
    .reg_a(sr1_out),
    .reg_b(sr2_out)
);



mux2 #(.width(3)) destmux
(
    .sel(control_word_WB.destmux_sel),
    .a(ir_signals_WB.dest),
    .b(3'b111),
    .f(destmux_out)
);


/* Stage Regs */
register #(.width($bits(lc3b_control_word))) control_word_reg_idex
(
    .clk(clk),
    .load(load_idex),
    .in(control_word),
    .out(control_word_EX)
);
register #(.width(16)) source_operand_a_idex
(
    .clk(clk),
    .load(load_idex),
    .in(sr1_out),
    .out(operand_a)
);
register #(.width(16)) source_operand_b_idex
(
    .clk(clk),
    .load(load_idex),
    .in(sr2_out),
    .out(operand_b)   
);
register #(.width(16)) source_reg_idex
(
    .clk(clk),
    .load(load_idex),
    .in(source_data),
    .out(source_EX)
);
register #(.width($bits(lc3b_ir_signals))) ir_signals_reg_idex
(
    .clk(clk),
    .load(load_idex),
    .in(ir_signals),
    .out(ir_signals_EX)
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
    .aluop(control_word_EX.aluop),
    .a(operand_a),
    .b(alumux_out),
    .f(alu_out)
);
mux8 alumux
(
    .sel(control_word_EX.alumux_sel),
    .a(operand_b),
    .b(ir_signals_EX.adj6),
    .c(ir_signals_EX.sext5),
    .d(ir_signals_EX.offset6),
    .e(ir_signals_EX.imm4),
    .g(16'h0000),
    .h(16'h0000),
    .i(16'h0000),
    .f(alumux_out)
);
mux2 #(.width(16)) aluout_mux_exmem
(
    .sel(control_word_EX.aluoutmux_sel),
    .a(alu_out),
    .b({alu_out[7:0],alu_out[7:0]}),
    .f(result_EX)
);

/* Stage Regs */
register #(.width($bits(lc3b_control_word))) control_word_reg_exmem
(
    .clk(clk),
    .load(load_exmem),
    .in(control_word_EX),
    .out(control_word_MEM)
);
register #(.width(16)) alu_result_exmem
(
    .clk(clk),
    .load(load_exmem),
    .in(result_EX),
    .out(result_MEM)
);
register #(.width(16)) source_data_exmem
(
    .clk(clk),
    .load(alu_out),
    .in(source_EX),
    .out(source_MEM)
);
register #(.width($bits(lc3b_ir_signals))) ir_signals_reg_exmem
(
    .clk(clk),
    .load(load_exmem),
    .in(ir_signals_EX),
    .out(ir_signals_MEM)
);

/* -----------------------------------------------------------
   -----------------------------------------------------------
                       MEM
   -----------------------------------------------------------
   -----------------------------------------------------------*/

assign mem_address = result_MEM;
assign mem_wdata = source_MEM;
assign mem_write = control_word_MEM.mem_write;
assign mem_read = control_word_MEM.mem_read;
assign mem_wmask = control_word_MEM.mem_wmask;

mux4 #(.width(16)) memmux
(
    .sel(control_word_MEM.memmux_sel),
    .a(result_MEM),
    .b(mem_rdata),
    .c({8'h00, mem_rdata[7:0]}),
    .d(16'h0000),
    .f(mem_result)
);


/* Stage Regs */
register #(.width($bits(lc3b_control_word))) control_word_reg_memwb
(
    .clk(clk),
    .load(load_memwb),
    .in(control_word_MEM),
    .out(control_word_WB)
);
register #(.width(16)) mem_result_memwb
(
    .clk(clk),
    .load(load_memwb),
    .in(mem_result),
    .out(writeback_data)
);
register #(.width($bits(lc3b_ir_signals))) ir_signals_reg_memwb
(
    .clk(clk),
    .load(load_memwb),
    .in(ir_signals_MEM),
    .out(ir_signals_WB)
);

/* -----------------------------------------------------------
   -----------------------------------------------------------
                       WRITEBACK
   -----------------------------------------------------------
   -----------------------------------------------------------*/

/*
 * CC
 */
gencc _gencc
(
    .in(writeback_data),
    .out(gencc_out)
);
register #(.width(3)) cc
(
    .clk(clk),
    .load(control_word_WB.load_cc),
    .in(gencc_out),
    .out(cc_out)
);

always_comb
begin : CCCOMP
    if((cc_out[2] == 1'b1 && ir_signals.dest[2] == 1'b1) || 
       (cc_out[1] == 1'b1 && ir_signals.dest[1] == 1'b1) || 
       (cc_out[0] == 1'b1 && ir_signals.dest[0] == 1'b1)) branch_enable = 1;
    else branch_enable = 0;
end : CCCOMP

endmodule : datapath
