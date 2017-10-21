package lc3b_ctypes;

typedef logic [127:0] lc3b_cline;
typedef logic [8:0]   lc3b_ctag;
typedef logic [2:0]   lc3b_cindex;
typedef logic [3:0]   lc3b_coffset;
typedef logic         lc3b_lru_bit;

typedef enum bit
{
    inmux_pmem,
    inmux_cdata
} lc3b_cache_inmux_sel;

typedef enum bit[1:0]
{
    addrmux_mem_address,
    addrmux_tag0,
    addrmux_tag1,
    addrmux_0
} lc3b_caddrmux_sel;

endpackage : lc3b_ctypes
