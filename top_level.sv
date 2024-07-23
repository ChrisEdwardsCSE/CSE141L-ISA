// sample top level design
module top_level(
  input        clk, reset, req, 
  output logic done);
  parameter D = 12,             // program counter width
    A = 3;             		  // ALU command bit width
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  wire        RegWrite;
  wire[7:0]   datA,datB,		  // from RegFile
              mux_alu_src, 
			  rslt,               // alu output
              immed;
  logic sc_in,   				  // shift/carry out from/to ALU
   		pariQ,              	  // registered parity flag from ALU
		zeroQ;                    // registered zero flag from ALU 
  wire  relj;                     // from control to PC; relative jump enable
  wire  pari,
        zero,
		sc_clr,
		sc_en,
        MemWrite,
        ALUSrc;		              // immediate switch
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code
  wire[2:0] rd_addrA, rd_adrB;    // address pointers to reg_file
// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		 .reljump_en (relj),
		 .absjump_en (absj),
		 .target           ,
		 .prog_ctr          );

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (how_high),
         .target          );   

// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

// control decoder ****************** FIX
  Control ctl1(.instr(),
               .UncondJump,
               .RdMem,
               .WrMem,
               .JType,
               .IType,
               .RegWrite,
               .Movf,
               ALUOp);

  assign rd_addr = mach_code[4:1];
  assign alu_cmd  = mach_code[8:5];
  assign wr_addr = (Movf) ? rd_addr : 0; // decides destination reg between operand reg (for movf) & R0
  
	reg_file #(.pw(3)) rf1(
      	.dat_in(mem_data),	   // loads, most ops
		.wr_en(RegWrite),
		.rd_addr,
		.wr_addr,
		.dat_out, // operand register data
		.dat_acc_out, // accumulator register data
		.dat_flag_out, // status register data
	);
  
  assign mux_alu_src = IType? immed : dat_out; // decides ALU 2nd source between immediate value and operand register data

  alu alu1(.alu_cmd(),
         .inA    (dat_out),
		 .inB    (mux_alu_src),
		 .sc_i   (sc),   // output from sc register
		 .rslt       ,
		 .sc_o   (sc_o), // input to sc register
		 .pari  );  

  dat_mem dm1(.dat_in(dat_acc_out)  ,  // the write data is in R0
             .clk           ,
			 .wr_en  (MemWrite), // stores
              .addr   (dat_out), // address is operand register
             .mem_data());

// registered flags from ALU
  always_ff @(posedge clk) begin
    pariQ <= pari;
	zeroQ <= zero;
    if(sc_clr)
	  sc_in <= 'b0;
    else if(sc_en)
      sc_in <= sc_o;
  end

  assign done = prog_ctr == 128;
 
endmodule