module modules_tb;

	logic[2:0] alu_cmd;
	logic[7:0] a, b, result;
	logic flag_test;
	logic done = 'b0;

	alu ALU1(.alu_cmd(alu_cmd),
							.inA(a), .inB(b), .rslt(result),
							.flag(flag_test));

	initial begin
		#1ns
		alu_cmd = 3'b000;
		a = 5;
		b = 6;
		#1ns $display("result: %d, flag: %d", result, flag_test);
		#10ns a = 0;
		b = 20;
		$display("result: %d, flag: %d", result, flag_test);

		

		// subtract test lt
		#10ns alu_cmd = 3'b110;
		a = 3;
		b = 6;

		// subtract test not lt
		#10ns alu_cmd = 3'b110;
		a = 8;
		b = 6;
		$display("result: %d, flag: %d", result, flag_test);
		
		// cmp test not equal
		#10ns alu_cmd = 3'b111;
		a = 3;
		b = 2;

		// cmp test equal
		#10ns a = 4;
		b = 4;

		// lsl test c=1
		#10ns alu_cmd = 'b001;
		a = 8'b10000000;
		b = 1;

		// lsl test c=0
		#10ns a = 8'b10000000;
		b = 3;
		
		#40ns done = 'b1;
	end
endmodule
