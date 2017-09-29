import lc3b_types::*;
import lc3b_ctypes::*;

module cache_datapath
(
    input logic clk,

    /* Cache Controller Signals */
    input  lc3b_ctag      cache_tag,
    input  lc3b_cindex    cache_index,
    input  lc3b_coffset   cache_offset,
    input  lc3b_cache_inmux_sel inmux_sel,
    input  lc3b_cache_hitmux_sel hitmux_sel,
    input  logic          data0_write,
    input  logic          data1_write,
    input  logic          tag0_write,
    input  logic          tag1_write,
    input  logic          dirty0_write,
    input  logic          dirty1_write,
    input  logic          valid0_write,
    input  logic          valid1_write,
    input  logic          lru_write,

    input  lc3b_lru_bit   lru_bit,
    input  logic          valid_bit,
    input  logic          dirty_bit,
    
    output logic          lru_out,
    output logic          dirty_out0,
    output logic          dirty_out1,
    output logic          valid_out0,
    output logic          valid_out1,
    output logic          hit0,
    output logic          hit1,

    /* CPU Interface */
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

/* Internal Logic Signals */
lc3b_cline data_out0, data_out1;
lc3b_ctag  tag_out0, tag_out1;

/* Data Ways */
array data0
(
    .clk(clk),
    .write(data0_write),
    .index(cache_index),
    .datain(cache_way_data),
    .dataout(data_out0)
);
array data1
(
    .clk(clk),
    .write(data1_write),
    .index(cache_index),
    .datain(cache_way_data),
    .dataout(data_out1)
);

/* Tag Ways */
array (.width(9)) tag0
(
    .clk(clk),
    .write(tag0_write),
    .index(cache_index),
    .datain(cache_tag),
    .dataout(tag_out0)
);
array (.width(9)) tag1
(
    .clk(clk),
    .write(tag1_write),
    .index(cache_index),
    .datain(cache_tag),
    .dataout(tag_out1)
);

/* Dirty Bit Ways */
array (.width(1)) dirty0
(
    .clk(clk),
    .write(dirty0_write),
    .index(cache_index),
    .datain(dirty_bit),
    .dataout(dirty_out0)
);
array (.width(1)) dirty1
(
    .clk(clk),
    .write(dirty1_write),
    .index(cache_index),
    .datain(dirty_bit),
    .dataout(dirty_out1)
);

/* Valid Arrays */
array (.width(1)) valid0
(
    .clk(clk),
    .write(valid0_write),
    .index(cache_index),
    .datain(valid_bit),
    .dataout(valid_out0)
);
array (.width(1)) valid1
(
    .clk(clk),
    .write(valid1_write),
    .index(cache_index),
    .datain(valid_bit),
    .dataout(valid_out1)
);

/* LRU Array */
array (.width(1)) lru
(
    .clk(clk),
    .write(),
    .index(cache_index),
    .datain(lru_bit),
    .dataout(lru_out)
);

/* Input Data Logic */
mux2 (.width(128)) cache_input_mux
(
    .sel(inmux_sel),
    .a(pmem_rdata),
    .b(cache_wite_data),
    .f(cache_way_data)
);

cache_modify_data cmd
(
    .cache_offset(cache_offset),
    .mem_byte_enable(mem_byte_enable),
    .d_in_lsb(mem_wdata[7:0]),
    .d_in_msb(mem_wdata[15:8]),
    .l_in(pmem_wdata),
    .l_out(cache_write_data)
);



/* Output Data Logic */
mux2 (.width(128)) cache_hitmux
(
    .sel(hitmux_sel),
    .a(data_out1),
    .b(data_out0),
    .f(pmem_wdata)
);


/* Tag Logic */
always_comb
begin
    if(tag_out0 == cache_tag) hit0 = 1'b1;
    else hit0 = 1'b0;
    if(tag_out1 == cache_tag) hit1 = 1'b1;
    else hit1 = 1'b0;
end

/* Dirty Logic */


/* LRU Logic */


endmodule : cache_datapath
