module EX_MEM (
    // Outputs
    output reg [31:0] ALU_result_out,
    output reg [31:0] Rt_data_out,
    output reg [4:0] RdAddr_out,
    output reg MemW_out,
    output reg MemR_out,
    output reg Mem2Reg_out,
    output reg RegWrite_out,
    // Inputs
    input [31:0] ALU_result,
    input [31:0] Rt_data,
    input [4:0] RdAddr,
    input MemW,
    input MemR,
    input Mem2Reg,
    input RegWrite,
    input clk
);
    always @(negedge clk) begin
        ALU_result_out <= ALU_result;
        Rt_data_out <= Rt_data;
        RdAddr_out <= RdAddr;
        MemW_out <= MemW;
        MemR_out <= MemR;
        Mem2Reg_out <= Mem2Reg;
        RegWrite_out <= RegWrite;
    end

endmodule
