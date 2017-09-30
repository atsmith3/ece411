import lc3b_types::*;
import lc3b_ctypes::*;

module cache_output_word
(
    input  lc3b_cache_offset  cache_offset,
    input  lc3b_mem_wmask     mem_byte_enable,
    input  lc3b_cache_line    l_in,
    output lc3b_word          w_out
);

always_comb
begin
    /* If the 0th bit of the offset is 1, just read
     * the byte into the w_out with {8'h00,M[offset]}.
     * Else read the entire word into the output register. */
    if(cache_offset[0] == 1) begin
        w_out = {8'h00,l_in[((cache_offset+1)*8):(cache_offset*8)];
    end
    else begin
        w_out = l_in[((cache_offset+2)*8):(cache_offset*8)];
    end
end

endmodule : cache_output_word
