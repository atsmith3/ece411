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
    input  logic          data0_write,
    input  logic          data1_write,
    input  logic          tag0_write,
    input  logic          tag1_write,
    input  logic          dirty0_write,
    input  logic          dirty1_write,
    input  logic          valid0_write,
    input  logic          valid1_write,
    input  logic          lru_write,

    input  logic[1:0]     addrmux_sel,
    
    output logic          lru_out,
    output logic          dirty_out0,
    output logic          dirty_out1,
    output logic          hit0,
    output logic          hit1,

    /* CPU Interface */
    input  logic          mem_write,
    input  lc3b_word      mem_address,
    output lc3b_word      mem_rdata,
    input  lc3b_word      mem_wdata,
    input  lc3b_mem_wmask mem_byte_enable,


    /* Memory Interface */
    output lc3b_word      pmem_address,
    input  lc3b_cline     pmem_rdata,
    output lc3b_cline     pmem_wdata,
    input  logic          pmem_resp
);

/* Internal Logic Signals */
lc3b_cline data_out0, data_out1;
lc3b_cline cache_write_data, cache_way_data;
lc3b_cline data_line_out;
lc3b_ctag  tag_out0, tag_out1;
logic valid_out0, valid_out1;

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
array #(.width(9)) tag0
(
    .clk(clk),
    .write(tag0_write),
    .index(cache_index),
    .datain(cache_tag),
    .dataout(tag_out0)
);
array #(.width(9)) tag1
(
    .clk(clk),
    .write(tag1_write),
    .index(cache_index),
    .datain(cache_tag),
    .dataout(tag_out1)
);

/* Dirty Bit Ways */
array #(.width(1)) dirty0
(
    .clk(clk),
    .write(dirty0_write),
    .index(cache_index),
    .datain(mem_write),
    .dataout(dirty_out0)
);
array #(.width(1)) dirty1
(
    .clk(clk),
    .write(dirty1_write),
    .index(cache_index),
    .datain(mem_write),
    .dataout(dirty_out1)
);

/* Valid Arrays */
array #(.width(1)) valid0
(
    .clk(clk),
    .write(valid0_write),
    .index(cache_index),
    .datain(1'b1),
    .dataout(valid_out0)
);
array #(.width(1)) valid1
(
    .clk(clk),
    .write(valid1_write),
    .index(cache_index),
    .datain(1'b1),
    .dataout(valid_out1)
);

/* LRU Array */
array #(.width(1)) lru
(
    .clk(clk),
    .write(lru_write),
    .index(cache_index),
    .datain(hit0),
    .dataout(lru_out)
);

/* Input Data Logic */
mux2 #(.width(128)) cache_input_mux
(
    .sel(inmux_sel),
    .a(pmem_rdata),
    .b(cache_write_data),
    .f(cache_way_data)
);
cache_modify_data cmd
(
    .cache_offset(cache_offset),
    .mem_byte_enable(mem_byte_enable),
    .d_in_lsb(mem_wdata[7:0]),
    .d_in_msb(mem_wdata[15:8]),
    .l_in(data_line_out),
    .l_out(cache_write_data)
);



/* Output Data Logic */
mux2 #(.width(128)) cache_hitmux
(
    .sel(hit1),
    .a(data_out0),
    .b(data_out1),
    .f(data_line_out)
);
cache_output_word cow
(
    .cache_offset(cache_offset),
    .mem_byte_enable(mem_byte_enable),
    .l_in(data_line_out),
    .w_out(mem_rdata)
);
mux2 #(.width(128)) lru_mux
(
    .sel(lru_out),
    .a(data_out0),
    .b(data_out1),
    .f(pmem_wdata)
);
mux4 #(.width(16)) pmem_addrmux
(
    .sel(addrmux_sel),
    .a(mem_address),
    .b({tag_out0, cache_index, 4'h0}),
    .c({tag_out1, cache_index, 4'h0}),
    .d(16'h0000),
    .f(pmem_address)
);


/* Tag Logic */
always_comb
begin
    if(tag_out0 == cache_tag && valid_out0 == 1) hit0 = 1'b1;
    else hit0 = 1'b0;
    if(tag_out1 == cache_tag && valid_out1 == 1) hit1 = 1'b1;
    else hit1 = 1'b0;
end

/* Dirty Logic */


/* LRU Logic */


endmodule : cache_datapath
