module RegMUX(
    // Outputs
    output [4:0] RegDst,
    // Inputs
    input [4:0] addr1,
    input [4:0] addr2,
    input RegDst_ctrl
);

    assign RegDst = (RegDst_ctrl) ? addr2 : addr1;

endmodule
