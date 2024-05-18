/*
 *	Template for Project 2 Part 3
 *	Copyright (C) 2023  Hsiu-Yi Ou Yang or any person belong ESSLab.
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
module SimpleCPU(
	// Outputs
	output	wire	[31:0]	Output_Addr,
	// Inputs
	input	wire	[31:0]	Input_Addr,
	input	wire			clk
);

	wire [31:0] Instruction;
	wire [31:0] Rs_data, Rt_data;
	wire [4:0] RdAddr;
	wire [31:0] Rd_data;
	wire Reg_dst, Reg_w, ALU_src, Mem_w, Mem_r, Mem_to_reg;
	wire [31:0] imm, imm2;
	wire [31:0] ALU_src2;
	wire [5:0] funct;
	wire [1:0] ALU_op;
	wire [31:0] ALU_result;
	wire [31:0] Mem_r_data;
	wire Branch, Jump;
	wire [31:0] NextPC, BranchPC, NextPC2, JumpPC;
	wire Zero;

	// sign extend imm
	assign imm = { {16{Instruction[15]}}, Instruction[15:0] };
	assign imm2 = { imm[29:0], 2'b00 };
	assign JumpPC = { NextPC[31:28], Instruction[25:0], 2'b00 };

	Adder NextAddr(
		// Outputs
		.OutputAddr (NextPC),
		// Inputs
		.InputAddr(Input_Addr),
		.Offset(32'h4)
	);

	Adder BranchAddr(
		// Outputs
		.OutputAddr(BranchPC),
		// Inputs
		.InputAddr (NextPC),
		.Offset(imm2)
	);

	GPRMUX BranchMUX(
		// Outputs
		.data(NextPC2),
		// Inputs
		.src1 (NextPC),
		.src2(BranchPC),
		.ctrl(Branch & Zero)
	);

	GPRMUX JumpMUX(
		// Outputs
		.data(Output_Addr),
		// Inputs
		.src1(NextPC2),
		.src2(JumpPC),
		.ctrl(Jump)
	);

	IM Instr_Memory(
		// Outputs
		.Instruction(Instruction),
		// Inputs
		.InputAddr(Input_Addr)
	);

	RegMUX Reg_MUX1(
		// Outputs
		.RegDst(RdAddr),
		// Inputs
		.Rt(Instruction[20:16]),
		.Rd(Instruction[15:11]),
		.RegDst_ctrl(Reg_dst)
	);
	
	RF Register_File(
		// Outputs
		.RsData(Rs_data),
		.RtData(Rt_data),
		// Inputs
		.RsAddr(Instruction[25:21]),
		.RtAddr(Instruction[20:16]),
		.RdAddr(RdAddr),
		.RdData(Rd_data),
		.RegWrite(Reg_w),
		.clk(clk)
	);

	Control Control_Unit(
		// Outputs
		.RegDst(Reg_dst),
		.RegWrite(Reg_w),
		.ALU_op(ALU_op),
		.ALU_src(ALU_src),
		.Mem_w(Mem_w),
		.Mem_r(Mem_r),
		.Mem_to_Reg(Mem_to_reg),
		.Branch(Branch),
		.Jump(Jump),
		// Inputs
		.opcode(Instruction[31:26])
	);

	GPRMUX ALU_MUX(
		// Outputs
		.data(ALU_src2),
		// Inputs
		.src1(Rt_data),
		.src2(imm),
		.ctrl(ALU_src)
	);

	ALU_Control ALU_Control_Unit(
		// Outputs
		.funct(funct),
		// Inputs
		.ALU_op(ALU_op),
		.funct_ctrl(Instruction[5:0])
	);

	ALU ALU1(
		// Outputs
		.ALU_result(ALU_result),
		.Zero(Zero),
		// Inputs
		.data1(Rs_data),
		.data2(ALU_src2),
		.shamt(Instruction[10:6]),
		.funct(funct)
	);

	DM Data_Memory(
		// Outputs
		.Mem_r_data(Mem_r_data),
		// Inputs
		.Mem_addr(ALU_result),
		.Mem_w_data(Rt_data),
		.Mem_w(Mem_w),
		.Mem_r(Mem_r),
		.clk(clk)
	);

	GPRMUX Mem_MUX1(
		// Outputs
		.data(Rd_data),
		// Inputs
		.src1(ALU_result),
		.src2(Mem_r_data),
		.ctrl(Mem_to_reg)
	);


endmodule
