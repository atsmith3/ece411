import lc3b_types::*;

/*
 * sext(imm5)
 */
module imm5
(
    input lc3b_imm5 imm5,
    output lc3b_word out
);

assign out = $signed(imm5);

endmodule : adj
