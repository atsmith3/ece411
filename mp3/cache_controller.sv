import lc3b_types::*;
import lc3b_ctypes::*;

module cache_controller
(
    input logic clk,

    /* Cache Controller Signals */
    output lc3b_ctag      cache_tag,
    output lc3b_cindex    cache_index,
    output lc3b_coffset   cache_offset,
    output lc3b_cache_inmux_sel inmux_sel,
    output logic          data0_write,
    output logic          data1_write,
    output logic          tag0_write,
    output logic          tag1_write,
    output logic          dirty0_write,
    output logic          dirty1_write,
    output logic          valid0_write,
    output logic          valid1_write,
    output logic          lru_write,

    output logic[1:0]     addrmux_sel,

    input  logic          lru_out,
    input  logic          dirty_out0,
    input  logic          dirty_out1,
    input  logic          hit0,
    input  logic          hit1,

    /* CPU Interface */
    input  lc3b_word      mem_address,
    input  logic          mem_read,
    input  logic          mem_write,
    output logic          mem_resp,


    /* Memory Interface */
    output logic          pmem_read,
    output logic          pmem_write,
    input  logic          pmem_resp
);

/* Internal Logic Signals */


/* Cache Controller State Enum */
enum int unsigned {
    c_idle,
    c_evict,
    c_fetch,
    INVALID_STATE
} state, next_state;

/* Logic to compute Tag Offset and Index */
always_comb
begin
    cache_tag = mem_address[15:7];
    cache_index = mem_address[6:4];
    cache_offset = mem_address[3:0];
end

/* Output Logic */
always_comb
begin
   /* Default Assignments */
   inmux_sel = inmux_pmem;
   data0_write = 0;
   data1_write = 0;
   tag0_write = 0;
   tag1_write = 0;
   dirty0_write = 0;
   dirty1_write = 0;
   valid0_write = 0;
   valid1_write = 0;
   lru_write = 0;
   mem_resp = 0;
   pmem_read = 0;
   pmem_write = 0;
   addrmux_sel = addrmux_mem_address;

   case(state)
       c_idle: begin
           if(mem_read == 1 && (hit0 == 1 || hit1 == 1)) begin
               lru_write = 1;
               mem_resp = 1;
           end
           else if(mem_write == 1 && (hit0 == 1 || hit1 == 1)) begin
               lru_write = 1;
               mem_resp = 1;
               inmux_sel = inmux_cdata;
               if(hit0 == 1) begin
                   valid0_write = 1;
                   tag0_write = 1;
                   data0_write = 1;
                   dirty0_write = 1;              
               end
               else begin
                   valid1_write = 1;
                   tag1_write = 1;
                   data1_write = 1;
                   dirty1_write = 1;
               end
           end
       end
       c_evict: begin
           pmem_write = 1;
           if(lru_out == 1) begin
               addrmux_sel = addrmux_tag1;
           end
           else begin
               addrmux_sel = addrmux_tag0;
           end
       end
       c_fetch: begin
           pmem_read = 1;
           if(lru_out == 1) begin
               valid1_write = 1;
               tag1_write = 1;
               if(pmem_resp == 1) data1_write = 1;
               dirty1_write = 1;
           end
           else begin
               valid0_write = 1;
               tag0_write = 1;
               if(pmem_resp == 1) data0_write = 1;
               dirty0_write = 1;              
           end
       end
       /* State for debugging */
       INVALID_STATE: begin
       
       end
   endcase 
end

/* Next State Logic */
always_comb
begin
   case(state)
       c_idle: begin
           if((mem_read == 0 && mem_write == 0) || (hit0 == 1 || hit1 == 1)) begin
               next_state = c_idle;
           end
           else begin
               if((lru_out == 1 && dirty_out1 == 1)||
                  (lru_out == 0 && dirty_out0 == 1)) begin
                   next_state = c_evict;
               end
               else begin
                   next_state = c_fetch;
               end
           end
       end
       c_evict: begin
           if(pmem_resp == 1) next_state = c_fetch;
           else next_state = c_evict;
       end
       c_fetch: begin
           if(pmem_resp == 1) next_state = c_idle;
           else next_state = c_fetch;
       end
       INVALID_STATE: begin
           next_state = INVALID_STATE;
       end
    endcase 
end

/* State = Next State */
always_ff @ (posedge clk)
begin
    state <= next_state;
end

endmodule : cache_controller
