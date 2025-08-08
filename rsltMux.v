`timescale 1ns / 1ps

module rsltMux(
  input [31:0] ALU_out,
  input [31:0] mem_read_data,
  input [31:0] pc4,
//  input [31:0] PC_plusImm,
  input [31:0] immediate,
  input ld,
  input jal,
  input jalr,
  input lui,
  output reg [31:0] reg_write_data
);
    
// Write backing mux
always @* begin
  reg_write_data = ALU_out;
  if (ld)
    reg_write_data = mem_read_data;
  if (jal | jalr)
    reg_write_data = pc4;
  if (lui)
    reg_write_data = immediate;
    
end

endmodule