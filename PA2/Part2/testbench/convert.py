funct_table = {"ADDU": 0b001011, "SUBU": 0b001101, "SLL": 0b100110, "SLLV": 0b110110}
opcode_table = {
    "ADDI": 0b001100,
    "SUBI": 0b001101,
    "SW": 0b010000,
    "LW": 0b010001,
    "SLTI": 0b101010,
    "BEQ": 0b010011,
    "J": 0b011100,
}
register_table = {
    "$zero": 0,
    "$at": 1,
    "$v0": 2,
    "$v1": 3,
    "$a0": 4,
    "$a1": 5,
    "$a2": 6,
    "$a3": 7,
    "$t0": 8,
    "$t1": 9,
    "$t2": 10,
    "$t3": 11,
    "$t4": 12,
    "$t5": 13,
    "$t6": 14,
    "$t7": 15,
    "$s0": 16,
    "$s1": 17,
    "$s2": 18,
    "$s3": 19,
    "$s4": 20,
    "$s5": 21,
    "$s6": 22,
    "$s7": 23,
    "$t8": 24,
    "$t9": 25,
    "$k0": 26,
    "$k1": 27,
    "$gp": 28,
    "$sp": 29,
    "$fp": 30,
    "$ra": 31,
}


def twos_complement(number, bit_width):
    # Convert number to positive binary representation
    positive_binary = bin(abs(number))[2:]

    # Pad with zeros to reach the desired bit width
    positive_binary = positive_binary.zfill(bit_width)

    if number < 0:
        # Take the bitwise NOT of the positive binary representation
        inverted_binary = "".join("1" if bit == "0" else "0" for bit in positive_binary)

        # Add 1 to the inverted binary representation
        inverted_plus_one = bin(int(inverted_binary, 2) + 1)[2:]

        # Pad with zeros to reach the desired bit width
        inverted_plus_one = inverted_plus_one.zfill(bit_width)

        return inverted_plus_one
    else:
        return positive_binary.zfill(bit_width)


def convert_to_binary(instructions):
    machine_code = ""
    label_addresses = {}
    current_address = 0

    for instruction in instructions:
        instruction = instruction.strip()
        if ":" in instruction:
            # If the instruction is a label, record its address
            label = instruction.split(":")[0]
            label_addresses[label] = current_address
            instruction = instruction.split(":")[1].strip()
        current_address += 1

    current_address = 0
    for instruction in instructions:
        instruction = instruction.strip()
        if ":" in instruction:
            instruction = instruction.split(":")[1].strip()
        instruction = instruction.split()
        instruction[0] = instruction[0].upper()
        args = "".join(instruction[1:]).split(",")
        # R-type
        if instruction[0] == "SLL":
            funct = funct_table[instruction[0]]
            rs = register_table[args[1]]
            rt = register_table["$zero"]
            rd = register_table[args[0]]
            shamt = int(args[2])
            machine_code += f"10000000{rs:05b}{rt:05b}{rd:05b}{shamt:05b}{funct:06b}\n"
        elif instruction[0] in funct_table:
            funct = funct_table[instruction[0]]
            rs = register_table[args[1]]
            rt = register_table[args[2]]
            rd = register_table[args[0]]
            machine_code += f"1000000{rs:05b}{rt:05b}{rd:05b}00000{funct:06b}\n"
        # J-type
        elif instruction[0] == "J":
            opcode = opcode_table[instruction[0]]
            imm = label_addresses.get(args[0], -1)
            if imm == -1:
                imm = twos_complement(int(args[0]), 26)
            else:
                imm = twos_complement(imm, 26)
            machine_code += f"1{opcode:06b}{imm}\n"
        elif instruction[0] == "SW" or instruction[0] == "LW":
            opcode = opcode_table[instruction[0]]
            rs = register_table[args[1].split("(")[1].replace(")", "")]
            rt = register_table[args[0]]
            imm = twos_complement(int(args[1].split("(")[0]), 16)
            machine_code += f"1{opcode:06b}{rs:05b}{rt:05b}{imm}\n"
        # I-type
        elif instruction[0] in opcode_table:
            opcode = opcode_table[instruction[0]]
            rs = register_table[args[1]]
            rt = register_table[args[0]]
            imm = label_addresses.get(args[2], -1)
            if imm == -1:
                imm = twos_complement(int(args[2]), 16)
            else:
                if instruction[0] == "BEQ":
                    imm = twos_complement(imm - current_address - 1, 16)
                else:
                    imm = twos_complement(imm, 16)

            machine_code += f"1{opcode:06b}{rs:05b}{rt:05b}{imm}\n"
        else:
            continue
        current_address += 1

    return machine_code, label_addresses


with open("testbench/program.txt", "r") as f:
    instructions = f.readlines()

    machine_code, labels = convert_to_binary(instructions)
    machine_code = machine_code.split("\n")[:-1]
    for i in range(len(machine_code)):
        print(f"{i}: {hex(int(machine_code[i], 2))[3:]}")
    print("Labels:", labels)

with open("testbench/IM.dat", "w") as f:
    # Output:
    byte = 0
    for code in machine_code:
        h = hex(int(code, 2))[3:]
        # from highest byte write to lowest byte
        f.write(f"{h[0:2]}\n")
        f.write(f"{h[2:4]}\n")
        f.write(f"{h[4:6]}\n")
        f.write(f"{h[6:8]}\n")
        byte += 4

    for _ in range(128 - byte):
        f.write("FF\n")
