#TODO
opcode_map = {
    'movt': '1011',
    'cmp': '1100',
    'lsl': '1101',
    'rsl': '1111',
    'movi': '1110',
    'sub': '0111',
    'ldr': '1000',
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
    'R0': '0000',
    'R1': '0001',
    'R2': '0010',
    'R3': '0011',
    'R4': '0100',
    'R5': '0101',
    'R6': '0110',
    'R7': '0111',
    'R8': '1000',
    'R9': '1001',
    'R10': '1010',
    'R11': '1011',
    'R12': '1100',
    'R13': '1101',
    'R14': '1110',
    'R15': '1111',
}

def assemble_instruction(instruction):
    parts = instruction.split()
    opcode = opcode_map[parts[0]]
    
    if parts[0] in ['movt', 'cmp', 'sub', 'ldr', 'str', 'movf', 'add', 'xor']:
        reg = register_map[parts[1]]
        return f"{opcode}0{reg}"
    
    elif parts[0] in ['lsl', 'movi', 'jeq', 'jnn', 'jmp', 'jc', 'jlt']:
        immediate = format(int(parts[1][1:]), '05b')
        return f"{opcode}{immediate}"
    
    else:
        raise ValueError("Unknown Instruction")

def assemble(assembly_code):
    binary_code = []
    for instruction in assembly_code.splitlines():
        binary_code.append(assemble_instruction(instruction))
    return binary_code

#example
assembly_code1 = """movt R1
cmp R1
lsl #2
"""

binary_code = assemble(assembly_code1)
for binary in binary_code:
    print(binary)
