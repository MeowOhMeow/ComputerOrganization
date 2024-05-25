module ALU(
    // Outputs
    output reg [31:0] ALU_result,
    // Inputs
    input [31:0] data1,
    input [31:0] data2,
    input [4:0] shamt,
    input [5:0] funct
);

    parameter ADDU = 6'b001001;
    parameter SUBU = 6'b001010;
    parameter SLL = 6'b100001;
    parameter SLLV = 6'b110101;
    parameter SLTI = 6'b101010;

    wire [31:0] ADDU_result, SUBU_result, SLL_result, SLLV_result, SLTI_result;

    assign ADDU_result = data1 + data2;
    assign SUBU_result = data1 - data2;
    assign SLL_result = data1 << shamt;
    assign SLLV_result = data1 << data2[4:0];
    assign SLTI_result = data1 < data2;

    always @(*) begin
        case(funct)
            ADDU: ALU_result <= ADDU_result;
            SUBU: ALU_result <= SUBU_result;
            SLL: ALU_result <= SLL_result;
            SLLV: ALU_result <= SLLV_result;
            SLTI: ALU_result <= SLTI_result;
            default: ALU_result <= 32'b0;
        endcase
    end

endmodule
