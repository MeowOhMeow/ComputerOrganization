module HD_Unit(
    // Outputs
    output reg ctrl = 1'b0,
    // Inputs
    input wire Mem_Read,
    input wire [4:0] RtAddr_EX,
    input wire [4:0] RsAddr_ID,
    input wire [4:0] RtAddr_ID
);

    always @(*) begin
        if (Mem_Read && (RtAddr_EX == RsAddr_ID || RtAddr_EX == RtAddr_ID)) begin
            ctrl <= 1'b1;
        end
        else begin
            ctrl <= 1'b0;
        end
    end

endmodule