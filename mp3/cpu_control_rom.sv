import lc3b_types::*;
module control_rom
(
    input lc3b_opcode opcode,
    output lc3b_control_word ctrl

);

always_comb
begin
    /* Default assignments */
    ctrl.opcode = opcode;
    ctrl.load_cc = 1’b0;
    /* ... other defaults ... */
    /* Assign control signals based on opcode */
    case(opcode)
        s_add: begin
            ctrl.aluop = alu_add;
            ctrl.load_regfile = 1;
            ctrl.regfilemux_sel = regfilemux_alu;
            ctrl.load_cc = 1;
            if(imm_bit == 1) begin /* Warning, need imm_bit */
                ctrl.alumux_sel = alumux_imm5;
            end
        end
        s_and: begin
            ctrl.aluop = alu_and;
            ctrl.load_regfile = 1;
            ctrl.regfilemux_sel = regfilemux_alu;
            ctrl.load_cc = 1;
            if(imm_bit == 1) begin /* Warning, need imm_bit */
                ctrl.alumux_sel = alumux_imm5;
            end
        end
        s_ldr: begin
            if(opcode == op_ldb || opcode == op_stb) begin
                /* MAR <- A + SEXT(IR[5:0]) */
                ctrl.alumux_sel = alumux_off6;
            end
            else begin
                /* MAR <- A + SEXT(IR[5:0] << 1) */
                ctrl.alumux_sel = alumux_adj6;
            end
            ctrl.aluop = alu_add;
            ctrl.load_mar = 1;
            ctrl.mdrmux_sel = mdrmux_mem_rdata;
            ctrl.load_mdr = 1;
            ctrl.mem_read = 1;
            ctrl.regfilemux_sel = regfilemux_mdr;
            ctrl.load_regfile = 1;
            ctrl.load_cc = 1;
        end
        s_str: begin
            if(opcode == op_ldb || opcode == op_stb) begin
                /* MAR <- A + SEXT(IR[5:0]) */
                ctrl.alumux_sel = alumux_off6;
            end
            else begin
                /* MAR <- A + SEXT(IR[5:0] << 1) */
                ctrl.alumux_sel = alumux_adj6;
            end
            ctrl.aluop = alu_add;
            ctrl.load_mar = 1;
            ctrl.storemux_sel = 1;
            ctrl.aluop = alu_pass;
            ctrl.load_mdr = 1;
            ctrl.mem_write = 1;
        end
        s_not: begin
            ctrl.aluop = alu_not;
            ctrl.load_regfile = 1;
            ctrl.load_cc = 1;
        end
        s_br: begin
            ctrl.aluop = alu_not;
            ctrl.pcmux_sel = pcmux_pcoff;
            ctrl.load_pc = 1;
        end
        s_jmp: begin
            /* CP 2 */
            //ctrl.aluop = alu_pass;
            //ctrl.pcmux_sel = pcmux_databus;
            //ctrl.load_pc = 1;
        end
        s_ldi: begin
            /* CP 2 */
            //ctrl.alumux_sel = 3'b001;
            //ctrl.aluop = alu_add;
            //ctrl.load_mar = 1;
            //ctrl.load_mdr = 1;
            //ctrl.load_regfile = 1;
            //ctrl.load_cc = 1;
            //ctrl.mdrmux_sel = 1;
            //ctrl.mem_read = 1;
            //ctrl.marmux_sel = 2'b10;
            //ctrl.mem_read = 1;
            //ctrl.regfilemux_sel = 3'b001;
        end
        s_lea: begin
            /* CP 2 */
            //if(opcode == op_ldb || opcode == op_stb) begin
                //[> MAR <- A + SEXT(IR[5:0]) <]
                //alumux_sel = alumux_off6;
            //end
            //else begin
                //[> MAR <- A + SEXT(IR[5:0] << 1) <]
                //alumux_sel = alumux_adj6;
            //end
            //aluop = alu_add;
            //load_mar = 1;
        end
        s_ldb: begin
            /* CP 2 */
            //if(opcode == op_ldb || opcode == op_stb) begin
                //[> MAR <- A + SEXT(IR[5:0]) <]
                //alumux_sel = alumux_off6;
            //end
            //else begin
                //[> MAR <- A + SEXT(IR[5:0] << 1) <]
                //alumux_sel = alumux_adj6;
            //end
            //aluop = alu_add;
            //load_mar = 1;
        end
        s_stb: begin
            /* CP 2 */
            //if(opcode == op_ldb || opcode == op_stb) begin
                //[> MAR <- A + SEXT(IR[5:0]) <]
                //alumux_sel = alumux_off6;
            //end
            //else begin
                //[> MAR <- A + SEXT(IR[5:0] << 1) <]
                //alumux_sel = alumux_adj6;
            //end
            //aluop = alu_add;
            //load_mar = 1;
        end
        s_trap: begin
            /* CP 2 */
        end
        s_shf: begin
            /* CP 2 */
        end
        s_jsr: begin
            /* CP 2 */
        end
        s_ind: begin
            /* CP 2 */
        end
        /* ... other opcodes ... */
        default: begin
            ctrl = 0; /* Unknown opcode, set control word to zero */
        end
    endcase
end
endmodule : control_rom
