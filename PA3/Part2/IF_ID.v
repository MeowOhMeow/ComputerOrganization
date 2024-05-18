module IF_ID (
    input [31:0] instr,
    input clk,
    output reg [31:0] instr_out
);
    always @(negedge clk) begin
        instr_out <= instr;
    end
    
endmodule