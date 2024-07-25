#TODO
opcode_map = {
    'movt': '1011',
    'cmp': '1100',
    'lsl': '1101',
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
