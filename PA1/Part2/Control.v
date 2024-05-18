module Control (
    input counting,
    input rst,
    input clk,
    output reg ready
);

    reg [5:0] count;
    reg reset;

    always @(posedge clk) begin
        if (rst) begin
            reset <= 1;
        end
        else begin
            reset <= 0;
        end
    end

    always @(negedge clk) begin
        if (reset) begin
            count <= 0;
            ready <= 0;
        end
        else if (counting) begin
            count <= count + 1;
            if (count == 32) begin
            ready <= 1;
            end
        end
    end

endmodule
