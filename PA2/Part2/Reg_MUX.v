module RegMUX(
    // Outputs
    output [4:0] RegDst,
    // Inputs
    input [4:0] Rt,
    input [4:0] Rd,
    input RegDst_ctrl
);

    assign RegDst = (RegDst_ctrl) ? Rd : Rt;

endmodule
