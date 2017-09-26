import lc3b_types::*;
import lc3b_ctypes::*;

module cache
(
    input logic clk,


    /* CPU Interface */
    input  lc3b_word      mem_address,
    output lc3b_word      mem_rdata,
    input  lc3b_word      mem_wdata,
    input  logic          mem_read,
    input  logic          mem_write,
    input  lc3b_mem_wmask mem_byte_enable,
    output logic          mem_resp,


    /* Memory Interface */
    output lc3b_word      pmem_address,
    input  lc3b_cline     pmem_rdata,
    output lc3b_cline     pmem_wdata,
    output logic          pmem_read,
    output logic          pmem_write,
    input  logic          pmem_resp
);

/* Internal logic signals */


/* Cache Datapath */
cache_datapath c_d_path();

/* Cache Controller */
cache_controller c_controller();

endmodule : cache
