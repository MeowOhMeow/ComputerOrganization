module DMUX(
    // Outputs
    output [31:0] data,
    // Inputs
    input [31:0] src1,
    input [31:0] src2,
    input ctrl
);

    assign data = ctrl ? src2 : src1;

endmodule