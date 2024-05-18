`define R_TYPE 6'b000000
`define SUBIU 6'b001101
`define SW 6'b010000
`define LW 6'b010001
`define SLTI 6'b101010
`define BEQ 6'b010011
`define J 6'b011100

module Control(
    // Outputs
    output reg RegDst,
    output reg RegWrite,
    output reg [1:0] ALU_op,
    output reg ALU_src,
    output reg Mem_w,
    output reg Mem_r,
    output reg Mem_to_Reg,
    output reg Branch,
    output reg Jump,
    // Inputs
    input [5:0] opcode
);
    
    always @(*) begin
        case(opcode)
            `R_TYPE: begin
                RegDst <= 1'b1;
                RegWrite <= 1'b1;
                ALU_op <= 2'b10;
                ALU_src <= 1'b0;
                Mem_w <= 1'b0;
                Mem_r <= 1'b0;
                Mem_to_Reg <= 1'b0;
                Branch <= 1'b0;
                Jump <= 1'b0;
            end
            `SUBIU: begin
                RegDst <= 1'b0;
                RegWrite <= 1'b1;
                ALU_op <= 2'b01;
                ALU_src <= 1'b1;
                Mem_w <= 1'b0;
                Mem_r <= 1'b0;
                Mem_to_Reg <= 1'b0;
                Branch <= 1'b0;
                Jump <= 1'b0;
            end
            `SW: begin
                RegDst <= 1'b0;
                RegWrite <= 1'b0;
                ALU_op <= 2'b00;
                ALU_src <= 1'b1;
                Mem_w <= 1'b1;
                Mem_r <= 1'b0;
                Mem_to_Reg <= 1'b0;
                Branch <= 1'b0;
                Jump <= 1'b0;
            end
            `LW: begin
                RegDst <= 1'b0;
                RegWrite <= 1'b1;
                ALU_op <= 2'b00;
                ALU_src <= 1'b1;
                Mem_w <= 1'b0;
                Mem_r <= 1'b1;
                Mem_to_Reg <= 1'b1;
                Branch <= 1'b0;
                Jump <= 1'b0;
            end
            `SLTI: begin
                RegDst <= 1'b0;
                RegWrite <= 1'b1;
                ALU_op <= 2'b11;
                ALU_src <= 1'b1;
                Mem_w <= 1'b0;
                Mem_r <= 1'b0;
                Mem_to_Reg <= 1'b0;
                Branch <= 1'b0;
                Jump <= 1'b0;
            end
            `BEQ: begin
                RegDst <= 1'b0;
                RegWrite <= 1'b0;
                ALU_op <= 2'b01;
                ALU_src <= 1'b0;
                Mem_w <= 1'b0;
                Mem_r <= 1'b0;
                Mem_to_Reg <= 1'b0;
                Branch <= 1'b1;
                Jump <= 1'b0;
            end
            `J: begin
                RegDst <= 1'b0;
                RegWrite <= 1'b0;
                ALU_op <= 2'b00;
                ALU_src <= 1'b0;
                Mem_w <= 1'b0;
                Mem_r <= 1'b0;
                Mem_to_Reg <= 1'b0;
                Branch <= 1'b0;
                Jump <= 1'b1;
            end
            default: begin
                RegDst <= 1'b0;
                RegWrite <= 1'b0;
                ALU_op <= 2'b00;
                ALU_src <= 1'b0;
                Mem_w <= 1'b0;
                Mem_r <= 1'b0;
                Mem_to_Reg <= 1'b0;
            end
        endcase
    end
endmodule