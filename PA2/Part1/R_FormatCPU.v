/*
 *	Template for Project 2 Part 1
 *	Copyright (C) 2022  Chen Chia Yi or any person belong ESSLab.
 *	All Right Reserved.
 *
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *	This file is for people who have taken the cource (1102 Computer
 *	Organizarion) to use.
 *	We (ESSLab) are not responsible for any illegal use.
 *
 */

/*
 * Declaration of top entry for this project.
 * CAUTION: DONT MODIFY THE NAME AND I/O DECLARATION.
 */
module R_FormatCPU(
	// Outputs
	output	wire	[31:0]	Output_Addr,
	// Inputs
	input	wire	[31:0]	Input_Addr,
	input	wire			clk
);
	wire [31:0] Instruction;
	wire [31:0] Rs_data;
	wire [31:0] Rt_data;
	wire [31:0] Rd_data;
	wire RegWrite;
	wire [1:0] ALU_op;
	wire [5:0] funct;

	Adder AdderInstance(
		// Outputs
		.OutputAddr(Output_Addr),
		// Inputs
		.InputAddr(Input_Addr),
		.Offset(32'h4)
	);

	IM Instr_Memory(
		// Outputs
		.Instruction(Instruction),
		// Inputs
		.InputAddr(Input_Addr)
	);

	RF Register_File(
		// Outputs
		.RsData(Rs_data),
		.RtData(Rt_data),
		// Inputs
		.RsAddr(Instruction[25:21]),
		.RtAddr(Instruction[20:16]),
		.RdAddr(Instruction[15:11]),
		.RdData(Rd_data),
		.RegWrite(RegWrite),
		.clk(clk)
	);

	Control ControlInstance(
		// Outputs
		.RegWrite(RegWrite),
		.ALU_op(ALU_op),
		// Inputs
		.opcode(Instruction[31:26])
	);

	ALU_Control ALU_ControlInstance(
		// Outputs
		.funct(funct),
		// Inputs
		.ALU_op(ALU_op),
		.funct_ctrl(Instruction[5:0])
	);

	ALU ALUInstance(
		// Outputs
		.ALU_result(Rd_data),
		// Inputs
		.Rs_data(Rs_data),
		.Rt_data(Rt_data),
		.shamt(Instruction[10:6]),
		.funct(funct)
	);

endmodule
