// combinational -- no clock
// sample -- change as desired
module alu(
  input[2:0] alu_cmd,    // ALU instructions
  input[8:0] inA, inB,	 // 9-bit wide data path
  input      sc_i,       // shift_carry in
  output logic[8:0] rslt,
  output logic flag		 // jump flag
);

always_comb begin 
  rslt =  'b0;
  flag =  'b0;               
  case(alu_cmd)
    // add, xor, sub, lsl, cmp
    3'b000: // add 2 9-bit unsigned
      rslt = inA + inB;
	  3'b001: // left_shift
      // operator left shift **CANNOT LEFT SHIFT MORE THAN 9 (length of reg)**
      flag = rslt[9-inB];
      rslt = rslt << inB;
    3'b011: // bitwise XOR
	    rslt = inA ^ inB;
	  3'b110: // subtract
	    rslt = inA - inB;
      if (inB - inA) > 0 begin
        flag = 'b1;
      end
	  3'b111: // cmp
      if (inA - inB) == 0 begin
        flag = 'b1;
      end
  endcase
end
   
endmodule