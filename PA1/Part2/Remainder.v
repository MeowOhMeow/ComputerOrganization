module Remainder (
    input clk,
    input rst,
    input run,
    input [31:0] Dividend,
    input [32:0] ALU_result,
    output [31:0] Hi,
    output [31:0] Remainder_out,
    output [31:0] Quotient_out,
    output counting
);
    reg state;
    reg [64:0] Remainder;

    assign Hi = Remainder[63:32];
    assign Remainder_out = Remainder[64:33];
    assign Quotient_out = Remainder[31:0];
    assign counting = state;

    always @(posedge clk) begin
        if (rst) begin
            state <= 0;
            Remainder <= 0;
        end
        else if (run) begin
            case (state)
                0: begin    // init state: Load Dividend into Remainder
                    Remainder <= {32'b0, Dividend, 1'b0};
                    state <= 1;
                end
                1: begin    // run state: Divide
                    if (ALU_result[32]) begin
                        Remainder <= {Remainder[63:32], Remainder[31:0], 1'b0};
                    end
                    else begin
                        Remainder <= {ALU_result[31:0], Remainder[31:0], 1'b1};
                    end
                    state <= 1;
                end
            endcase
        end
    end

endmodule
