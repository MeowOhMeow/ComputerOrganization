module Adder(
    // Outputs
    output [31:0] OutputAddr,
    // Inputs
    input [31:0] InputAddr,
    input [31:0] Offset
);

    assign OutputAddr = InputAddr + Offset;

endmodule