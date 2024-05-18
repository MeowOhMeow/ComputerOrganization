`define ADDU 6'b001001
`define SUBU 6'b001010
`define AND 6'b010001
`define SRL 6'b100010

module ALU (
    input [31:0] Src_1,
    input [31:0] Src_2,
    input [4:0] Shamt,
    input [5:0] Funct,
    output reg [31:0] ALU_result,
    output wire Zero,
    output reg Carry
);

    // ALU operations
    wire [31:0] ADDU_wire, SUBU_wire, AND_wire, SRL_wire;

    // Declare carry wires
    wire Carry_wire, Borrow_wire;
    
    // Assignments for ALU operations
    assign {Carry_wire, ADDU_wire} = Src_1 + Src_2;
    assign {Borrow_wire, SUBU_wire} = Src_1 + ~Src_2 + 1;
    assign AND_wire = Src_1 & Src_2;
    assign SRL_wire = Src_1 >> Shamt;

    // ALU control logic
    always @(*) begin
        case(Funct)
            `ADDU: begin
                ALU_result <= ADDU_wire;
                Carry <= Carry_wire;
            end
            `SUBU: begin
                ALU_result <= SUBU_wire;
                Carry <= Borrow_wire;
            end
            `AND: begin
                ALU_result <= AND_wire;
                Carry <= 0; // No carry for And
            end
            `SRL: begin
                ALU_result <= SRL_wire;
                Carry <= 0; // No carry for Srl
            end
            default: begin
                ALU_result <= 32'b0;
                Carry <= 0;
            end
        endcase
    end

    assign Zero = (ALU_result == 32'b0);

endmodule
