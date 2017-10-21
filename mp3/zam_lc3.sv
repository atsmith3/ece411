import lc3b_types::*;
import lc3b_ctypes::*;

module zam_lc3
(
    input clk,

    /* Memory signals */
    output logic read_a,
    output logic write_a,
    output lc3b_mem_wmask wmask_a,
    output lc3b_word address_a,
    output lc3b_word wdata_a,
    input resp_a,
    input lc3b_word rdata_a,
    output logic read_b,
    output logic write_b,
    output lc3b_mem_wmask wmask_b,
    output lc3b_word address_b,
    output lc3b_word wdata_b,
    input resp_b,
    input lc3b_word rdata_b
);

lc3b_control_word ccontrol_word;
lc3b_opcode opcode;

/* Control Rom */
control_rom _control_rom
(
    .opcode(opcode),
    .control_word(control_word)
);

/* Datapath */
datapath _datapath
(
    .clk(clk),

    /* Control Signals */
    .opcode(opcode),
    .control_word(control_word),

    /* IF Signals */
    .if_read(read_a),
    .if_write(write_a),
    .if_wmask(wmask_a),
    .if_address(address_a),
    .if_wdata(wdata_a),
    .if_resp(resp_a),
    .if_rdata(rdata_a),
    
    /* MEM Signals */
    .mem_read(read_b),
    .mem_write(write_b),
    .mem_wmask(wmask_b),
    .mem_address(address_b),
    .mem_wdata(wdata_b),
    .mem_resp(resp_b),
    .mem_rdata(rdata_b)
);

endmodule : zam_lc3
