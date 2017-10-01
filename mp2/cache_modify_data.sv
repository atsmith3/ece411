import lc3b_types::*;
import lc3b_ctypes::*;

module cache_modify_data
(
    input  lc3b_coffset       cache_offset,
    input  lc3b_mem_wmask     mem_byte_enable,
    input  lc3b_byte          d_in_lsb,
    input  lc3b_byte          d_in_msb,
    input  lc3b_cline         l_in,
    output lc3b_cline         l_out
);

logic [15:0] sel;
lc3b_coffset offset;

always_comb
begin
    offset = {cache_offset[3:1], 1'b0};

    /* Default sel Value */
    sel = 16'h0000;

    if(mem_byte_enable[0] == 1) begin
        sel[offset] = 1;
    end
    if(mem_byte_enable[1] == 1) begin
        sel[offset + 1] = 1;
    end
end

/* Word[0] */
mux2 #(.width(8)) mux20
(
    .sel(sel[0]),
    .a(l_in[7:0]),
    .b(d_in_lsb),
    .f(l_out[7:0])
);
mux2 #(.width(8)) mux21
(
    .sel(sel[1]),
    .a(l_in[15:8]),
    .b(d_in_msb),
    .f(l_out[15:8])
);
/* Word[1] */
mux2 #(.width(8)) mux22
(
    .sel(sel[2]),
    .a(l_in[23:16]),
    .b(d_in_lsb),
    .f(l_out[23:16])
);
mux2 #(.width(8)) mux23
(
    .sel(sel[3]),
    .a(l_in[31:24]),
    .b(d_in_msb),
    .f(l_out[31:24])
);
/* Word[2] */
mux2 #(.width(8)) mux24
(
    .sel(sel[4]),
    .a(l_in[39:32]),
    .b(d_in_lsb),
    .f(l_out[39:32])
);
mux2 #(.width(8)) mux25
(
    .sel(sel[5]),
    .a(l_in[47:40]),
    .b(d_in_msb),
    .f(l_out[47:40])
);
/* Word[3] */
mux2 #(.width(8)) mux26
(
    .sel(sel[6]),
    .a(l_in[55:48]),
    .b(d_in_lsb),
    .f(l_out[55:48])
);
mux2 #(.width(8)) mux27
(
    .sel(sel[7]),
    .a(l_in[63:56]),
    .b(d_in_msb),
    .f(l_out[63:56])
);
/* Word[4] */
mux2 #(.width(8)) mux28
(
    .sel(sel[8]),
    .a(l_in[71:64]),
    .b(d_in_lsb),
    .f(l_out[71:64])
);
mux2 #(.width(8)) mux29
(
    .sel(sel[9]),
    .a(l_in[79:72]),
    .b(d_in_msb),
    .f(l_out[79:72])
);
/* Word[5] */
mux2 #(.width(8)) mux210
(
    .sel(sel[10]),
    .a(l_in[87:80]),
    .b(d_in_lsb),
    .f(l_out[87:80])
);
mux2 #(.width(8)) mux211
(
    .sel(sel[11]),
    .a(l_in[95:88]),
    .b(d_in_msb),
    .f(l_out[95:88])
);
/* Word[6] */
mux2 #(.width(8)) mux212
(
    .sel(sel[12]),
    .a(l_in[103:96]),
    .b(d_in_lsb),
    .f(l_out[103:96])
);
mux2 #(.width(8)) mux213
(
    .sel(sel[13]),
    .a(l_in[111:104]),
    .b(d_in_msb),
    .f(l_out[111:104])
);
/* Word[7] */
mux2 #(.width(8)) mux214
(
    .sel(sel[14]),
    .a(l_in[119:112]),
    .b(d_in_lsb),
    .f(l_out[119:112])
);
mux2 #(.width(8)) mux215
(
    .sel(sel[15]),
    .a(l_in[127:120]),
    .b(d_in_msb),
    .f(l_out[127:120])
);

endmodule : cache_modify_data
