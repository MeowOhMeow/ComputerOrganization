// Setting timescale
`timescale 10 ns / 1 ns

// Declarations
`define DELAY			1	// # * timescale
`define OUTPUT_FILE		"testbench/tb_Control.out"

// Declaration
`define LOW		1'b0
`define HIGH	1'b1

module tb_Control;

    // Inputs
    reg counting;
    reg rst;
    
    // Outputs
    wire ready;

    // Clock
    reg clk = `LOW;

    // Testbench variables
    integer output_file;


    // Instantiate the Unit Under Test (UUT)
    Control UUT(
        // Outputs
        .ready(ready),
        // Inputs
        .counting(counting),
        .rst(rst),
        .clk(clk)
    );

    initial
    begin : Preprocess
        // Initialize inputs
        counting = `LOW;
        rst = `LOW;

        // Initialize testbench files
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
        // start testing
        @(negedge clk);	// Wait clock
        rst = `HIGH;
        @(negedge clk);	// Wait clock
        rst = `LOW;
        @(negedge clk);	// Wait clock
        counting = `HIGH;
        @(posedge ready);	// Wait ready
        counting = `LOW;
    end

    always @(posedge ready)
    begin : MonitoringProcess
        $fdisplay(output_file, "%t ready = %b", $time, ready);

        // close files
        $fclose(output_file);

        // Stop simulation
        $finish;
    end

endmodule