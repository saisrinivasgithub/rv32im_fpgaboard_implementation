`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2024 12:19:17
// Design Name: 
// Module Name: EX
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


module EX(
input[31:0] reg_read_data_1_E,
input[31:0] reg_read_data_2_E,
input [31:0]immediate_E,
input [31:0]PC_E,

//
output reg [31:0]rdata2_fd,

//control signals
input selRs2Imm_E,
input selRs1PC_E,

input [3:0] alu_op_E,

input [1:0]sn_E,
input Mul_en_E,Div_en_E,
input[1:0] M_sel_E, //To sel the out among DIV REM, LSB result and MSB relut
input result_sel_E ,     //Multiplication out or ALU rv32I out    
    

output [31:0]ALU_out_E,



//data forwarding 
input [1:0]ForwardAE,
input [1:0]ForwardBE,

input [31:0]mem_read_data_W,
input [31:0]ALU_out_M,
input [31:0]ALU_out_W
    );
    

 
//Forward mux 1---------
reg [31:0]rdata1_fd;
always @(*) begin
case(ForwardAE)
    2'b00: rdata1_fd=reg_read_data_1_E;
    2'b11: rdata1_fd=ALU_out_W;
    2'b01: rdata1_fd=mem_read_data_W;
    2'b10: rdata1_fd=ALU_out_M;
 endcase
end

//Forward mux 2-------------
//reg [31:0]rdata2_fd1;
always @(*) begin
case(ForwardBE)
    2'b00: rdata2_fd=reg_read_data_2_E;
    2'b11: rdata2_fd=ALU_out_W;
    2'b01: rdata2_fd=mem_read_data_W;
    2'b10: rdata2_fd=ALU_out_M;
 endcase
end


//ALU inputs 
reg [31:0]rdata1_i,rdata2_i;

always@(*)begin
rdata1_i =rdata1_fd;
rdata2_i=rdata2_fd;
if (selRs1PC_E==1'B1) begin     //auipc instruction
    rdata1_i = PC_E;end
if(selRs2Imm_E==1'b1)begin     
    rdata2_i =immediate_E ;  
end
end
      

  
 //ALU module of rv32im
 alu_rv32im alu_rv32im_instanc (
    // RV32I ALU ports
    .alu_op (alu_op_E),   // 4-bit input port
    .rdata1_i(rdata1_i),       // 32-bit input port
    .rdata2_i(rdata2_i),       // 32-bit input port
    .ALU_out (ALU_out_E), // 32-bit output port

    // M extension control signals
    .sn (sn_E),           // 2-bit input port
    .Mul_en (Mul_en_E),   // 1-bit input port
    .Div_en (Div_en_E),   // 1-bit input port
    .M_sel (M_sel_E),     // 2-bit input port
    .result_sel (result_sel_E)    // 1-bit input port
);
  
  
  
endmodule
