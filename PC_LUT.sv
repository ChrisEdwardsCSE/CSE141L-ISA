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
			15: target = 13;
			16: target = 16;
			17: target = 42;
			18: target = 66;
			19: target = 51;
			20: target = 57;
			21: target = 71;
			22: target = 74;
			23: target = 78;
			24: target = 83;
			25: target = 87;
			26: target = 90;
			27: target = 94;
			28: target = 99;
			29: target = 104;
			30: target = 108;
			31: target = 112;
		
	default: target = 'b0;  // hold PC  
  endcase

endmodule

