module CompMultiplier ( 
    output [63:0] Prod, 
    output Rdy, 
    input [31:0] Mult, 
    input [31:0] Mul, 
    input Run, 
    input Rst, 
    input clk
); 

    wire [31:0] Hi; 
    wire [32:0] ALU_result; 
    wire [31:0] Mult_out; 
    wire counting;
    
    ALU ALU_inst ( 
        .src_1(Mult_out), 
        .src_2(Hi), 
        .result(ALU_result) 
    ); 

    Multiplicand Multiplicand_inst ( 
        .Mult_in(Mult), 
        .Mult_out(Mult_out) 
    ); 

    Control Control_inst ( 
        .counting(counting), 
        .rst(Rst),
        .clk(clk),
        .ready(Rdy) 
    ); 

    Product Product_inst ( 
        .clk(clk), 
        .rst(Rst), 
        .run(Run),
        .Mul(Mul), 
        .ALU_result(ALU_result), 
        .Hi(Hi), 
        .Prod(Prod),
        .counting(counting)
    );

endmodule