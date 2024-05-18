module MEM_WB (
    // Outputs
    output reg [31:0] ALUResult_out,
    output reg [31:0] Mem_r_data_out,
    output reg [4:0] RdAddr_out,
    output reg Mem2Reg_out,
    output reg RegWrite_out,
    // Inputs
    input [31:0] ALUResult,
    input [31:0] Mem_r_data,
    input [4:0] RdAddr,
    input Mem2Reg,
    input RegWrite,
    input clk
);
    always @(negedge clk) begin
        ALUResult_out <= ALUResult;
        Mem_r_data_out <= Mem_r_data;
        RdAddr_out <= RdAddr;
        Mem2Reg_out <= Mem2Reg;
        RegWrite_out <= RegWrite;
    end

endmodule