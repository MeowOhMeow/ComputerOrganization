table = {
    "addu": "001001",
    "subu": "001010",
    "and": "010001",
    "srl": "100010",
}

def to_bin(s, n=5):
    if s[0] == "$":
        return format(int(s[1:]), f"0{n}b")
    else:
        return format(int(s), f"0{n}b")

def parse_command_R(command: str):
    tokens = command.strip().split(" ")
    command = tokens[0].lower()
    destination, source, target = "".join(tokens[1:]).split(",")
    return command, destination, source, target


def convert_R(command, destination, source, target):
    opcode = "000000"
    source = to_bin(source)
    target = to_bin(target)
    destination = to_bin(destination)
    shamt = target
    funct = table.get(command, opcode)
    return f"{opcode}_{source}_{target}_{destination}_{shamt}_{funct}"


with open("testbench/helper/program.txt", "r") as in_file, open(
    "testbench/tb_CompALU.in", "w"
) as out_file:
    while True:
        line = in_file.readline()
        if not line:
            break

        command, destination, source, target = parse_command_R(line)
        machine_code = convert_R(command, destination, source, target)
        print(f"{line.rstrip():20s}: " + machine_code)
        out_file.write(machine_code + "\n")
