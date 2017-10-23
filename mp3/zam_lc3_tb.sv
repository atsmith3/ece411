module zam_lc3_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;
logic read_a;
logic write_a;
lc3b_mem_wmask wmask_a;
lc3b_word address_a;
lc3b_word wdata_a;
logic resp_a;
lc3b_word rdata_a;
logic read_b;
logic write_b;
lc3b_mem_wmask wmask_b;
lc3b_word address_b;
lc3b_word wdata_b;
logic resp_b;
lc3b_word rdata_b;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

zam_lc3 dut
(
    .clk,
    .read_a,
    .write_a,
    .wmask_a,
    .address_a,
    .wdata_a,
    .resp_a,
    .rdata_a,
    .read_b,
    .write_b,
    .wmask_b,
    .address_b,
    .wdata_b,
    .resp_b,
    .rdata_b
);

magic_memory_dp memory
(
    .clk(clk),
    .read_a(read_a),
    .write_a(write_a),
    .wmask_a(wmask_a),
    .address_a(address_a),
    .wdata_a(wdata_a),
    .resp_a(resp_a),
    .rdata_a(rdata_a),
    .read_b(read_b),
    .write_b(write_b),
    .wmask_b(wmask_b),
    .address_b(address_b),
    .wdata_b(wdata_b),
    .resp_b(resp_b),
    .rdata_b(rdata_b)
);

endmodule : zam_lc3_tb
