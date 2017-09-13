module mux8 #(parameter width = 16)
(
    input logic [2:0] sel,
    input logic [width-1:0] a, b, c, d, e, g, h, i, 
    output logic [width-1:0] f
);
	
    always_comb begin
        case(sel)
            3'b000: f = a;
	    3'b001: f = b;
            3'b010: f = c;
            3'b011: f = d;
            3'b100: f = e;
	    3'b101: f = g;
            3'b110: f = h;
            3'b111: f = i;
       endcase
    end
endmodule : mux8
