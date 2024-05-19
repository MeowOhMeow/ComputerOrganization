module Stall_MUX(
    // Outputs
    output wire RegDst_out,
    output wire RegWrite_out,
    output wire [1:0] ALU_op_out,
    output wire ALU_src_out,
    output wire Mem_w_out,
    output wire Mem_r_out,
    output wire Mem_to_Reg_out,
    // Inputs
    input wire RegDst,
    input wire RegWrite,
    input wire [1:0] ALU_op,
    input wire ALU_src,
    input wire Mem_w,
    input wire Mem_r,
    input wire Mem_to_Reg,
    input wire stall_ctrl
);

    assign RegDst_out = (stall_ctrl) ? 1'b0 : RegDst;
    assign RegWrite_out = (stall_ctrl) ? 1'b0 : RegWrite;
    assign ALU_op_out = (stall_ctrl) ? 2'b00 : ALU_op;
    assign ALU_src_out = (stall_ctrl) ? 1'b0 : ALU_src;
    assign Mem_w_out = (stall_ctrl) ? 1'b0 : Mem_w;
    assign Mem_r_out = (stall_ctrl) ? 1'b0 : Mem_r;
    assign Mem_to_Reg_out = (stall_ctrl) ? 1'b0 : Mem_to_Reg;

endmodule