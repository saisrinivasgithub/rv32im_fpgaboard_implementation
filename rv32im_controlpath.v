`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2024 13:23:22
// Design Name: 
// Module Name: rv32im_controlpath
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
//This control unit uses ALU unit to check braching resulrt also


module rv32im_controlpath(
      input[6:0] opcode,
      input [2:0]funct3,
      input [6:0]funct7,
      input in_20,
      output reg[3:0] alu_op,
      output reg mem_read,mem_write,selRs2Imm,selRs1PC,mem_to_reg,gprs_we_i
      ,output reg ld
      ,output  branch_lsr,branch_grtr,branch_eql  
      ,output reg[2:0]ImmOp
      ,output reg jal
      ,output reg jalr
      ,output reg lui
      ,output reg auipc
   ,output byte, half_word,full_word,byteU,half_wordU,
output reg [1:0]sn,
output reg Mul_en,Div_en,
output reg[1:0] M_sel, //To sel the out among DIV REM, LSB result and MSB relut
output reg result_sel      //Multiplication out or ALU rv32I out
,output reg  ebreak,
output reg  ecall,
output reg branch_instruction,
output reg rs1_valid,
output reg rs2_valid,
output reg rd_valid
     );
       
//wire byteData, half_wordData,full_wordData,byteDataU,half_wordDataU;
 assign byte=(!funct3[2])&(!funct3[1])&(!funct3[0]);// funct3=000
 assign half_word=(!funct3[2])&(!funct3[1])&(funct3[0]);// funct3=001
 assign full_word=(!funct3[2])&(funct3[1])&(!funct3[0]);// funct3=010
 assign byteU=(funct3[2])&(!funct3[1])&(!funct3[0]);// funct3=100
 assign half_wordU=(funct3[2])&(!funct3[1])&(funct3[0]); // funct3=101


//--------------------Instruction formats ,therea re 6 formats
parameter RFormat=3'b101;//r type
parameter IFormat=3'b000;//ri,ld,jalr
parameter SFormat=3'b001;//str
parameter BFormat=3'b010;//branch
parameter JFormat=3'b011;//jal 
parameter UFormat=3'b100;//lui,auipc


wire [3:0]branch_Operation;
//brabch operation detction using alu---------------------------
/*branchType branch_type_instache(opcode,funct3,branch_Operation,
                                branch_lsr,
                                branch_grtr,
                                branch_eql);
*/                                
branchType branch_type_instace (
    .branch_instruction(branch_instruction),
    .funct3(funct3),
    .branch_lsr(branch_lsr),
    .branch_grtr(branch_grtr),
    .branch_lsrU(branch_lsr),
    .branch_grtrU(branch_grtr),
    .branch_eql(branch_eql),
    .branch_neql(branch_eql)
);

//------------------------------------------------------------------------

wire [3:0]alu_sel={funct7[5],funct3};
always @(*)
begin
 case(opcode) 
  7'b1100011:  // Branch
   begin
   
    selRs1PC=1'b0;
    selRs2Imm = 1'b0;
    rs1_valid=1;
    rs2_valid=1;
    rd_valid=0;
    mem_to_reg = 1'b0;
    gprs_we_i = 1'b0;
    ld=1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    jal=1'b0;
    jalr=1'b0;
    branch_instruction=1;
    alu_op = branch_Operation;
      lui=1'b0;
    auipc=1'b0;
    
    ImmOp=BFormat;  
    
    
    
    ebreak=0;  
      ecall=0; 
   end
  7'b0110011:  //r type compuatation
   begin
    selRs1PC=1'b0;
        rs1_valid=1;
    rs2_valid=1;
  
    selRs2Imm = 1'b0;
    mem_to_reg = 1'b0;
    rs1_valid=1;
    rs2_valid=1;
    rd_valid=1;
    gprs_we_i = 1'b1;
    ld=1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    jal=1'b0;
    jalr=1'b0;
    branch_instruction=0;
    lui=1'b0;
    auipc=1'b0;
 if(funct7[0]==1'b0)begin// R
  result_sel=1'b0;
    if((funct3==3'b101)|(funct3==3'b000)) //if operation is SRL,SRA ,ADD,SUB 4th bit are needed 
        alu_op =alu_sel;
    else        //operation is contriled by the  functn3
        alu_op={1'b0,funct3}; 
    ImmOp=3'b101; 
    end
 else begin   //M extension
    result_sel=1'b1;   
       
      //Multiplications
    if(funct3==3'b000)begin //MUL 
        sn=2'b11;
        Mul_en=1'b1;
        Div_en=1'd0;
        M_sel={Mul_en,1'b0};
    end
    else   if(funct3==3'b001)begin //MULH 
        sn=2'b11;
        Mul_en=1'b1;
        Div_en=1'd0;
        M_sel={Mul_en,1'b1};
    end 
    else   if(funct3==3'b010)begin //MULHSU 
        sn=2'b10;
        Mul_en=1'b1;
        Div_en=1'd0;
        M_sel={Mul_en,1'b1};
    end 
    else   if(funct3==3'b011)begin //MULHU 
        sn=2'b00;
        Mul_en=1'b1;
        Div_en=1'd0;
        M_sel={Mul_en,1'b1};
    end
    //divisions
    if(funct3==3'b100)begin //DIV 
        sn=2'b11;
        Mul_en=1'b0;
        Div_en=1'd1;
        M_sel={Mul_en,1'b0};
    end
    else   if(funct3==3'b101)begin //DIVU 
        sn=2'b00;
        Mul_en=1'b0;
        Div_en=1'd1;
        M_sel={Mul_en,1'b0};
    end 
    else   if(funct3==3'b110)begin //REM 
        sn=2'b11;
        Mul_en=1'b0;
        Div_en=1'd1;
        M_sel={Mul_en,1'b1};
    end 
    else   if(funct3==3'b111)begin //REMU 
        sn=2'b00;
        Mul_en=1'b0;
        Div_en=1'd1;
        M_sel={Mul_en,1'b1};
    end 
      //----------M extension end 
    end
    
     
    
    
    ebreak=0;  
      ecall=0; 
  end
 7'b0010011:  // I format , immediate type 
   begin
    selRs1PC=1'b0;
    selRs2Imm = 1'b1;       
     rs1_valid=1;
    rs2_valid=0;
    rd_valid=1;
    mem_to_reg = 1'b0;
    gprs_we_i = 1'b1;
    ld=1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
     jal=1'b0;
    jalr=1'b0;
    branch_instruction=0;
        lui=1'b0;
    auipc=1'b0;
     if(funct3==3'b101) //if operation is SRLI,SRAI ,only 4th bit is needed 
        alu_op =alu_sel;
     else       ///operation is contriled by the  functn3
        alu_op={1'b0,funct3}; 
    
    ImmOp=IFormat; 
         sn=2'd0;
   Mul_en=1'd0;
   Div_en=1'd0;
      M_sel=2'd0;
      result_sel=1'b0; 
      
      
          
     
    
    
    ebreak=0;    
      ecall=0;  
   end
  7'b0000011:  // I format ,  load type 
   begin
    selRs1PC=1'b0;
    selRs2Imm = 1'b1;
            rs1_valid=1;
    rs2_valid=0;
    rd_valid=1;
    
    mem_to_reg = 1'b1;
    gprs_we_i = 1'b1;
    ld=1'b1;
    mem_read = 1'b1;
    mem_write = 1'b0;
     jal=1'b0;
    jalr=1'b0;
    branch_instruction=0;
        lui=1'b0;
    auipc=1'b0;

     alu_op =4'b0000;
    
    ImmOp=IFormat;  
         sn=2'd0;
   Mul_en=1'd0;
   Div_en=1'd0;
      M_sel=2'd0;
      result_sel=1'b0;  
          
     
    
    
    ebreak=0;  
      ecall=0;  
   end  
   
 7'b0100011:  // SW
   begin
    selRs1PC=1'b0;
    selRs2Imm = 1'b1;
    
            rs1_valid=1;
    rs2_valid=1;
    rd_valid=0;
    
    mem_to_reg = 1'b0;
    gprs_we_i = 1'b0;
    ld=1'b0;
    mem_read = 1'b0;
    mem_write = 1'b1;
      jal=1'b0;
    jalr=1'b0;
    branch_instruction=0;
        lui=1'b0;
    auipc=1'b0;

    alu_op = 4'b0000;           //only addition operation
    ImmOp=SFormat; 
         sn=2'd0;
   Mul_en=1'd0;
   Div_en=1'd0;
      M_sel=2'd0;
      result_sel=1'b0;  
          
     
    
    
    ebreak=0;   
      ecall=0;  
   end
   

  7'b0110111:  // LUI
   begin
    selRs1PC=1'b0;
    selRs2Imm = 1'b1;
    
           rs1_valid=0;
    rs2_valid=0;
    rd_valid=1;
     
    mem_to_reg = 1'b0;
    gprs_we_i = 1'b1;
    ld=1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    jal=1'b0;
    jalr=1'b0;
    
    branch_instruction=0;
    lui=1'b1;
    auipc=1'b0;
    alu_op = 4'b0000;
    
    ImmOp=UFormat;  
         sn=2'd0;
   Mul_en=1'd0;
   Div_en=1'd0;
      M_sel=2'd0;
      result_sel=1'b0; 
          
     
    
    
    ebreak=0;   
      ecall=0; 
   end
 7'b0010111:  // AUIPC          
   begin
    selRs1PC=1'b1;            //    selRs1PC=1'b0 ,rs1data is alu in, selRs1PC=1'b1 ,PC is alu in, 
    selRs2Imm = 1'b1;
    
               rs1_valid=0;
    rs2_valid=0;
    rd_valid=1;
    
    mem_to_reg = 1'b0;
    gprs_we_i = 1'b1;
    ld=1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    jal=1'b0;
    jalr=1'b0;
    branch_instruction=0;
    
    lui=1'b0;
    auipc=1'b1;
    alu_op = 4'b0000;       //addiion operation.
    
    ImmOp=UFormat; 
         sn=2'd0;
   Mul_en=1'd0;
   Div_en=1'd0;
      M_sel=2'd0;
      result_sel=1'b0; 
          
     
    
    
    ebreak=0;    
      ecall=0; 
   end
 7'b1101111:  // JAL
   begin
    selRs1PC=1'b0;
    selRs2Imm = 1'b1;
    
               rs1_valid=0;
    rs2_valid=0;
    rd_valid=1;
    
    mem_to_reg = 1'b0;
    gprs_we_i = 1'b1;//store the pc+4 inn return address
    ld=1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
    jal=1'b1;
    jalr=1'b0;
    branch_instruction=0;
    
    lui=1'b0;
    auipc=1'b0;
    alu_op = 4'b0000;
    
    ImmOp=JFormat; 
         sn=2'd0;
   Mul_en=1'd0;
   Div_en=1'd0;
      M_sel=2'd0;
      result_sel=1'b0; 
          
     
    
    
    ebreak=0;   
      ecall=0;  
   end

 7'b1100111:  // JALR
   begin
    selRs1PC=1'b0;
    selRs2Imm = 1'b0;
    
               rs1_valid=1;
    rs2_valid=0;
    rd_valid=1;
    
    mem_to_reg = 1'b0;
    gprs_we_i = 1'b1;//store the pc+4 inn return address
    ld=1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
        jal=1'b0;
    jalr=1'b1;
    branch_instruction=0;
    
        lui=1'b0;
    auipc=1'b0;
    alu_op =4'b0000;
    //JALR is in IFormat for the immediate
    ImmOp=IFormat; 
         sn=2'd0;
   Mul_en=1'd0;
   Div_en=1'd0;
      M_sel=2'd0;
      result_sel=1'b0; 
          
     
    
    
    ebreak=0; 
      ecall=0; 
    end
 
 7'b1110011:  // SYSTEM INSTRUCTIONS
   begin
    selRs1PC=1'b0;
    selRs2Imm = 1'b0;
    
               rs1_valid=0;
    rs2_valid=0;
    rd_valid=0;
    
    mem_to_reg = 1'b0;
    gprs_we_i = 1'b0;
    ld=1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
        jal=1'b0;
    //  jalr=1'b1;     
   jalr=1'b0;    //neglecting the ebreak , ecall instructions.
       branch_instruction=0;
    
        lui=1'b0;
    auipc=1'b0;
    alu_op =4'b0000;
    //JALR is in IFormat for the immediate
    ImmOp=IFormat; 
         sn=2'd0;
   Mul_en=1'd0;
   Div_en=1'd0;
      M_sel=2'd0;
      result_sel=1'b0; 
          
     ebreak=0; 
     ecall=0; 
     
    if({funct3,in_20}==4'd1)    //ebreak instruction
    ebreak=1; 
    
    else if({funct3,in_20}==4'd0) //ecall instruction
    ecall=1; 
    end


 
 default: begin
     selRs1PC=1'b0;
    selRs2Imm = 1'b0;
    mem_to_reg = 1'b0;
    
               rs1_valid=0;
    rs2_valid=0;
    rd_valid=0;
    
    gprs_we_i = 1'b0;   //this is to write the zero value at the zero state in idela state
    ld=1'b0;
    mem_read = 1'b0;
    mem_write = 1'b0;
     jal=1'b0;
    jalr=1'b0;
    branch_instruction=0;
        lui=1'b0;
    auipc=1'b0;
    alu_op =4'b0000;        //unknown opcode, this signal will give zero output from the alu
    ImmOp=RFormat;
     sn=2'd0;
   Mul_en=1'd0;
   Div_en=1'd0;
      M_sel=2'd0;
      result_sel=1'b0;
      
           ebreak=0; 
     ecall=0;  
    end
 endcase
 end
endmodule