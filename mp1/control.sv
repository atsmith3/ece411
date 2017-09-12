import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
    input clk,
	 
    /* Datapath controls */
    input lc3b_opcode          opcode,
    input logic                branch_enable,
    input lc3b_imm_bit         imm_bit,
    input lc3b_jsr_bit         jsr_bit,
    input lc3b_shift_flags     shift_flags,
    output lc3b_destmux_sel    destmux_sel,
    output logic               load_pc,
    output logic               load_ir,
    output logic               load_regfile,
    output logic               load_mar,
    output logic               load_mdr,
    output logic               load_cc,
    output lc3b_pcmux_sel      pcmux_sel,
    output logic               storemux_sel,
    output lc3b_alumux_sel     alumux_sel,
    output lc3b_regfilemux_sel regfilemux_sel,
    output lc3b_addr2mux_sel   addr2mux_sel,
    output lc3b_marmux_sel     marmux_sel,
    output logic               mdrmux_sel,
    output lc3b_aluop          aluop,
    output lc3b_addr1mux_sel   addr1mux_sel,
 
    /* Memory signals */
    input mem_resp,
    output logic          mem_read,
    output logic          mem_write,
    output lc3b_mem_wmask mem_byte_enable
);

enum int unsigned {
    fetch1,
    fetch2,
    fetch3,
    decode,
    s_br,
    s_br_taken,
    s_add,
    s_and,
    s_calc_addr,
    s_ldr1,
    s_ldr2,
    s_str1,
    s_str2,
    s_not,
    s_jmp,
    s_lea,
    s_ldb1,
    s_ldb2,
    s_stb1,
    s_stb2,
    s_trap1,
    s_trap2,
    s_trap3,
    s_trap4,
    s_shf,
    s_jsr1,
    s_jsr2,
    s_ind1,
    s_ind2,
    INVALID_OPCODE,
    INVALID_STATE
} state, next_state;

always_comb
begin : state_actions
    /* Default output assignments */
    load_pc = 1'b0;
    load_ir = 1'b0;
    load_regfile = 1'b0;
    load_mar = 1'b0;
    load_mdr = 1'b0;
    load_cc = 1'b0;
    pcmux_sel = pcmux_pc2;
    storemux_sel = 1'b0;
    alumux_sel = alumux_sr2;
    regfilemux_sel = regfilemux_alu;
    marmux_sel = marmux_alu;
    mdrmux_sel = 1'b0;
    aluop = alu_add;
    mem_read = 1'b0;
    mem_write = 1'b0;
    mem_byte_enable = 2'b11;
    addr2mux_sel = addr2mux_adj9;    
    addr1mux_sel = addr1mux_pc;
    destmux_sel = destmux_dest;

    /* Actions for each state */
    case(state)
        fetch1: begin
            /* MAR <= PC */
            marmux_sel = marmux_pcoff;
            addr1mux = addr1mux_pc;
            addr2mux = addr2mux_zero;
            load_mar = 1;

            /* PC <= PC + 2 */
            pcmux_sel = pcmux_pc2;
            load_pc = 1;
        end
        fetch2: begin
            /* Read memory */
            mem_read = 1;
            mdrmux_sel = 1;
            load_mdr = 1;
        end
        fetch3: begin
            /* Load IR */
            load_ir = 1;
        end
        decode: /* Do nothing */;
        s_add: begin
            aluop = alu_add;
            load_regfile = 1;
            regfilemux_sel = regfilemux_alu;
            load_cc = 1;
            if(imm_bit == 1) begin
                alumux_sel = alumux_imm5;
            end
        end
        s_and: begin
            aluop = alu_and;
            load_regfile = 1;
            regfilemux_sel = regfilemux_alu;
            load_cc = 1;
            if(imm_bit == 1) begin
                alumux_sel = alumux_imm5;
            end
        end
        s_not: begin
            /* DR <- NOT(SRA) */
            aluop = alu_not;
            load_regfile = 1;
            load_cc = 1;
        end
        s_br: /* Do Nothing */;
        s_br_taken: begin
            /* PC <- PC + SEXT(IR[8:0] << 1) */
            pcmux_sel = pcmux_pcoff;
            load_pc = 1;
        end
        s_calc_addr: begin
            if(opcode == op_ldb || opcode == op_stb) begin
                /* MAR <- A + SEXT(IR[5:0]) */
                alumux_sel = alumux_off6;
            end
            else begin
                /* MAR <- A + SEXT(IR[5:0] << 1) */
                alumux_sel = alumux_adj6;
            end
            aluop = alu_add;
            load_mar = 1;
        end
        s_ldr1: begin
            /* MDR <- M[MAR] */
            mdrmux_sel = 1;
            load_mdr = 1;
            mem_read = 1;
        end
        s_ldr2: begin
            /* DR <- MDR */
            regfilemux_sel = regfilemux_mdr;
            load_regfile = 1;
            load_cc = 1;
        end
        s_str1: begin
            /* MDR <- SR */
            storemux_sel = 1;
            aluop = alu_pass;
            load_mdr = 1;
        end
        s_str2: begin
            /* M[MAR] <- MDR */
            mem_write = 1;
        end
        s_jmp: begin
            /* PC <= BaseR */
            aluop = alu_pass;
            pcmux_sel = pcmux_databus;
            load_pc = 1;
        end
        s_lea: begin
            /* DR <= PC + sext(PCoffset9), setcc */
            regfilemux_sel = regfilemux_pcoff;
            load_regfile = 1;
        end
        s_ldb1: begin
            /* MDR <- M[MAR] */
            mdrmux_sel = 1;
            mem_byte_enable = 2'b01;
            load_mdr = 1;
            mem_read = 1;
        end
        s_ldb2: begin
            /* DR <- ZEXT(MDR) */
            regfilemux_sel = regfilemux_mdr_zext;
            load_regfile = 1;
            load_cc = 1;
        end
        s_stb1: begin
            /* MDR <- SR */
            storemux_sel = 1;
            aluop = alu_pass;
            load_mdr = 1;
        end
        s_stb2: begin
            mem_write = 1;
            mem_byte_enable = 2'b01;
        end
        s_trap1: begin
            /* R7 <- PC */
            addr2mux_sel = addr2mux_zero;
            addr1mux_sel = addr1mux_pc;
            regfilemux_sel = regfilemux_pcoff;
            destmux_sel = destmux_r7;
            load_regfile = 1;
        end
        s_trap2: begin
            /* MAR <- ZEXT(trapvect8) << 1) */
            marmux_sel = marmux_zext8;
            load_mar = 1;
        end
        s_trap3: begin
            /* MDR <- M[MAR] */
            mem_read = 1;
            mdrmux_sel = 1;
            load_mdr = 1;
        end
        s_trap4: begin
            /* PC <- MDR */
            pcmux_sel = pcmux_mdr;
            load_pc = 1;
        end
        s_shf: begin
            /* DR <- SR << or >> imm4 */
            if(shift_flags[0] == 0) begin
                aluop = alu_sll;
            end
            else begin
                if(shift_flags[1] == 0) begin
                    /* Shift right logic */
                    aluop = alu_srl;
                end
                else begin
                    /* Shift right signed */
                    aluop = alu_sra;
                end
            end
            load_regfile = 1;
            alumux_sel = alumux_imm4;
            regfilemux_sel = regfilemux_alu;
            load_cc = 1;
        end
        s_jsr1: begin
            /* R7 <- PC */
            addr1mux_sel = addr1mux_pc;
            addr2mux_sel = addr2mux_zero;
            regfilemux_sel = regfilemux_pcoff;
            load_regfile = 1;
            destmux_sel = destmux_r7;
        end
        s_jsr2: begin
            if(jsr_bit == 1) begin
                /* PC <- PC + SEXT(PCoffset11) << 1) */
                addr1mux_sel = addr1mux_pc;
                addr2mux_sel = addr2mux_adj11;
            end
            else begin
                /* PC <- BaseR */
                addr1mux_sel = addr1mux_sr1;
                addr2mux_sel = addr2mux_zero; 
            end
            load_pc = 1;
        end
        s_ind1: begin
            /* MDR <- M[MAR] */
            mdrmux_sel = 1;
            load_mdr = 1;
            mem_read = 1;
        end
        s_ind2: begin
            /* MAR <- MDR */
            marmux_sel = marmux_mdr;
            load_mar = 1;
        end
        default: /* Do nothing */;
    endcase
end

always_comb
begin : next_state_logic
    /* Next state information and conditions (if any)
     * for transitioning between states */
    case(state)
        fetch1: begin
            next_state = fetch2;
        end
        fetch2: begin
            if(mem_resp == 0) next_state = fetch2;
            else next_state = fetch3;
        end
        fetch3: begin
            next_state = decode;
        end
        decode: begin
            /* next state is dependent on the opcode */
            case(opcode)
                op_br:   next_state = s_br;
                op_add:  next_state = s_add;
                op_and:  next_state = s_and;
                op_ldr:  next_state = s_calc_addr;
                op_str:  next_state = s_calc_addr;
                op_ldi:  next_state = s_calc_addr;
                op_sti:  next_state = s_calc_addr;
                op_ldb:  next_state = s_calc_addr;
                op_stb:  next_state = s_calc_addr;
                op_shf:  next_state = s_shf;
                op_trap: next_state = s_trap1;
                op_jsr:  next_state = s_jsr1;
                op_not:  next_state = s_not;
                op_jmp:  next_state = s_jmp;
                op_lea:  next_state = s_lea;
                default: next_state = INVALID_OPCODE;
            endcase
        end
        s_calc_addr: begin 
            case(opcode)
                op_ldr:  next_state = s_ldr1;
                op_str:  next_state = s_str1;
                op_ldi:  next_state = s_ind1;
                op_sti:  next_state = s_ind1;
                op_ldb:  next_state = s_ldb1;
                op_stb:  next_state = s_stb1;
                default: next_state = INVALID_STATE;
            endcase
        end
        s_br: begin
            if(branch_enable == 1) next_state = s_br_taken;
            else next_state = fetch1;
        end
        s_br_taken: begin
            next_state = fetch1;
        end
        s_add: begin
            next_state = fetch1;
        end
        s_and: begin
            next_state = fetch1;
        end
        s_ldr1: begin
            if(mem_resp == 0) next_state = s_ldr1;
            else next_state = s_ldr2;
        end
        s_ldr2: begin
            next_state = fetch1;
        end
        s_str1: begin
            next_state = s_str2;
        end
        s_str2: begin
            if(mem_resp == 0) next_state = s_str2;
            else next_state = fetch1;
        end
        s_not: begin
            next_state = fetch1;
        end
        s_jmp: begin
            next_state = fetch1;
        end
        s_lea: begin
            next_state = fetch1;
        end
        s_ldb1: begin
            if(mem_resp == 0) next_state = s_ldb1;
            else next_state = s_ldb2;
        end
        s_ldb2: begin
            next_state = fetch1;
        end
        s_stb1: begin
            next_state = s_stb2;
        end
        s_stb2: begin
            if(mem_resp == 0) next_state = s_stb2;
            else next_state = fetch1;
        end
        s_trap1: begin
            next_state = s_trap2;
        end
        s_trap2: begin
            next_state = s_trap3;
        end
        s_trap3: begin
            if(mem_resp == 0) next_state = s_trap3;
            else next_state = s_trap4;
        end
        s_trap4: begin
            next_state = fetch1;
        end
        s_shf: begin
            next_state = fetch1;
        end
        s_jsr1: begin
            next_state = s_jsr2;
        end
        s_jsr2: begin
            next_state = fetch1;
        end
        s_ind1: begin
            if(mem_resp == 0) next_state = s_ind1;
            else next_state = s_ind2;
        end
        s_ind2: begin
            if(opcode == op_sti) next_state = s_str;
            else next_state == s_ldr;
        end
        INVALID_OPCODE: begin
            next_state = INVALID_OPCODE;
        end
        INVALID_STATE: begin
            next_state = INVALID_STATE;
        end
        default: begin
            next_state = INVALID_STATE;
        end
    endcase
end

always_ff @(posedge clk)
begin: next_state_assignment
    state <= next_state;
end

endmodule : control
