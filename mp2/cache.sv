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
lc3b_ctag             cache_tag;
lc3b_coffset          cache_offset;
lc3b_cindex           cache_index;
lc3b_cache_inmux_sel  inmux_sel;
lc3b_cache_hitmux_sel hitmux_sel;
logic                 data0_write, data1_write;
logic                 tag0_write, tag1_write;
logic                 dirty0_write, dirty1_write;
logic                 valid0_write, valid1_write;
logic                 lru_write;
logic                 lru_bit, valid_bit, dirty_bit;
logic                 lru_out;
lc3b_ctag             tag_out0, tag_out1;
logic                 dirty_out0, dirty_out1;
logic                 valid_out0, valid_out1;
logic                 hit0, hit1;

/* Cache Datapath */
cache_datapath c_d_path
(
    .clk(clk),

    .cache_tag(cache_tag),
    .cache_index(cache_index),
    .cache_offset(cache_offset),
    .inmux_sel(inmux_sel),
    .hitmux_sel(hitmux_sel),
    .data0_write(data0_write),
    .data1_write(data1_write),
    .tag0_write(tag0_write),
    .tag1_write(tag1_write),
    .dirty0_write(dirty0_write),
    .dirty1_write(dirty1_write),
    .valid0_write(valid0_write),
    .valid1_write(valid1_write),
    .lru_write(lru_write),

    .lru_bit(lru_bit),
    .valid_bit(valid_bit),
    .dirty_bit(dirty_bit),
    
    .lru_out(lru_out),
    .dirty_out0(dirty_out0),
    .dirty_out1(dirty_out1),
    .valid_out0(valid_out0),
    .valid_out1(valid_out1),
    .tag_out0(tag_out0),
    .tag_out1(tag_out1),
    .hit0(hit0),
    .hit1(hit1),
    
    .mem_address(mem_address),
    .mem_rdata(mem_rdata),
    .mem_wdata(mem_wdata),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_byte_enable(mem_byte_enable),

    .pmem_address(pmem_address),
    .pmem_rdata(pmem_rdata),
    .pmem_wdata(pmem_wdata),
    .pmem_resp(pmem_resp)
);

/* Cache Controller */
cache_controller c_controller
(
    .clk(clk),

    .cache_tag(cache_tag),
    .cache_index(cache_index),
    .cache_offset(cache_offset),
    .inmux_sel(inmux_sel),
    .hitmux_sel(hitmux_sel),
    .data0_write(data0_write),
    .data1_write(data1_write),
    .tag0_write(tag0_write),
    .tag1_write(tag1_write),
    .dirty0_write(dirty0_write),
    .dirty1_write(dirty1_write),
    .valid0_write(valid0_write),
    .valid1_write(valid1_write),
    .lru_write(lru_write),

    .lru_bit(lru_bit),
    .valid_bit(valid_bit),
    .dirty_bit(dirty_bit),
    
    .lru_out(lru_out),
    .dirty_out0(dirty_out0),
    .dirty_out1(dirty_out1),
    .valid_out0(valid_out0),
    .valid_out1(valid_out1),
    .tag_out0(tag_out0),
    .tag_out1(tag_out1),
    .hit0(hit0),
    .hit1(hit1),

    .mem_rdata(mem_rdata),
    .mem_wdata(mem_wdata),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_byte_enable(mem_byte_enable),
    .mem_resp(mem_resp),

    .pmem_address(pmem_address),
    .pmem_rdata(pmem_rdata),
    .pmem_wdata(pmem_wdata),
    .pmem_read(pmem_read),
    .pmem_write(pmem_write),
    .pmem_resp(pmem_resp)
);

endmodule : cache
