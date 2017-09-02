import lc3b_types::*;

module datapath
(
    input clk,

    /* control signals */
	 input storemux_sel,
    input pcmux_sel,
    input load_pc

    /* declare more ports here */
);

/* declare internal signals */
lc3b_word pcmux_out;
lc3b_word pc_out;
lc3b_word br_add_out;
lc3b_word pc_plus2_out;
lc3b_word ir_out;

lc3b_reg sr1;
lc3b_reg dest;
lc3b_reg storemux_out;

/*
 * PC
 */
mux2 pcmux
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(br_add_out),
    .f(pcmux_out)
);

register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

/*
 * StoreMux
 */
mux2 #(.width(3)) storemux 
(
    .sel(storemux_sel),
	 .a(sr1),
	 .b(dest),
	 .f(storemux_out)
);

endmodule : datapath
