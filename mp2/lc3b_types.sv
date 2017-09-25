package lc3b_types;

typedef logic [15:0] lc3b_word;
typedef logic  [7:0] lc3b_byte;

typedef logic  [4:0] lc3b_imm5;
typedef logic  [1:0] lc3b_shift_flags;
typedef logic  [3:0] lc3b_imm4;

typedef logic [10:0] lc3b_offset11;
typedef logic  [8:0] lc3b_offset9;
typedef logic  [5:0] lc3b_offset6;

typedef logic lc3b_imm_bit;
typedef logic lc3b_jsr_bit;

typedef logic  [7:0] lc3b_trapvect8;

typedef logic  [2:0] lc3b_reg;
typedef logic  [2:0] lc3b_nzp;
typedef logic  [1:0] lc3b_mem_wmask;

typedef enum bit [3:0] {
    op_add  = 4'b0001,
    op_and  = 4'b0101,
    op_br   = 4'b0000,
    op_jmp  = 4'b1100,   /* also RET */
    op_jsr  = 4'b0100,   /* also JSRR */
    op_ldb  = 4'b0010,
    op_ldi  = 4'b1010,
    op_ldr  = 4'b0110,
    op_lea  = 4'b1110,
    op_not  = 4'b1001,
    op_rti  = 4'b1000,
    op_shf  = 4'b1101,
    op_stb  = 4'b0011,
    op_sti  = 4'b1011,
    op_str  = 4'b0111,
    op_trap = 4'b1111
} lc3b_opcode;

typedef enum bit [1:0] {
    marmux_alu,
    marmux_pcoff,
    marmux_zext8,
    marmux_mdr
} lc3b_marmux_sel;

typedef enum bit [3:0] {
    alu_add,
    alu_and,
    alu_not,
    alu_pass,
    alu_sll,
    alu_srl,
    alu_sra
} lc3b_aluop;

typedef enum bit [2:0] {
    alumux_sr2,
    alumux_adj6,
    alumux_imm5,
    alumux_off6,
    alumux_imm4
} lc3b_alumux_sel;

typedef enum bit [1:0] {
    regfilemux_alu,
    regfilemux_mdr,
    regfilemux_pcoff,
    regfilemux_mdr_zext
} lc3b_regfilemux_sel;

typedef enum bit [1:0] {
    pcmux_pc2,
    pcmux_pcoff,
    pcmux_databus,
    pcmux_mdr
} lc3b_pcmux_sel;

typedef enum bit [1:0] {
    addr2mux_zero,
    addr2mux_adj6,
    addr2mux_adj9,
    addr2mux_adj11
} lc3b_addr2mux_sel;

typedef enum bit {
    addr1mux_pc,
    addr1mux_sr1
} lc3b_addr1mux_sel;

typedef enum bit {
    destmux_dest,
    destmux_r7
} lc3b_destmux_sel;

typedef enum bit [1:0] {
    mdrmux_alu,
    mdrmux_mem_rdata,
    mdrmux_alu_byte
} lc3b_mdrmux_sel;
endpackage : lc3b_types
