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
			15: target = 17;
			16: target = 23;
			17: target = 46;
			19: target = 55;
			20: target = 61;
			18: target = 70;
			21: target = 75;
			22: target = 78;
			23: target = 82;
			24: target = 87;
			25: target = 91;
			26: target = 94;
			27: target = 98;
			28: target = 103;
			29: target = 108;
			30: target = 112;
			31: target = 116;
	default: target = 'b0;  // hold PC  
  endcase

endmodule

endmodule

