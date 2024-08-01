// cache memory/register file
// default address pointer width = 4, for 16 registers
module reg_file #(parameter pw=4)(
  input[7:0] dat_in,
  input		 flag,
  input      clk,
  input      wr_en,           // write enable
  input[pw:0] wr_addr,		  // write address pointer, either R0 or movf reg
              rd_addr,		  // read address pointers
  output logic[7:0] dat_out, // operand register data
  					dat_acc_out, // acc register data
  output logic		dat_status_out // status register data (flag)
);

  logic[7:0] core[2**pw];    // 2-dim array  8 wide  16 deep

// reads are combinational
  assign dat_out = core[rd_addr];  // read operand register
  assign dat_acc_out = core[0];    // read accumulator register
  assign data_status_out = core[15]; // read status register

// writes are sequential (clocked)
  always_ff @(posedge clk)
	  if(wr_en)				   // anything but stores or no ops
        begin
          core[wr_addr] <= dat_in; // write data to R0 or movf reg
          core[15] <= flag; // set status register to flags
        end

endmodule