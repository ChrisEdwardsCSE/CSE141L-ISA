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

#example
# assembly_code1 = """movi #16
# movf r4 
# movi #1
# movf r3
# movi #0
# movf r1
# movf r2
# movf r14
# movf r15
# movf r5
# movi #31
# sub r1
# jlt #14
# movt r1
# add r3
# movf r2
# movt r2
# lsl  #1
# movf r15
# movi #31
# sub r1
# jlt #13
# movt r14
# ld r0
# movf r6
# movt r14
# add r3
# ld r0
# movf r7
# movt r15
# ld r0
# movf r8
# movt r15
# add r3
# ld r0
# movf r9
# movt r6
# xor r8
# movf r10
# movt r7
# xor r9
# movf r11
# movi #0
# movf r12
# movf r13
# movi #7
# sub  r12
# jlt  #8
# movt r10
# lsl  #1
# movf r10
# jc #4
# jmp #5
# movt r13
# add  r3
# movf r13
# movt r11
# lsl  #1
# movf r11
# jc #6
# jmp #7
# movt r13
# add r3
# movf r13
# movt r12 
# add r3
# movf r12
# jmp #3
# movt r5
# sub r13
# jlt #9
# jmp #10
# movt r13
# movf r5
# movt r13
# sub r4
# jlt #11
# jmp #12
# movt r13
# movf r4
# movt r2
# add r3
# movf r2
# jmp #2
# movt r1
# add r3
# movf r1
# jmp #1
# movi #64
# movf r1
# movt r4
# str r1
# movi #65
# movf r1
# movt r5
# str r1
# """

# binary_code = assemble(assembly_code1)
# for binary in binary_code:
#     print(binary)
numbers = [13604, 24193, -10743, 22115, 31501, -26227, -31643, 21010, -7423, -13043, -3722, -12995, 22509, -2164, -5639, 9414, -31547, -11606, -2075, 29303, -10734, -9329, 27122, -26930, 31464, 20165, 18780, 10429, 22573, 9829, 25187, -30966]

pairs = []
target_difference = 1

for i in range(len(numbers)):
    for j in range(i + 1, len(numbers)):
        if abs(numbers[i] - numbers[j]) == target_difference:
            pairs.append((numbers[i], numbers[j]))

print(pairs)