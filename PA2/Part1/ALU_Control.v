`define ADDU 6'b001011
`define SUBU 6'b001101
`define SLL 6'b100110
`define SLLV 6'b110110

module ALU_Control(
    // Outputs
    output reg [5:0] funct,
    // Inputs
    input [1:0] ALU_op,
    input [5:0] funct_ctrl
);

    always @(*) begin
        case(ALU_op)
            2'b00: funct = 6'b000000;
            2'b01: funct = 6'b000000;
            2'b10: begin
                case(funct_ctrl)
                    `ADDU: funct = 6'b001001;
                    `SUBU: funct = 6'b001010;
                    `SLL: funct = 6'b100001;
                    `SLLV: funct = 6'b110101;
                    default: funct = 6'b000000;
                endcase
            end
            2'b11: funct = 6'b000000;
            default: funct = 6'b000000;
        endcase
    end

endmodule