module Forwarding_Unit(
    // output
    output reg [1:0] Forwarding_A_ctrl,
    output reg [1:0] Forwarding_B_ctrl,
    // input
    input [4:0] RsAddr_ID2EX,
    input [4:0] RtAddr_ID2EX,
    input [4:0] RdAddr_EX2MEM,
    input [4:0] RdAddr_MEM2WB,
    input RegWrite_EX2MEM,
    input RegWrite_MEM2WB
);

    // Forwarding A
    always @(*) begin
        // EX hazard
        if (RegWrite_EX2MEM && (RdAddr_EX2MEM != 0)) begin
            // Forwarding A
            if (RdAddr_EX2MEM == RsAddr_ID2EX) begin
                Forwarding_A_ctrl <= 2'b10;
            end
            else begin
                Forwarding_A_ctrl <= 2'b00;
            end
            // Forwarding B
            if (RdAddr_EX2MEM == RtAddr_ID2EX) begin
                Forwarding_B_ctrl <= 2'b10;
            end
            else begin
                Forwarding_B_ctrl <= 2'b00;
            end
        end
        // MEM hazard
        else if (RegWrite_MEM2WB && (RdAddr_MEM2WB != 0)) begin
            // Forwarding A
            if (RdAddr_MEM2WB == RsAddr_ID2EX) begin
                Forwarding_A_ctrl <= 2'b01;
            end
            else begin
                Forwarding_A_ctrl <= 2'b00;
            end
            // Forwarding B
            if (RdAddr_MEM2WB == RtAddr_ID2EX) begin
                Forwarding_B_ctrl <= 2'b01;
            end
            else begin
                Forwarding_B_ctrl <= 2'b00;
            end
        end
        else begin
            Forwarding_A_ctrl <= 2'b00;
            Forwarding_B_ctrl <= 2'b00;
        end
    end
endmodule