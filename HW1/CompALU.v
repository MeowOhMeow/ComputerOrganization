/*
 *	Template for Homework 1
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
module CompALU(
	//	Inputs
	input [31:0] Instruction,
	//	Outputs
	output [31:0] CompALU_data,
	output CompALU_zero,
	output CompALU_carry
);

	/* 
	 * Declaration of Register File.
	 * CAUTION: DONT MODIFY THE NAME.
	 */
	wire [31:0] Rs_data, Rt_data;
	RF Register_File(
		//Inputs
		.Rs_addr(Instruction[25:21]),
		.Rt_addr(Instruction[20:16]),
		//Outputs
		.Rs_data(Rs_data),
		.Rt_data(Rt_data)
	);

	// Declaration of ALU.
	ALU Arithmetic_Logic_Unit(
		//Inputs
		.Src_1(Rs_data),
		.Src_2(Rt_data),
		.Shamt(Instruction[10:6]),
		.Funct(Instruction[5:0]),
		//Outputs
		.ALU_result(CompALU_data),
		.Zero(CompALU_zero),
		.Carry(CompALU_carry)
	);

endmodule
