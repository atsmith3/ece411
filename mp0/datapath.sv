import lc3b_types::*;

module datapath
(
    /* control signals */
    input logic load_pc,
    input logic load_ir,
    input logic load_regfile,
    input logic load_mar,
    input logic load_mdr,
    input logic load_cc,
    input logic pcmux_sel,
    input logic storemux_sel,
    input logic alumux_sel,
    input logic regfilemux_sel,
    input logic marmux_sel,
    input logic mdrmux_sel,
    input lc3b_aluop aluop,

    /* Input Ports */
    input logic clk,
    input lc3b_word mem_rdata,
    
    /* Output Ports */
    output lc3b_word   mem_address,
    output lc3b_word   mem_wdata,
    output logic       branch_enable,
    output lc3b_opcode opcode
);

/* declare internal signals */
lc3b_reg sr1;
lc3b_reg sr2;
lc3b_reg dest; 
lc3b_reg storemux_out;
lc3b_word sr1_out;
lc3b_word sr2_out;

lc3b_offset6 offset6;
lc3b_offset9 offset9;
lc3b_word adj6_out;
lc3b_word adj9_out;
lc3b_word pcmux_out;
lc3b_word alumux_out;
lc3b_word regfilemux_out;
lc3b_word marmux_out;
lc3b_word mdrmux_out;
lc3b_word alu_out;
lc3b_word pc_out;
lc3b_word br_add_out;
lc3b_word pc_plus2_out;
lc3b_nzp  gencc_out;
lc3b_nzp  cc_out;


/*
 * PC
 */
mux2 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(br_add_out),
    .f(pcmux_out)
);

register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

always_comb
begin : branch_add
    br_add_out = pc_out + adj9_out;
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
    .load(load_ir),
    .in(mem_wdata),
    .opcode(opcode),
    .dest(dest),
    .src1(sr1),
    .src2(sr2),
    .offset6(offset6),
    .offset9(offset9)
);


/*
 * ADJ
 */
adj #(.width(6)) _adj6
(
    .in(offset6),
    .out(adj6_out)
);
adj #(.width(9)) _adj9
(
    .in(offset9),
    .out(adj9_out)
);


/*
 * REG FILE
 */
regfile _regfile
(
    .clk(clk),
    .load(load_regfile),
    .in(regfilemux_out),
    .src_a(sr1),
    .src_b(sr2),
    .dest(dest),
    .reg_a(sr1_out),
    .reg_b(sr2_out)
);


/*
 * StoreMux
 */
mux2 #(.width(3)) storemux 
(
    .sel(storemux_sel),
    .a(sr1),
    .b(dest),
    .f(storemux_out)
);


/*
 * MAR
 */ 
mux2 marmux
(
    .sel(marmux_sel),
    .a(alu_out),
    .b(pc_out),
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
mux2 mdrmux
(
    .sel(mdrmux_sel),
    .a(alu_out),
    .b(mem_rdata),
    .f(mdrmux_out)
);
register mdr
(
    .clk(clk),
    .load(load_mdr),
    .in(mdrmux_out),
    .out(mem_wdata)
);


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
mux2 alumux
(
    .sel(alumux_sel),
    .a(sr2_out),
    .b(adj6_out),
    .f(alumux_out)
);


/*
 * CC
 */
gencc _gencc
(
    .in(regfilemux_out),
    .out(gencc_out)
);
register cc
(
    .clk(clk),
    .load(load_cc),
    .in(gencc_out),
    .out(cc_out)
);
mux2 regfilemux
(
    .sel(regfilemux_sel),
    .a(alu_out),
    .b(mem_wdata),
    .f(regfilemux_out)
);
always_comb
begin : CCCOMP
    if(cc_out == dest) branch_enable = 1;
    else branch_enable = 0;
end : CCCOMP

endmodule : datapath
