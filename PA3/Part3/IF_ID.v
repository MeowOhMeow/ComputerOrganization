module IF_ID (
    // Outputs
    output reg [31:0] instr_out,
    // Inputs
    input [31:0] instr,
    input clk
);
    always @(negedge clk) begin
        instr_out <= instr;
    end
    
endmodule