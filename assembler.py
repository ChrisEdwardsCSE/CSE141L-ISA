#TODO
opcode_map = {
    'movt': '1011',
    'cmp': '1100',
    'lsl': '1101',
    'rsl': '1111',
    'movi': '1110',
    'sub': '0111',
    'ld': '1000',
    'str': '1001',
    'movf': '1010',
    'jeq': '0011',
    'jnn': '0100',
    'add': '0101',
    'xor': '0110',
    'jmp': '0000',
    'jc': '0001',
    'jlt': '0010',
}
#TODO
register_map = {
    'r0': '0000',
    'r1': '0001',
    'r2': '0010',
    'r3': '0011',
    'r4': '0100',
    'r5': '0101',
    'r6': '0110',
    'r7': '0111',
    'r8': '1000',
    'r9': '1001',
    'r10': '1010',
    'r11': '1011',
    'r12': '1100',
    'r13': '1101',
    'r14': '1110',
    'r15': '1111',
}

def assemble_instruction(instruction):
    parts = instruction.split()
    opcode = opcode_map[parts[0]]
    
    
    if parts[0] in ['movt', 'cmp', 'sub', 'ld', 'str', 'movf', 'add', 'xor']:
        reg = register_map[parts[1]]
        print(reg)
        return f"{opcode}{reg}0"
    
    elif parts[0] in ['lsl', 'rsl', 'movi', 'jeq', 'jnn', 'jmp', 'jc', 'jlt']:
        immediate = format(int(parts[1][1:]), '05b')
        print(immediate)
        return f"{opcode}{immediate}"
    
    else:
        print(parts,opcode)
        raise ValueError("Unknown Instruction")

def assemble(assembly_code):
    binary_code = []
    for instruction in assembly_code.splitlines():
        binary_code.append(assemble_instruction(instruction))
    return binary_code

def write_binary_file(input_filename, output_filename):
    with open(input_filename, "r") as f:
        assembly_code = f.read()
    binary_code = assemble(assembly_code)
    with open(output_filename, "w") as f:
        for code in binary_code:
            f.write(f"{code}\n")

input_filename = "input1.txt"
output_filename = "mach_code.txt"

write_binary_file(input_filename, output_filename)
