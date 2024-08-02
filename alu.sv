// combinational -- no clock
// sample -- change as desired
module alu(
  input[2:0] alu_cmd,    // ALU instructions
  input[7:0] inA, inB,	 // 9-bit wide data path
	input Movto,
  output logic[7:0] rslt,
  output logic flag		 // jump flag
);

always_comb begin 
  rslt =  'b0;
  flag =  'b0;
		begin               
  case(alu_cmd)
    // add, xor, sub, lsl, cmp
    3'b000: // add 2 9-bit unsigned
      rslt = inA + inB;
	  3'b001: // left_shift
			begin
      // operator left shift **CANNOT LEFT SHIFT MORE THAN 9 (length of reg)**
				flag = (inA >> (8-inB));
      	rslt = inA << inB;
			end
		3'b100: // Movt, Movi - just pass inB (oper reg or immed) to result
			rslt = inB;
		3'b010: // Movf - just pass inA (acc reg) to result
			rslt = inA;
    3'b101: // right shift
      rslt = inA >> inB;
    3'b011: // bitwise XOR
	    rslt = inA ^ inB;
	  3'b110: // subtract
			begin
	    	rslt = inA - inB;
      	if (inB > inA) begin
        	flag = 'b1;
      	end
			end
	  3'b111: // cmp
      if ((inA - inB) == 0) begin
        flag = 'b1;
      end
  endcase
	end
end
endmodule