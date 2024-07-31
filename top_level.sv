// sample top level design
module top_level(
  input        clk, reset, req, 
  output logic done);
  parameter D = 12,             // program counter width
    A = 3;             		  // ALU command bit width
  wire[D-1:0] target, 			  // jump 
              prog_ctr;
  
  // RegFile
  wire[7:0]   datA,datB,		  // from RegFile
              mux_alu_src, 		  // ALU's 2nd source
			  rslt,				  // alu output
  			  wr_reg_data;        // Write Data to RegFile       
  wire[4:0]   immed;			  // immediate value
  
  // PC
  wire  relj;                     // from control to PC; relative jump enable
  
  // Control Outputs
  logic UncdJmp,
  		RdMem,
  		WrMem,
  		JType,
  		IType,
  		WrReg,
  		Movf;
  logic[2:0] ALUOp;

  // Register File
	logic[7:0] dat_out,
						 dat_acc_out,
					   dat_flag_out;
  
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code

	// Data Memory
	logic[7:0] mem_data;
  
  wire[2:0] rd_addr, wr_addr;
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
               .UncdJmp,
               .RdMem,
               .WrMem,
               .JType,
               .IType,
               .WrReg,
               .Movf,
               .ALUOp);

  assign rd_addr = mach_code[4:1];
  assign alu_cmd  = mach_code[8:5];
  assign immed = mach_code[4:0]; // ******** Might need to be sign extended *****
  assign wr_addr = (Movf) ? rd_addr : 0; // decides destination reg between operand reg (for movf) & R0
  assign wr_reg_data = (RdMem) ? mem_data : rslt; // decides between Memory Data (Ld) and ALU Result (all other instructions)
  
	reg_file #(.pw(3)) rf1(
      .dat_in(wr_reg_data),	   // loads, most ops
      .wr_en(WrReg),
		.rd_addr,
		.wr_addr,
		.dat_out, // operand register data
		.dat_acc_out, // accumulator register data
		.dat_flag_out // status register data
	);
  
  assign mux_alu_src = IType ? immed : dat_out; // decides ALU 2nd source between immediate value and operand register data

  alu alu1(.alu_cmd(),
         .inA    (datA),
		 .inB    (muxB),
		 .rslt       
     ); 

  dat_mem dm1(.dat_in(dat_acc_out)  ,  // the write data is in R0
             .clk           ,
			 .wr_en  (WrMem), // stores
              .addr   (dat_out), // address is operand register
             .mem_data);

  assign done = prog_ctr == 128;

endmodule