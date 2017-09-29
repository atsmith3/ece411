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
    output lc3b_cache_hitmux_sel hitmux_sel,
    output logic          data0_write,
    output logic          data1_write,
    output logic          tag0_write,
    output logic          tag1_write,
    output logic          dirty0_write,
    output logic          dirty1_write,
    output logic          valid0_write,
    output logic          valid1_write,
    output logic          lru_write,

    output lc3b_lru_bit   lru_bit,
    output logic          valid_bit,
    output logic          dirty_bit,
    
    input  logic          lru_out,
    input  logic          dirty_out0,
    input  logic          dirty_out1,
    input  logic          valid_out0,
    input  logic          valid_out1,
    input  logic          hit0,
    input  logic          hit1,

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

/* Internal Logic Signals */


/* Cache Controller State Enum */
enum int unsigned {
    c_idle,
    c_read,
    c_write,
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

/* Logic to calculate the Physical Memory address to be accessed */
always_comb
begin
    pmem_address = {mem_address[15:4], 4'b0000};
end

/* Output Logic */
always_comb
begin
   /* Default Assignments */
   inmux_sel = inmux_pmem;
   hitmux_sel = hitmux_way0;
   data0_write = 0;
   data1_write = 0;
   tag0_write = 0;
   tag1_write = 0;
   dirty0_write = 0;
   dirty1_write = 0;
   valid0_write = 0;
   valid1_write = 0;
   lru_write = 0;
   lru_bit = 0;
   valid_bit = 0;
   dirty_bit = 0;
   mem_resp = 0;
   pmem_read = 0;
   pmem_write = 0;

   case(state)
       /* Cache Idle */
       c_idle: begin
           
       end
       /* Cache Read on Hit */
       c_read: begin
       
       end
       /* Cache Write on Hit */
       c_write: begin

       end
       /* Cache Evict on Dirty == 1 && Valid == 1 && No Hits */
       c_evict: begin

       end
       /* Fetch new line if Dirty == 0 && No Hits */
       c_fetch: begin

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
       /* Cache Idle */
       c_idle: begin
           
       end
       /* Cache Read on Hit */
       c_read: begin
       
       end
       /* Cache Write on Hit */
       c_write: begin

       end
       /* Cache Evict on Dirty == 1 && Valid == 1 && No Hits */
       c_evict: begin
           next_state = c_fetch;
       end
       /* Fetch new line if Dirty == 0 && No Hits */
       c_fetch: begin
           if(mem_write == 1'b1) next_state = c_write;
           else if(mem_read  == 1'b1) next_state = c_read;
           else next_state = INVALID_STATE;
           
       end
       /* State for debugging */
       INVALID_STATE: begin
           
       end 
end

/* State = Next State */
always_ff @ (posedge clk)
begin : next_state_assignment
    state <= next_state;
end : next_state_assignment

endmodule : cache_controller
