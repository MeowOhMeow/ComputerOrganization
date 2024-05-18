// Setting timescale
`timescale 10 ns / 1 ns

// Declarations
`define DELAY			1	// # * timescale
`define INPUT_FILE		"testbench/tb_ALU.in"
`define OUTPUT_FILE		"testbench/tb_ALU.out"

// Declaration
`define LOW		1'b0
`define HIGH	1'b1

module tb_ALU;

    // Inputs
    reg [31:0] src_1;
    reg [31:0] src_2;
    
    // Outputs
    wire [32:0] result;

    // Clock
    reg clk = `LOW;

    // Testbench variables
	reg [63:0] read_data;
	integer input_file;
	integer output_file;
	integer i;

    ALU UUT(
        // Outputs
        .result(result),
        // Inputs
        .src_1(src_1),
        .src_2(src_2)
    );

    initial
    begin : Preprocess
        // Initialize inputs
        src_1 = 32'd0;
        src_2 = 32'd0;

        // Initialize testbench files
        input_file	= $fopen(`INPUT_FILE, "r");
        output_file	= $fopen(`OUTPUT_FILE);

        #`DELAY;
    end

    always
    begin : ClockGenerator
        #`DELAY;
        clk <= ~clk;
    end

    always
    begin : StimuliProcess
        // startt testing
        while (!$feof(input_file))
        begin
            $fscanf(input_file, "%x\n", read_data);
            @ (posedge clk);
            {src_1, src_2} = read_data;
            @ (negedge clk);
            $display("src_1 = %x, src_2 = %x", src_1, src_2);
            $display("result = %x", result);
            $fdisplay(output_file, "%t, %x, %x, %x", $time, src_1, src_2, result);
        end

        #`DELAY;

        // Close files
        $fclose(output_file);

        // Stop simulation
        $stop;
    end

endmodule