module PC_LUT #(parameter D=12)(
  input       [4:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb case(addr)
		
			// Program 1
			0: target = 10;
			1: target = 16;
			2: target = 45;
			3: target = 53;
			4: target = 56;
			5: target = 61;
			6: target = 64;
			7: target = 68;
			8: target = 72;
			9: target = 74;
			10: target = 78;
			11: target = 80;
			12: target = 85;
			13: target = 89;

			// Program 2
			14: target = 0;
			15: target = 0;
			16: target = 0;
			17: target = 0;
			18: target = 0;
			19: target = 0;
			20: target = 0;
			21: target = 0;
			22: target = 0;
			23: target = 0;
			24: target = 0;
			25: target = 0;
			26: target = 0;
			27: target = 0;
			28: target = 0;
			29: target = 0;
		
	default: target = 'b0;  // hold PC  
  endcase

endmodule

