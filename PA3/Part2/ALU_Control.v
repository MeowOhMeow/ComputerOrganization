module ALU_Control(
    // Outputs
    output reg [5:0] funct,
    // Inputs
    input [1:0] ALU_op,
    input [5:0] funct_ctrl
);
    parameter ADDU = 6'b001011;
    parameter SUBU = 6'b001101;
    parameter SLL = 6'b100110;
    parameter SLLV = 6'b110110;

    always @(*) begin
        case(ALU_op)
            2'b00: funct <= 6'b001001;
            2'b01: funct <= 6'b001010;
            2'b10: begin
                case(funct_ctrl)
                    ADDU: funct <= 6'b001001;
                    SUBU: funct <= 6'b001010;
                    SLL: funct <= 6'b100001;
                    SLLV: funct <= 6'b110101;
                    default: funct <= 6'b000000;
                endcase
            end
            2'b11: funct <= 6'b101010;
            default: funct <= 6'b000000;
        endcase
    end

endmodule