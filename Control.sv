// control decoder
module Control #(parameter opwidth = 3, mcodebits = 4)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  output logic UncondJump, RdMem, WrMem, JType, IType, RegWrite, Movf,
  output logic[opwidth-1:0] ALUOp
);	   // for up to 8 ALU operations

always_comb begin
  UncdJmp	=   'b0;
  RdMem		=	'b0;
  WrMem		= 	'b0;
  JType		=	'b0;
  IType		=	'b0;
  RegWrite	=	'b1;
  Movf		=	'b0;
  ALUOp	    =   'b0;
  
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
      ALUOp = 'b0; // ************ ALU OP ******************
    end
    
  // Movi
  'b1110: IType = 'b1;
  
  // Cmp
  'b1100: 
    begin
      RegWrite = 'b0; // RegWrite disable on cmp
      ALUOp = 'b0; // subtraction ************ ALU OP ******************
    end
    
  // Movf
  'b1010: Movf = 'b1;
      
  // ************ ALU OPs ******************
      
  // Add
  'b0101: ALUOp = 'b0;
       
  // Sub
  'b0111: ALUOp = 'b0;
  
  // XOR
  'b0110: ALUOp = 'b0;
      
  // 
  
endcase

end
	
endmodule