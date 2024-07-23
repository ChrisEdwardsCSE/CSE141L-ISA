// control decoder
module Control #(parameter opwidth = 3, mcodebits = 4)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  output logic UncondJump, RdMem, WrMem, JType, IType, RegWrite, Movf,
  output logic[opwidth-1:0] ALUOp
);	   // for up to 8 ALU operations

always_comb begin
  UncdJmp	=   'b0; // Unconditional Jump
  RdMem		=	'b0; // Choose the memory data from mux, only on ld instructions
  WrMem		= 	'b0; // Write to memory enable, only on str
  JType		=	'b0; // J-type instruction? Links to AND gate for PC next value
  IType		=	'b0; // I-type instruction? The SEL for the mux for ALU 2nd source
  RegWrite	=	'b1; // Write to register enable
  Movf		=	'b0; // Instruction is movf?
  ALUOp	    =   'b0; // ALU Operation for alu.sv
  
case(instr)
  // Unconditional jump
  'b0000:
  	begin
      UncdJmp = 'b1;
      JType = 'b1;
      RegWrite = 'b0; // RegWrite disable on jumps
    end
  
  // Jumps
  'b0001,
  'b0010,
  'b0011,
  'b0100:
    begin
      JType = 'b1;
      RegWrite = 'b0;	// RegWrite disable on jumps
    end
  
  // Ld
  'b1000: RdMem = 'b1; 	// Read memory only on loads
  
  // Str
  'b0111: 
    begin
      WrMem = 'b1;		// Write memory only on stores
      RegWrite = 'b0;	// RegWrite disable on stores
    end
  
  // Lsl
  'b1101:
    begin
      IType = 'b1;
      ALUOp = 'b001; // ************ ALU OP ******************
    end
    
  // Movi
  'b1110: IType = 'b1;
  
  // Cmp
  'b1100: 
    begin
      RegWrite = 'b0; // RegWrite disable on cmp
      ALUOp = 'b111;
    end
  
  // Movf
  'b1010: Movf = 'b1;
      
      
  // Add
  'b0101: ALUOp = 3'b000;
       
  // Sub
  'b0111: ALUOp = 3'b110;
  
  // XOR
  'b0110: ALUOp = 3'b011;
  
endcase

end
	
endmodule