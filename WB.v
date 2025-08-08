`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2024 16:02:48
// Design Name: 
// Module Name: WB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module WB(
//input data
input [31:0]ALU_out_W,
input [31:0]mem_read_data_W,
input [31:0]PCplus4_W,
input [31:-0]immediate_W,

//control signal
  input ld_W,
  input jal_W,
  input jalr_W,
  input lui_W,

output [31:0]reg_write_data_W

);
    
    
    
  // write backing mux
   rsltMux writing_back_mux (
    .ALU_out(ALU_out_W),
    .mem_read_data(mem_read_data_W),
    .pc4(PCplus4_W),
    .immediate(immediate_W),
    .ld(ld_W),
    .jal(jal_W),
    .jalr(jalr_W),
    .lui(lui_W),
    .reg_write_data(reg_write_data_W)
  );
  
  
endmodule