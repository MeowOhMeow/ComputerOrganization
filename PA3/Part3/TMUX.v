module TMUX(
    // Outputs
    output [31:0] data,
    // Inputs
    input [31:0] src1,
    input [31:0] src2,
    input [31:0] src3,
    input [1:0] ctrl
);

    assign data = (ctrl == 2'b00) ? src1 : (ctrl == 2'b01) ? src2 : src3;

endmodule
