import lc3b_types::*;
import lc3b_ctypes::*;

module zam_lc3
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

/* Control Rom */
control_rom _control_rom
(
    .opcode(),
    .control_word()
);

/* Datapath */
datapath _datapath
(
    .clk(clk),

    /* Control Signals */

    /* IF Signals */
    .read_a(read_a),
    .write_a(write_a),
    .wmask_a(wmask_a),
    .address_a(address_a),
    .wdata_a(wdata_a),
    .resp
    
    
    /* MEM Signals */

);

endmodule : zam_lc3
