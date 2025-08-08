`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2024 12:22:46
// Design Name: 
// Module Name: MEM
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

 `define  INPUT_SWITCH__OUTPUT_7_SEGMENT
module MEM#(parameter DATA_MEM_SIZE=145722)(
 input clk,
 
 input byte_M, half_word_M,full_word_M,byteU_M,half_wordU_M,  //byte data,word data, halfword data
 
 input [31:0]  ALU_out_M,//byte address
 input [31:0]  reg_read_data_2_M, //Writng data into the memory


 input mem_read_M,
 input mem_write_M,
 output  [31:0]   mem_read_data_M
 
  
 //-----------Pheripheral Memory mapping  ports----------
    `ifdef INPUT_SWITCH__OUTPUT_7_SEGMENT
    
      , input [15:0] switch_in_data, //input [15:0] switch_in_data,
        output [31:0] display_7_seg_data
    `endif
 //---------------------------------
 
 

    );
  
 /// Data memory
  dataMemory#(DATA_MEM_SIZE) DataMemory(
    .clk(clk),  // Input: Clock signal
    .byte(byte_M),  // Input: Byte data
    .half_word(half_word_M),  // Input: Half-word data
    .full_word(full_word_M),  // Input: Full-word data
    .byteU(byteU_M),  // Input: Unsigned Byte data
    .half_wordU(half_wordU_M),  // Input: Unsigned Half-word data
    .mem_access_addr(ALU_out_M),  // Input: Memory access address (16-bit)
    .mem_write_data(reg_read_data_2_M),  // Input: Data to be written into memory (32-bit)
    .mem_write(mem_write_M),  // Input: Write enable signal
    .mem_read(mem_read_M),  // Input: Read enable signal
    .mem_read_data(mem_read_data_M)  // Output: Data read from memory (32-bit)
    
    
   //-----------Pheripheral Memory mapping  ports----------
    `ifdef INPUT_SWITCH__OUTPUT_7_SEGMENT  
    ,.switch_in_data(switch_in_data),
    .display_7_seg_data(display_7_seg_data)
     `endif                          
 //---------------------------------
  );  
endmodule