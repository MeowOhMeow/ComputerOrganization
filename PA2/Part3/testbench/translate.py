def R_type(machine_code, R_table, width=10):
    opcode = machine_code >> 26
    rs = (machine_code >> 21) & 0x1F
    rt = (machine_code >> 16) & 0x1F
    rd = (machine_code >> 11) & 0x1F
    shamt = (machine_code >> 6) & 0x1F
    funct = machine_code & 0x3F

    text = f"{R_table.get(funct, opcode)}"
    print(f"{text:<{width}}", end="")
    text = f"rs: {rs}"
    print(f"{text:<{width}}", end="")
    text = f"rt: {rt}"
    print(f"{text:<{width}}", end="")
    text = f"rd: {rd}"
    print(f"{text:<{width}}", end="")
    text = f"shamt: {shamt}"
    print(f"{text:<{width}}", end="")


def I_type(machine_code, I_table, width=10):
    opcode = machine_code >> 26
    rs = (machine_code >> 21) & 0x1F
    rt = (machine_code >> 16) & 0x1F
    imm = machine_code & 0xFFFF

    text = f"{I_table.get(opcode, opcode)}"
    print(f"{text:<{width}}", end="")
    text = f"op: {opcode}"
    print(f"{text:<{width}}", end="")
    text = f"rs: {rs}"
    print(f"{text:<{width}}", end="")
    text = f"rt: {rt}"
    print(f"{text:<{width}}", end="")
    text = f"imm: {imm}"
    print(f"{text:<{width}}", end="")


def translate(machine_code, tables):
    opcode = machine_code >> 26
    if opcode == 0:
        R_type(machine_code, tables[0])
    elif opcode == 0b011100:
        print("Jump to address {%d || PC[31:28]}" % (machine_code & 0x3FFFFFF), end="")
    else:
        I_type(machine_code, tables[1])


Rtable = {0b001011: "ADDU", 0b001101: "SUBU", 0b100110: "SLL", 0b110110: "SLLV"}
Itable = {
    0b001101: "SUBI",
    0b010000: "SW",
    0b010001: "LW",
    0b101010: "SLTI",
    0b010011: "BEQ",
}
tables = [Rtable, Itable]

with open("testbench/IM.dat", "r") as f:
    # _ = f.readline()

    while True:
        machine_code = ""
        for _ in range(4):
            line = f.readline()
            if not line:
                break
            machine_code += line[0:2]

        if not machine_code:
            break

        machine_code = int(machine_code, 16)
        translate(machine_code, tables)
        print()
