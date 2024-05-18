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
module R_PipelineCPU(
	// Outputs
	output	wire	[31:0]	Output_Addr,
	// Inputs
	input	wire	[31:0]	Input_Addr,
	input	wire			clk
);
	// IF stage
	wire [31:0] instr;

	// ID stage
	// IF2ID's outputs
	wire [31:0] instr_out;
	// connections in ID stage
	wire [31:0] Rs_data, Rt_data;
	wire RegDst, RegWrite, ALU_src, MemW, MemR, Mem2Reg;
	wire [1:0] ALU_op;
	wire [31:0] imm;

	// EX stage
	// ID2EX's outputs
	wire [31:0] Rs_data_out, Rt_data_ID2EX_out;
	wire [4:0] RtAddr_ID2EX_out, RdAddr_ID2EX_out;
	wire RegDst_out, RegWrite_ID2EX_out, ALU_src_out, MemW_ID2EX_out, MemR_ID2EX_out, Mem2Reg_ID2EX_out;
	wire [1:0] ALU_op_out;
	wire [31:0] imm_out;
	// connections in EX stage
	wire [31:0] ALU_src2;
	wire [5:0] funct;
	wire [31:0] ALU_result;
	wire [4:0] RdAddr_EX;

	// MEM stage
	// EX2MEM's outputs
	wire MemW_EX2MEM_out, MemR_EX2MEM_out, Mem2Reg_EX2MEM_out, RegWrite_EX2MEM_out;
	wire [31:0] ALUResult_EX2MEM_out;
	wire [31:0] Rt_data_EX2MEM_out;
	wire [4:0] RdAddr_EX2MEM_out;
	// connections in MEM stage
	wire [31:0] Mem_r_data;

	// WB stage
	// MEM2WB's outputs
	wire Mem2Reg_MEM2WB_out, RegWrite_MEM2WB_out;
	wire [31:0] ALUResult_MEM2WB_out;
	wire [31:0] Mem_r_data_MEM2WB_out;
	wire [4:0] RdAddr_MEM2WB_out;
	// connections in WB stage
	wire [31:0] Rd_data;

	// sign extend imm
	assign imm = { {16{instr_out[15]}}, instr_out[15:0] };

	// IF stage
	Adder NextAddr(
		// Outputs
		.OutputAddr(Output_Addr),
		// Inputs
		.InputAddr(Input_Addr),
		.Offset(32'h4)
	);

	IM Instr_Memory(
		// Outputs
		.Instruction(instr),
		// Inputs
		.InputAddr(Input_Addr)
	);

	// IF2ID stage
	IF_ID IF2ID(
		// Outputs
		.instr_out(instr_out),
		// Inputs
		.instr(instr),
		.clk(clk)
	);
	
	// ID(WB) stage
	RF Register_File(
		// Outputs
		.RsData(Rs_data),
		.RtData(Rt_data),
		// Inputs
		.RsAddr(instr_out[25:21]),
		.RtAddr(instr_out[20:16]),
		.RdAddr(RdAddr_MEM2WB_out),
		.RdData(Rd_data),
		.RegWrite(RegWrite_MEM2WB_out),
		.clk(clk)
	);

	Control Control_Unit(
		// Outputs
		.RegDst(RegDst),
		.RegWrite(RegWrite),
		.ALU_op(ALU_op),
		.ALU_src(ALU_src),
		.Mem_w(MemW),
		.Mem_r(MemR),
		.Mem_to_Reg(Mem2Reg),
		// Inputs
		.opcode(instr_out[31:26])
	);

	// ID2EX stage
	ID_EX ID2EX(
		// Outputs
		.RegDst_out(RegDst_out),
		.RegWrite_out(RegWrite_ID2EX_out),
		.ALU_op_out(ALU_op_out),
		.ALU_src_out(ALU_src_out),
		.Mem_w_out(MemW_ID2EX_out),
		.Mem_r_out(MemR_ID2EX_out),
		.Mem_to_Reg_out(Mem2Reg_ID2EX_out),
		.rs_out(Rs_data_out),
		.rt_out(Rt_data_ID2EX_out),
		.rt_addr_out(RtAddr_ID2EX_out),
		.rd_addr_out(RdAddr_ID2EX_out),
		.imm_out(imm_out),
		// Inputs
		.RegDst(RegDst),
		.RegWrite(RegWrite),
		.ALU_op(ALU_op),
		.ALU_src(ALU_src),
		.Mem_w(MemW),
		.Mem_r(MemR),
		.Mem_to_Reg(Mem2Reg),
		.rs(Rs_data),
		.rt(Rt_data),
		.rt_addr(instr_out[20:16]),
		.rd_addr(instr_out[15:11]),
		.imm(imm),
		.clk(clk)
	);

	// EX stage
	RegMUX Reg_MUX1(
		// Outputs
		.RegDst(RdAddr_EX),
		// Inputs
		.Rt(RtAddr_ID2EX_out),
		.Rd(RdAddr_ID2EX_out),
		.RegDst_ctrl(RegDst_out)
	);

	GPRMUX ALU_MUX(
		// Outputs
		.data(ALU_src2),
		// Inputs
		.src1(Rt_data_ID2EX_out),
		.src2(imm_out),
		.ctrl(ALU_src_out)
	);

	ALU_Control ALU_Control_Unit(
		// Outputs
		.funct(funct),
		// Inputs
		.ALU_op(ALU_op_out),
		.funct_ctrl(imm_out[5:0])
	);

	ALU ALUInstance(
		// Outputs
		.ALU_result(ALU_result),
		// Inputs
		.data1(Rs_data_out),
		.data2(ALU_src2),
		.shamt(imm_out[10:6]),
		.funct(funct)
	);

	// EX2MEM stage
	EX_MEM EX2MEM(
		// Outputs
		.ALU_result_out(ALUResult_EX2MEM_out),
		.Rt_data_out(Rt_data_EX2MEM_out),
		.RdAddr_out(RdAddr_EX2MEM_out),
		.MemW_out(MemW_EX2MEM_out),
		.MemR_out(MemR_EX2MEM_out),
		.Mem2Reg_out(Mem2Reg_EX2MEM_out),
		.RegWrite_out(RegWrite_EX2MEM_out),
		// Inputs
		.ALU_result(ALU_result),
		.Rt_data(Rt_data_ID2EX_out),
		.RdAddr(RdAddr_EX),
		.MemW(MemW_ID2EX_out),
		.MemR(MemR_ID2EX_out),
		.Mem2Reg(Mem2Reg_ID2EX_out),
		.RegWrite(RegWrite_ID2EX_out),
		.clk(clk)
	);

	// MEM stage
	DM Data_Memory(
		// Outputs
		.Mem_r_data(Mem_r_data),
		// Inputs
		.Mem_addr(ALUResult_EX2MEM_out),
		.Mem_w_data(Rt_data_EX2MEM_out),
		.Mem_w(MemW_EX2MEM_out),
		.Mem_r(MemR_EX2MEM_out),
		.clk(clk)
	);

	// MEM2WB stage
	MEM_WB Mem_WB(
		// Outputs
		.ALUResult_out(ALUResult_MEM2WB_out),
		.Mem_r_data_out(Mem_r_data_MEM2WB_out),
		.RdAddr_out(RdAddr_MEM2WB_out),
		.Mem2Reg_out(Mem2Reg_MEM2WB_out),
		.RegWrite_out(RegWrite_MEM2WB_out),
		// Inputs
		.ALUResult(ALUResult_EX2MEM_out),
		.Mem_r_data(Mem_r_data),
		.RdAddr(RdAddr_EX2MEM_out),
		.Mem2Reg(Mem2Reg_EX2MEM_out),
		.RegWrite(RegWrite_EX2MEM_out),
		.clk(clk)
	);

	// WB stage
	GPRMUX Mem_MUX1(
		// Outputs
		.data(Rd_data),
		// Inputs
		.src1(ALUResult_MEM2WB_out),
		.src2(Mem_r_data_MEM2WB_out),
		.ctrl(Mem2Reg_MEM2WB_out)
	);

endmodule
