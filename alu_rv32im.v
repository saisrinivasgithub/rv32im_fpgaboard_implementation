`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2024 14:17:17
// Design Name: 
// Module Name: alu_rv32im
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


module alu_rv32im#(parameter DATA_MEM_SIZE= 80000,INSTR_SIZE= 80000)(
//rv32i alu ports
input [3:0] alu_op,
input [31:0] rdata1_i,
input [31:0] rdata2_i,
    output  [31:0] ALU_out,
    output  lsr,
    output  gtr,
    output  eql
//M extenion control signals
,
input [1:0]sn,
input Mul_en,Div_en,
input[1:0] M_sel, //To sel the out among DIV REM, LSB result and MSB relut
input result_sel      //Multiplication out or ALU rv32I out    
    
    
);
wire [31:0] AB_msb;
wire [31:0] AB_lsb;
wire [31:0] AbyB_REM;
wire [31:0] AbyB_QUO;
wire [31:0]alu_rv32i_result;    
aluUnit  alu_instance_rv32im(rdata1_i, rdata2_i, alu_op, alu_rv32i_result,gtr,lsr,eql);

MExtension mextns_instce(
    // Input ports
    .Mul_en(Mul_en),    // Multiplication enable input
    .Div_en(Div_en),    // Division enable input
    .A(rdata1_i),              // 32-bit input A
    .B(rdata2_i),              // 32-bit input B
    .Sign(sn),        // 2-bit input Sign

    // Output ports
    .AB_msb(AB_msb),    // 32-bit output AB_msb
    .AB_lsb(AB_lsb),    // 32-bit output AB_lsb
    .AbyB_REM(AbyB_REM),// 32-bit output AbyB_REM
    .AbyB_QUO(AbyB_QUO) // 32-bit output AbyB_QUO
);

reg [31:0]M_extension_result;
//Mux to selct the results from the M extension 
always@(*)begin
case(M_sel)
    2'b00:M_extension_result=AbyB_QUO;
    2'b01:M_extension_result=AbyB_REM;
    2'b10:M_extension_result=AB_lsb;
    2'b11:M_extension_result=AB_msb;
endcase
end

//Mux to select the result form the rv32i alu or M extesnion 
assign ALU_out=result_sel?M_extension_result:alu_rv32i_result;
endmodule 