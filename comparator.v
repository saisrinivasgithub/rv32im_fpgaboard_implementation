`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.04.2024 12:28:34
// Design Name: 
// Module Name: comparator
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


module comparator(
    
    input  [31:0] rdata1_o,         
    input  [31:0] rdata2_o   , 
    
    output lsr,lsrU,eql
    // gtr, gtrU, 
    

    );
    
         wire signed [31:0] op1, op2;
      assign op1 = rdata1_o;
  assign op2 = rdata2_o;
   wire zero_check;
 //assign zero_check=&(!result_out);
 
 
    
    
    wire [31:0]slT,sltU,xoR;
assign slT={31'd0,(op1 < op2)} ;
assign sltU={31'd0,(rdata1_o < rdata2_o)};
assign xoR= rdata1_o ^ rdata2_o ;
assign zero_check=&(! xoR); 
 assign  lsr=slT[0]; //assign gtr=!lsr; // BLT, BGE
  assign lsrU=sltU[0]; //assign gtrU=!lsr;// BLTU, BGEU
assign eql=zero_check; // BEQ, BNQ
  

endmodule

