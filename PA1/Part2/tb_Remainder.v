
// Setting timescale
`timescale 10 ns / 1 ns

// Declarations
`define DELAY			1	// # * timescale
`define INPUT_FILE		"testbench/tb_Remainder.in"
`define OUTPUT_FILE		"testbench/tb_Remainder.out"

// Declaration
`define LOW		1'b0
`define HIGH	1'b1

module tb_Remainder;

	// Inputs
	reg rst;
    reg run;
	reg [31:0] Dividend;
	reg [32:0] ALU_result;

	// Outputs
	wire [31:0] Hi;
	wire [31:0] Remainder_out;
	wire [31:0] Quotient_out;  
	wire counting;  
	
	// Clock
	reg clk = `HIGH;
	
	// Testbench variables
	reg [63:0] read_data;
	integer input_file;
	integer output_file;
	integer i;
	
	// Instantiate the Unit Under Test (UUT)
	Remainder UUT (
		// Inputs
		.clk(clk),
		.rst(rst),
		.run(run),
		.Dividend(Dividend),
		.ALU_result(ALU_result),
		// Outputs
		.Hi(Hi),
		.Remainder_out(Remainder_out),
		.Quotient_out(Quotient_out),
		.counting(counting)
    );

    // Initialize inputs
	initial
	begin : Preprocess
		// Initialize inputs
		rst = `HIGH;
        run = `LOW;
		Dividend = 32'd0;
		ALU_result = 33'd0;

		// Initialize testbench files
		input_file	= $fopen(`INPUT_FILE, "r");
		output_file	= $fopen(`OUTPUT_FILE);

		#`DELAY;	// Wait for global reset to finish
	end
	
	always
	begin : ClockGenerator
		#`DELAY;
		clk <= ~clk;
	end
	
	always
	begin : StimuliProcess
		// Start testing
		while (!$feof(input_file))
		begin
			$fscanf(input_file, "%x\n", read_data);
			@(negedge clk);	// Wait clock
			{ALU_result, Dividend} = {1'b1, read_data};
			rst = `HIGH;
			@(negedge clk);	// Wait clock
			rst = `LOW;
			@(negedge clk);	// Wait clock
			run = `HIGH;
			@(posedge clk);	// Wait ready
            @(posedge clk);	// Wait ready
			run = `LOW;
            $fdisplay(output_file, "%t, %x, %x, %x, %x", $time, Dividend, ALU_result, Remainder_out, Quotient_out);
			@(negedge clk);	// Wait clock
			{ALU_result, Dividend} = {1'b0, read_data};
			rst = `HIGH;
			@(negedge clk);	// Wait clock
			rst = `LOW;
			@(negedge clk);	// Wait clock
			run = `HIGH;
			@(posedge clk);	// Wait ready
            @(posedge clk);	// Wait ready
			run = `LOW;
            $fdisplay(output_file, "%t, %x, %x, %x, %x", $time, Dividend, ALU_result, Remainder_out, Quotient_out);
		end
		
		#`DELAY;	// Wait for result stable

		// Close output file for safety
		$fclose(output_file);

		// Stop the simulation
		$stop();
	end
	
endmodule
