import lc3b_types::*;

module ir
(
    input clk,
    input load,
    input lc3b_word in,
    output lc3b_opcode opcode,
    output lc3b_reg dest, src1, src2,
    output lc3b_jsr_bit jsr_bit,
    output lc3b_imm_bit imm_bit,
    output lc3b_shift_flags shift_flags,
    output lc3b_word imm4,
    output lc3b_word adj6, adj9, adj11,
    output lc3b_word zext8, sext5, mdr_zext
);

lc3b_word data;

lc3b_imm5 imm5;
lc3b_trapvect8 trapvect8;
lc3b_offset6 offset6;
lc3b_offset9 offset9;
lc3b_offset11 offset11;

always_ff @(posedge clk)
begin
    if (load == 1)
    begin
        data = in;
    end
end

adj #(.width(6)) _adj6
(
    .in(offset6),
    .out(adj6)
);
adj #(.width(9)) _adj9
(
    .in(offset9),
    .out(adj9)
);
adj #(.width(11)) _adj11
(
    .in(offset11),
    .out(adj11)
);
zext #(.width(8)) _zext8
(
    .in(trapvect8),
    .out(zext8)
);
imm5 _imm5
(
    .imm5(imm5),
    .out(sext5)
);
zext_no_shift #(.width(8)) _mdr_zext
(
    .in(mem_wdata[7:0]),
    .out(mdr_zext)
);

always_comb
begin
    opcode = lc3b_opcode'(data[15:12]);

    dest = data[11:9];
    src1 = data[8:6];
    src2 = data[2:0];

    imm5 = data[4:0];
    imm4 = {12'h000, data[3:0]};

    trapvect8 = data[7:0];

    jsr_bit = data[11];
    imm_bit = data[5];

    shift_flags = data[5:4];

    offset6 = data[5:0];
    offset9 = data[8:0];
    offset11 = data[10:0];
end

endmodule : ir
