`define ADDU 6'b001001
`define SUBU 6'b001010
`define SLL 6'b100001
`define SLLV 6'b110101

module ALU(
    // Outputs
    output reg [31:0] ALU_result,
    // Inputs
    input [31:0] Rs_data,
    input [31:0] Rt_data,
    input [4:0] shamt,
    input [5:0] funct
);
    wire [31:0] ADDU_result, SUBU_result, SLL_result, SLLV_result;

    assign ADDU_result = Rs_data + Rt_data;
    assign SUBU_result = Rs_data - Rt_data;
    assign SLL_result = Rs_data << shamt;
    assign SLLV_result = Rs_data << Rt_data[4:0];

    always @(*) begin
        case(funct)
            `ADDU: ALU_result = ADDU_result;
            `SUBU: ALU_result = SUBU_result;
            `SLL: ALU_result = SLL_result;
            `SLLV: ALU_result = SLLV_result;
            default: ALU_result = 32'b0;
        endcase
    end

endmodule
