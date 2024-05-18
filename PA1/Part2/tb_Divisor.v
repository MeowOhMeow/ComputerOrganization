// Setting timescale
`timescale 10 ns / 1 ns

// Declarations
`define DELAY			1	// # * timescale
`define INPUT_FILE		"testbench/tb_Divisor.in"
`define OUTPUT_FILE		"testbench/tb_Divisor.out"

// Declaration
`define LOW		1'b0
`define HIGH	1'b1

module tb_Divisor;

    // Inputs
    reg [31:0] src;
    
    // Outputs
    wire [31:0] result;

    // Clock
    reg clk = `LOW;

    // Testbench variables
	reg [31:0] read_data;
	integer input_file;
	integer output_file;
	integer i;

    Divisor UUT(
        // Outputs
        .Dvsr_out(result),
        // Inputs
        .Dvsr_in(src)
    );

    initial
    begin : Preprocess
        // Initialize inputs
        src = 32'd0;

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
            src = read_data;
            @ (negedge clk);
            $display("src = %x", src);
            $display("result = %x", result);
            $fdisplay(output_file, "%t, %x, %x", $time, src, result);
        end

        #`DELAY;

        // Close files
        $fclose(output_file);

        // Stop simulation
        $stop;
    end

endmodule