// control decoder
module Control #(parameter opwidth = 3, mcodebits = 4)(
  input [mcodebits-1:0] instr,    // subset of machine code (any width you need)
  output logic RegDst, Branch, 
     MemtoReg, MemWrite, ALUSrc, RegWrite,
  output logic[opwidth-1:0] ALUOp
  output logic UncondJump, RdMem, WrMem, JType, IType, RegWrite, Movf
);	   // for up to 8 ALU operations

always_comb begin
// defaults
  RegDst 	=   'b0;   // 1: not in place  just leave 0
  Branch 	=   'b0;   // 1: branch (jump)
  MemWrite  =	'b0;   // 1: store to memory
  ALUSrc 	=	'b0;   // 1: immediate  0: second reg file output
  RegWrite  =	'b1;   // 0: for store or no op  1: most other operations 
  MemtoReg  =	'b0;   // 1: load -- route memory instead of ALU to reg_file data in
  
  UncdJmp	=   'b0;
  RdMem		=	'b0;
  WrMem		= 	'b0;
  JType		=	'b0;
  IType		=	'b0;
  RegWrite	=	'b1;
  Movf		=	'b0;
  ALUOp	    =   'b111; // y = a+0;
  
  
  
// sample values only -- use what you need
case(instr)    // override defaults with exceptions
  'b0000:  begin					// store operation
               MemWrite = 'b1;      // write to data mem
               RegWrite = 'b0;      // typically don't also load reg_file
			 end
  'b00001:  ALUOp      = 'b000;  // add:  y = a+b
  'b00010:  begin				  // load
			   MemtoReg = 'b1;    // 
             end
// ...
  
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