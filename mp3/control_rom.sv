import lc3b_types::*;

module control_rom
(
    input  lc3b_opcode opcode,
    input  lc3b_imm_bit imm,
    input  lc3b_jsr_bit jsr,
    output lc3b_control_word ctrl
);

always_comb begin
    /* Defaults */
    ctrl.opcode = opcode;
    ctrl.aluop = alu_pass;
    ctrl.memmux_sel = memmux_result;
    ctrl.alumux_sel = alumux_sr2;
    ctrl.aluoutmux_sel = aluoutmux_word;
    ctrl.destmux_sel = destmux_dest;
    ctrl.load_cc = 1'b0;
    ctrl.load_regfile = 1'b0;
    ctrl.mem_read = 1'b0;
    ctrl.mem_write = 1'b0;
    ctrl.mem_wmask = 2'b11;

    case(opcode)
        op_add: begin
            if(imm) begin
                ctrl.alumux_sel = alumux_imm5;
            end
            ctrl.aluop = alu_add;
            ctrl.load_cc = 1'b1;
            ctrl.load_regfile = 1'b1;
        end
        op_and: begin
            if(imm) begin
                ctrl.alumux_sel = alumux_imm5;
            end
            ctrl.aluop = alu_and;
            ctrl.load_cc = 1'b1;
            ctrl.load_regfile = 1'b1;
        end
        op_not: begin
            ctrl.aluop = alu_not;
            ctrl.load_cc = 1'b1;
            ctrl.load_regfile = 1'b1;
        end
        op_ldr: begin
            ctrl.aluop = alu_add;
            ctrl.alumux_sel = alumux_adj6;
            ctrl.memmux_sel = memmux_rdata;
            ctrl.load_cc = 1'b1;
            ctrl.load_regfile = 1'b1;
            ctrl.mem_read = 1'b1;
        end
        op_str: begin
            ctrl.aluop = alu_add;
            ctrl.alumux_sel = alumux_adj6;
            ctrl.mem_write = 1'b1;           
        end
        op_br: begin


        end
        default: begin

        end
    endcase
end
endmodule : control_rom
