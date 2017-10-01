import lc3b_types::*;
import lc3b_ctypes::*;

module mp2
(
    input clk,

    /* Memory signals */
    input pmem_resp,
    input lc3b_cline pmem_rdata,
    output pmem_read,
    output pmem_write,
    output lc3b_word pmem_address,
    output lc3b_cline pmem_wdata
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

/* Memory Signals */
lc3b_mem_wmask      mem_byte_enable;
lc3b_word           mem_rdata, mem_wdata;
lc3b_word           mem_address;
logic               mem_read;
logic               mem_write;
logic               mem_resp;

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

/* 2 way set associative cache */
cache _cache
(
    .clk(clk),
 
    /* CPU Interface */
    .mem_address(mem_address),
    .mem_rdata(mem_rdata),
    .mem_wdata(mem_wdata),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_byte_enable(mem_byte_enable),
    .mem_resp(mem_resp),

    /* Memory Interface */
    .pmem_address(pmem_address),
    .pmem_rdata(pmem_rdata),
    .pmem_wdata(pmem_wdata),
    .pmem_read(pmem_read),
    .pmem_write(pmem_write),
    .pmem_resp(pmem_resp)
);

endmodule : mp2
