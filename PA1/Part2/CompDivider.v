module CompDivider ( 
    output [31:0] Q, 
    output [31:0] R, 
    output Rdy, 
    input [31:0] Dvnd, 
    input [31:0] Dvsr, 
    input Run, 
    input Rst, 
    input clk 
); 
    wire [32:0] ALU_result;
    wire [31:0] Dvsr_out;
    wire [31:0] Hi;
    wire counting;

    ALU ALU_inst ( 
        .src_1(Hi), 
        .src_2(Dvsr_out), 
        .result(ALU_result) 
    );

    Divisor Divisor_inst ( 
        .Dvsr_in(Dvsr), 
        .Dvsr_out(Dvsr_out) 
    );

    Control Control_inst ( 
        .counting(counting), 
        .rst(Rst),
        .clk(clk),
        .ready(Rdy)
    );

    Remainder Remainder_inst ( 
        .clk(clk), 
        .rst(Rst), 
        .run(Run), 
        .Dividend(Dvnd), 
        .ALU_result(ALU_result), 
        .Hi(Hi),
        .Remainder_out(R), 
        .Quotient_out(Q),
        .counting(counting)
    );

endmodule