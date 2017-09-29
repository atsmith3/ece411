package lc3b_ctypes;

typedef logic [127:0] lc3b_cline;
typedef logic [8:0]   lc3b_ctag;
typedef logic [2:0]   lc3b_cindex;
typedef logic [3:0]   lc3b_coffset;

typedef enum bit
{
    inmux_pmem,
    inmux_cdata
} lc3b_cache_inmux_sel;

typedef enum bit
{
    hitmux_way0,
    hitmux_way1
} lc3b_cache_hitmux_sel;

endpackage : lc3b_ctypes
