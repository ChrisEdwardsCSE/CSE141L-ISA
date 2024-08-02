module PC_LUT #(parameter D=12)(
  input       [4:0] addr,	   // target 4 values
  output logic[D-1:0] target);

  always_comb case(addr)
		
			// Program 1
			1: target = 9;
			2: target = 15;
			3: target = 48;
			4: target = 55;
			5: target = 58;
			6: target = 65;
			7: target = 68;
			8: target = 75;
			9: target = 79;
			10: target = 81;
			11: target = 85;
			12: target = 87;
			13: target = 92;
			14: target = 96;

			// Program 2
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
			30: target = 0;
		
	default: target = 'b0;  // hold PC  
  endcase

endmodule

