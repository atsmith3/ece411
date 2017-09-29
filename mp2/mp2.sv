import lc3b_types::*;

module mp2
(
    input clk,

    /* Memory signals */
    input mem_resp,
    input lc3b_word mem_rdata,
    output mem_read,
    output mem_write,
    output lc3b_mem_wmask mem_byte_enable,
    output lc3b_word mem_address,
    output lc3b_word mem_wdata
);

lc3b_opcode         opcode;
logic               branch_enable;
logic               load_pc;
logic               load_ir;
logic               load_regfile;
logic               load_mar;
logic               load_mdr;
logic               load_cc;
lc3b_pcmux_sel      pcmux_sel;
logic               storemux_sel;
lc3b_alumux_sel     alumux_sel;
lc3b_regfilemux_sel regfilemux_sel;
lc3b_addr2mux_sel   addr2mux_sel;
lc3b_addr1mux_sel   addr1mux_sel;
lc3b_marmux_sel     marmux_sel;
lc3b_mdrmux_sel     mdrmux_sel;
lc3b_aluop          aluop;
lc3b_imm_bit        imm_bit;
lc3b_jsr_bit        jsr_bit;
lc3b_destmux_sel    destmux_sel;
lc3b_shift_flags    shift_flags;

control _control
(
    .clk(clk),
	 
    /* Datapath controls */
    .opcode(opcode),
    .branch_enable(branch_enable),
    .load_pc(load_pc),
    .load_ir(load_ir),
    .load_regfile(load_regfile),
    .load_mar(load_mar),
    .load_mdr(load_mdr),
    .load_cc(load_cc),
    .pcmux_sel(pcmux_sel),
    .storemux_sel(storemux_sel),
    .alumux_sel(alumux_sel),
    .regfilemux_sel(regfilemux_sel),
    .marmux_sel(marmux_sel),
    .mdrmux_sel(mdrmux_sel),
    .addr2mux_sel(addr2mux_sel),
    .addr1mux_sel(addr1mux_sel),
    .aluop(aluop),
    .imm_bit(imm_bit),
    .jsr_bit(jsr_bit),
    .shift_flags(shift_flags),
    .destmux_sel(destmux_sel),
 
    /* Memory signals */
    .mem_address(mem_address),
    .mem_resp(mem_resp),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_byte_enable(mem_byte_enable)
);

datapath _datapath
(
    /* control signals */
    .load_pc(load_pc),
    .load_ir(load_ir),
    .load_regfile(load_regfile),
    .load_mar(load_mar),
    .load_mdr(load_mdr),
    .load_cc(load_cc),
    .pcmux_sel(pcmux_sel),
    .storemux_sel(storemux_sel),
    .alumux_sel(alumux_sel),
    .regfilemux_sel(regfilemux_sel),
    .marmux_sel(marmux_sel),
    .mdrmux_sel(mdrmux_sel),
    .aluop(aluop),
    .addr2mux_sel(addr2mux_sel),
    .addr1mux_sel(addr1mux_sel),
    .imm_bit(imm_bit),
    .destmux_sel(destmux_sel),

    /* Input Ports */
    .clk(clk),
    .mem_rdata(mem_rdata),
    
    /* Output Ports */
    .mem_address(mem_address),
    .mem_wdata(mem_wdata),
    .branch_enable(branch_enable),
    .opcode(opcode),
    .jsr_bit(jsr_bit),
    .shift_flags(shift_flags)
);

endmodule : mp2