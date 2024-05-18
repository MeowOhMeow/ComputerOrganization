module Control(
    // Outputs
    output RegWrite,
    output [1:0] ALU_op,
    // Inputs
    input [5:0] opcode
);
    
    assign RegWrite = (opcode == 6'b000000) ? 1'b1 : 1'b0;
    assign ALU_op = (opcode == 6'b000000) ? 2'b10 : 2'b00;

endmodule