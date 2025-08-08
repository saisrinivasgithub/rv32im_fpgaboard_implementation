`timescale 1ns / 1ps


module branch_jump_detection(  
    
    input jal , jalr,
    input  branch_instruction,
    
    input  [31:0] rdata1_o,         
    input  [31:0] rdata2_o  ,
    
    input [31:0]PC,
    
    input [2:0]funct3,
    
    output reg PCnew,
    output [31:0]PCin1
    );
   
    //  wire[2:0]funct3;
      wire [6:0]funct7;
//--------------------------------------------------------------------\


wire branch_lsr, branch_grtr, branch_lsrU,branch_grtrU,  branch_eql,branch_neql;//brach opcdoe decodeing signlas
branchType branch_type_instace(branch_instruction,funct3,
                                branch_lsr,
                                branch_grtr,
                                
                                branch_lsrU,
                                branch_grtrU,  
                                                              
                                branch_eql,
                                branch_neql);
 
                              
  wire lsr,lsrU,eql; //Comparator signals 

comparator comparator_inst (
    .rdata1_o(rdata1_o),
    .rdata2_o(rdata2_o),
    .lsr(lsr),
    .lsrU(lsrU),
    .eql(eql)
);

//------------------------------------------------------------------------
  reg take_branch;   //branch taken signal  
  
 always@(*)begin
    take_branch=0;
 if(branch_lsr)
       take_branch=lsr;
 if (branch_grtr)
           take_branch=~lsr;
 if(branch_lsrU)
       take_branch=lsrU;
 if (branch_grtrU)
           take_branch=~lsrU;
 if (branch_eql)
           take_branch=eql;  
 if (branch_neql)
           take_branch=~eql;            
 
 end
  
  
  
wire PCImm_signal, Rs1Imm_signal;
assign PCImm_signal=jal|take_branch;
assign Rs1Imm_signal=jalr;
 
  
always@(*)begin
PCnew= 1'b0;
if((PCImm_signal| Rs1Imm_signal))
PCnew= 1'b1;
end


/*reg [31:0]in1;
always@(*)begin
if(PCImm_signal)
    in1=PC;
if(Rs1Imm_signal)
    in1=rdata1_o;
 in1=32'd0;
end
*/
/*
wire [31:0]in1;
 assign    in1 = (PCImm_signal) ? PC :
          (Rs1Imm_signal) ? rdata1_o :
          32'd0;
 */     
 reg [31:0]in1;
 always@(*)begin
 if(PCImm_signal) 
 in1 = PC ;
 else if (Rs1Imm_signal)
  in1 =  rdata1_o ;
 else 
 in1 =   32'd0; 
 end   
assign PCin1=in1;



endmodule
