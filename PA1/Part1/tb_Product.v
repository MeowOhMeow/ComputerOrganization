
// Setting timescale
`timescale 10 ns / 1 ns

// Declarations
`define DELAY			1	// # * timescale
`define INPUT_FILE		"testbench/tb_Product.in"
`define OUTPUT_FILE		"testbench/tb_Product.out"

// Declaration
`define LOW		1'b0
`define HIGH	1'b1

module tb_Product;

	// Inputs
	reg rst;
    reg run;
    reg [31:0] Mul;
    reg [32:0] ALU_result;
	
	// Outputs
    wire [31:0] Hi;
	wire [63:0] Product_out;
	wire counting;
	
	// Clock
	reg clk = `HIGH;
	
	// Testbench variables
	reg [63:0] read_data;
	integer input_file;
	integer output_file;
	integer i;
	
	// Instantiate the Unit Under Test (UUT)
	Product UUT (
        // Inputs
        .clk(clk),
        .rst(rst),
        .run(run),
        .Mul(Mul),
        .ALU_result(ALU_result),
        // Outputs
        .Hi(Hi),
        .Prod(Product_out),
		.counting(counting)
    );

    // Initialize inputs
	initial
	begin : Preprocess
		// Initialize inputs
		rst = `HIGH;
        run = `LOW;
        Mul = 32'd0;
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
			{ALU_result, Mul} = read_data;
			rst = `HIGH;
			@(negedge clk);	// Wait clock
			rst = `LOW;
			@(negedge clk);	// Wait clock
			run = `HIGH;
			@(posedge clk);	// Wait ready
            @(posedge clk);	// Wait ready
			run = `LOW;
            $fdisplay(output_file, "%t, %x, %x, %x", $time, Mul, ALU_result, Product_out);
		end
		
		#`DELAY;	// Wait for result stable

		// Close output file for safety
		$fclose(output_file);

		// Stop the simulation
		$stop();
	end
	
endmodule
