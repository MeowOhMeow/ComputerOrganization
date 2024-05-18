module ALU (
    input [31:0] src_1,
    input [31:0] src_2,
    output [32:0] result
);
    assign result = src_1 - src_2;
endmodule