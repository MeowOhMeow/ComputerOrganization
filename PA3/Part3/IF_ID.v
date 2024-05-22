module IF_ID (
    // Outputs
    output reg [31:0] instr_out,
    // Inputs
    input [31:0] instr,
    input clk
);
    reg init = 0;

    always @(negedge clk) begin
        if(init == 0) begin
            instr_out <= 32'bz;
            init <= 1;
        end
        else begin
            instr_out <= instr;
        end
    end
    
endmodule