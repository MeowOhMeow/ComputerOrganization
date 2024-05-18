module Product (
    input clk,
    input rst,
    input run,
    input [31:0] Mul,
    input [32:0] ALU_result,
    output [31:0] Hi,
    output [63:0] Prod,
    output counting
);
    reg state;
    reg [64:0] product;

    assign Hi = product[63:32];
    assign Prod = product[63:0];
    assign counting = state;

    always @(posedge clk) begin
        if (rst) begin
            state <= 0;
            product <= 0;
        end
        else if (run) begin
            case (state)
                0: begin    // init state: Load Mul into product
                    product <= {33'b0, Mul};
                    state <= 1;
                end
                1: begin    // run state: Multiply
                    if (product[0]) begin
                        product <= {1'b0, ALU_result, product[31:1]};
                    end
                    else begin
                        product <= {1'b0, product[64:1]};
                    end
                    state <= 1;
                end
            endcase
        end
    end

endmodule