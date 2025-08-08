`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2024 11:59:20
// Design Name: 
// Module Name: ID
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


module ID(
input clk,rst,

//Fetch data
input [31:0]PC_D,
input [31:0]instruction_D,

//decode computable data
output [4:0]reg_read_addr_1_D,
output [4:0]reg_read_addr_2_D,
output [31:0]reg_read_data_1_D,
output [31:0]reg_read_data_2_D,
output [31:0]reg_write_dest_D,
output [31:0]immediate_D,

//GPRs write back data
input [4:0]reg_write_dest_W,
input [31:0]reg_write_data_W,
input gprs_we_i_W,

//forwarded data for branch prediction
input [1:0]ForwardAD,
input [1:0]ForwardBD,
//forwardable data
input [31:0]mem_read_data_W,
input [31:0]ALU_out_M,
input [31:0]ALU_out_W,


//brach detectionsignal and data
output PCnew_D,
output [31:0]PCin1_D,

//Control signals
      output [3:0] alu_op_D,
      output  mem_read_D,mem_write_D,selRs2Imm_D,selRs1PC_D,gprs_we_i_D
      ,output ld_D
      ,output  jal_D
      ,output  jalr_D
      ,output  lui_D
      ,output  auipc_D
      ,output branch_instruction_D
      
   ,output byte_D, half_word_D,full_word_D,byteU_D,half_wordU_D,
output  [1:0]sn_D,
output  Mul_en_D,Div_en_D,
output [1:0] M_sel_D, //To sel the out among DIV REM, LSB result and MSB relut
output  result_sel_D      //Multiplication out or ALU rv32I out

,
output ebreak_D

,output rs1_valid_D,
output rs2_valid_D

);

//Forward mux 1---------
reg [31:0]rdata1_fd;
always @(*) begin
case(ForwardAD)
    2'b00: rdata1_fd=reg_read_data_1_D;
    2'b11: rdata1_fd=ALU_out_W;
    2'b01: rdata1_fd=mem_read_data_W;
    2'b10: rdata1_fd=ALU_out_M;
 endcase
end

//Forward mux 2-------------
reg [31:0]rdata2_fd;
always @(*) begin
case(ForwardBD)
    2'b00: rdata2_fd=reg_read_data_2_D;
    2'b11: rdata2_fd=ALU_out_W;
    2'b01: rdata2_fd=mem_read_data_W;
    2'b10: rdata2_fd=ALU_out_M;
 endcase
end



//instruction_D decode----
wire [6:0]opcode;
 assign opcode = instruction_D[6:0];
wire [2:0]funct3;
 assign funct3=instruction_D[14:12];
 wire [6:0]funct7;
  assign funct7=instruction_D[31:25];
  wire [24:0]immData=instruction_D[31:7];

//----------------------     
 
 //GPRs I/O wires   


 
     assign reg_write_dest_D=instruction_D[11:7];
  assign reg_read_addr_1_D=instruction_D[19:15];
  assign reg_read_addr_2_D=instruction_D[24:20] ;
GPRs reg_file
 (
  .clk(clk),
  .rst(rst),
  .we_i(gprs_we_i_W),
  .waddr_i(reg_write_dest_W),
  .wdata_i(reg_write_data_W),
  .raddr1_i(reg_read_addr_1_D),
  .rdata1_o(reg_read_data_1_D),
  .raddr2_i(reg_read_addr_2_D),
  .rdata2_o(reg_read_data_2_D)
 );
 
  //immediate_D

 wire [2:0]ImmOp;   //immetiate format decoding signal 
 ImmGen  imgen(immData,ImmOp,immediate_D);
 
 //system instructions
 wire ecall, ebreak;

 
//conrol unit signals

  rv32im_controlpath cntrolunit (
    .opcode(opcode),
      .funct3(funct3),
    .funct7(funct7),
    .in_20(instruction_D[20]),
    
    .alu_op(alu_op_D),
    .mem_read(mem_read_D),
    .mem_write(mem_write_D),
    .selRs2Imm(selRs2Imm_D),
    .selRs1PC(selRs1PC_D),
    .gprs_we_i(gprs_we_i_D),
    .ld(ld_D),
    
    .ImmOp(ImmOp),
    .jal(jal_D),
    .jalr(jalr_D),
    .lui(lui_D),
    .auipc(auipc_D),
    .branch_instruction(branch_instruction_D),

    .byte(byte_D),  .half_word(half_word_D),  .full_word(full_word_D),  .byteU(byteU_D), .half_wordU(half_wordU_D)
  ,.sn(sn_D),
.Mul_en(Mul_en_D), .Div_en(Div_en_D),
.M_sel(M_sel_D),
.result_sel(result_sel_D),
.ecall(ecall),
.ebreak(ebreak),
.rs1_valid(rs1_valid_D),
.rs2_valid(rs2_valid_D)
  );

assign ebreak_D=ebreak;

 
 /*
 //Brach detector
 branch_jump_detection branch_jump_detection_inst (
    .jal(jal),
    .jalr(jalr),
    .branch_instruction(branch_instruction_D),
    .rdata1_o(rdata1_o),
    .rdata2_o(rdata2_o),
    .immediate(immediate_D),
    .PC(PC_D),
    .PCnew(PCnew_D),
    .PCTarget(PCTarget)
);
*/




//wire [31:0]PCin1_D;
 //Brach detector

 branch_jump_detection  branch_jump_detection_inst (
    .jal(jal_D),
    .jalr(jalr_D),
    .branch_instruction(branch_instruction_D),
    .rdata1_o(rdata1_fd),
    .rdata2_o(rdata2_fd),
    .PC(PC_D),
    .PCnew(PCnew_D),
    .PCin1(PCin1_D),
    .funct3(funct3)
);


endmodule
