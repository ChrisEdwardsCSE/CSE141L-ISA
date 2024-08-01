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

	wire flag;
  
  // PC
  wire  relj;                     // from control to PC; relative jump enable
	logic jump_en;
  // Control Outputs
  logic UncdJmp,
  		RdMem,
  		WrMem,
  		JType,
  		IType,
  		WrReg,
  		Movf;
  logic[2:0] ALUOp;
	logic[3:0] op_code;
  // Register File
	logic[7:0] dat_out,
						 dat_acc_out,
					   dat_status_out;
  
  wire[A-1:0] alu_cmd;
  wire[8:0]   mach_code;          // machine code

	// Data Memory
	logic[7:0] mem_data;
  
  wire[3:0] rd_addr, wr_addr;
	logic[3:0] oper_reg;

	wire[4:0] jump_addr;

// fetch subassembly
  PC #(.D(D)) 					  // D sets program counter width
     pc1 (.reset            ,
         .clk              ,
		 .jump_en,
		 .target           ,
		 .prog_ctr          );
	assign jump_en = ((dat_status_out & JType) | UncdJmp); // whether jump or prog_ctr++

// lookup table to facilitate jumps/branches
  PC_LUT #(.D(D))
    pl1 (.addr  (jump_addr),
         .target          );   

// contains machine code
  instr_ROM ir1(.prog_ctr,
               .mach_code);

	assign op_code = mach_code[8:5];	// instruction opcode
	assign oper_reg = mach_code[4:1]; // operand register
  assign immed = mach_code[4:0]; // immediate value ******** Might need to be sign extended *****
	assign jump_addr = mach_code[4:0]; // jump target index to PC lookup table

  

// control decoder ****************** FIX
  Control ctl1(.instr(op_code),
               .UncdJmp,
               .RdMem,
               .WrMem,
               .JType,
               .IType,
               .WrReg,
               .Movf,
               .ALUOp);


  assign wr_addr = (Movf) ? oper_reg : 0; // decides destination register: between operand reg (for movf) & R0
  
	reg_file #(.pw(3)) rf1(
			.clk,
			.flag,
      .dat_in(wr_reg_data),	   // loads, most ops
      .wr_en(WrReg),
		.rd_addr(oper_reg), // register read address
		.wr_addr, // register write address
		.dat_out, // operand register data
		.dat_acc_out, // accumulator register data
		.dat_status_out // status register data
	);
  
  assign mux_alu_src = IType ? immed : dat_out; // decides ALU 2nd source between immediate value and operand register data

  alu alu1(.alu_cmd(ALUOp),
         .inA    (dat_acc_out),
		 .inB    (mux_alu_src),
		 .flag,
		 .rslt       
     ); 

  dat_mem dm(.dat_in(dat_acc_out)  ,  // the write data is in R0
             .clk           ,
			 .wr_en  (WrMem), // stores
              .addr   (dat_out), // address is operand register
             .mem_data);

	assign wr_reg_data = (RdMem) ? mem_data : rslt; // decides between Memory Data (Ld) and ALU Result (all other instructions)

  assign done = prog_ctr == 100;

endmodule