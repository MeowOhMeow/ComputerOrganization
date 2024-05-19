module ID_EX (
    output reg RegDst_out,
    output reg RegWrite_out,
    output reg [1:0] ALU_op_out,
    output reg ALU_src_out,
    output reg Mem_w_out,
    output reg Mem_r_out,
    output reg Mem_to_Reg_out,

    output reg [31:0] rs_out,
    output reg [31:0] rt_out,
    output reg [4:0] rs_addr_out,
    output reg [4:0] rt_addr_out,
    output reg [4:0] rd_addr_out,
    output reg [31:0] imm_out,

    input RegDst,
    input RegWrite,
    input [1:0] ALU_op,
    input ALU_src,
    input Mem_w,
    input Mem_r,
    input Mem_to_Reg,

    input [31:0] rs,
    input [31:0] rt,
    input [4:0] rs_addr,
    input [4:0] rt_addr,
    input [4:0] rd_addr,
    input [31:0] imm,

    input clk
);
    always @(negedge clk) begin
        rs_out <= rs;
        rt_out <= rt;
        rs_addr_out <= rs_addr;
        rt_addr_out <= rt_addr;
        rd_addr_out <= rd_addr;
        imm_out <= imm;

        RegDst_out <= RegDst;
        RegWrite_out <= RegWrite;
        ALU_op_out <= ALU_op;
        ALU_src_out <= ALU_src;
        Mem_w_out <= Mem_w;
        Mem_r_out <= Mem_r;
        Mem_to_Reg_out <= Mem_to_Reg;
    end

endmodule