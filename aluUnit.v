module aluUnit(in_1, in_2, sel_in, result_out,gtr,lsr,eql);
//module alu_unit1(in_1, in_2, imm_2, opcode_in, result_out);
  input [3:0] sel_in;
  //input [4:0] sel_in;
  input [31:0] in_1, in_2;
  //wire [31:0] in_1, in_2;
  //input [31:0]imm_2;

  output reg [31:0] result_out;
  output  reg lsr,eql;
  output reg gtr;
    wire signed [31:0] op1, op2;
  wire [31:0] sub_op2;
  assign op1 = in_1;
  assign op2 = in_2;
  assign sub_op2 = -in_2;
 /* parameter ALU_ADD  = 2'b00;
  parameter ALU_SUB  = 2'b01;
  parameter ALU_SLT  = 2'b10;
  parameter ALU_SLTU = 2'b11;
*/
wire [31:0]adD,suB,slT,sltU,anD,oR,xoR,slL,srL,srA;
assign adD=in_1 + in_2;
assign suB=in_1 + sub_op2;
assign slT={31'd0,(op1 < op2)} ;
assign sltU={31'd0,(in_1 < in_2)};
assign anD= {31'd0,in_1 & in_2} ;
assign oR=in_1 | in_2 ;
assign xoR= in_1 ^ in_2 ;
assign slL= in_1 << in_2 [4:0];
assign srL=in_1 >> in_2 [4:0];
assign srA= in_1 >>> in_2 [4:0];

  wire zero_check;
 assign zero_check=&(!result_out);
 
reg zero_flag;
  
 always@(*)
  begin
    case(sel_in)
    4'b0000 : begin result_out =adD ; zero_flag = zero_check;   lsr=1'd0;gtr=1'd0;eql=1'd0; end//ADD, ADDI, LW
    4'b1000  : begin result_out = suB; zero_flag = zero_check;lsr=1'd0;gtr=1'd0;eql=1'd0; end //SUB
    
    4'b0010  :begin  result_out = slT; zero_flag = zero_check; lsr=slT[0];gtr=!lsr;eql=1'd0; end//SLT,SLTI
    4'b0011 : begin  result_out = sltU; zero_flag = zero_check;lsr=sltU[0];gtr=!lsr;eql=1'd0; end//SLTU, BLTU, SLTUI
    4'b0111 : begin  result_out =anD; zero_flag = zero_check; lsr=1'd0;gtr=1'b0;eql=1'd0; end // AND , ANDI
    4'b0110 : begin result_out = oR; zero_flag = zero_check; lsr=1'd0;gtr=1'd0;eql=1'd0; end // OR , ORI
    4'b0100 : begin result_out =xoR; zero_flag = zero_check; lsr=1'd0;gtr=1'd0;eql=zero_check; end // XOR , XORI
    4'b0001 :begin  result_out =slL; zero_flag = zero_check;lsr=1'd0;gtr=1'd0;eql=1'd0; end // SLL , SLLI
  
    4'b0101 :begin  result_out = srL; zero_flag = zero_check;lsr=1'd0;gtr=1'd0;eql=1'd0; end // SRL , SRLI
    4'b1101 : begin result_out =srA; zero_flag = zero_check;lsr=1'd0;gtr=1'd0;eql=1'd0; end // SRA , SRAI
  
  /*  
    4'b1010  :begin  result_out = slT; zero_flag = zero_check; lsr=slT[0];gtr=!lsr;eql=1'd0; end//SLT,SLTI
    4'b1011 : begin  result_out = sltU; zero_flag = zero_check;lsr=sltU[0];gtr=!lsr;eql=1'd0; end//SLTU, BLTU, SLTUI
    4'b1111 : begin  result_out =anD; zero_flag = zero_check; lsr=1'd0;gtr=1'b0;eql=1'd0; end // AND , ANDI
    4'b1110 : begin result_out = oR; zero_flag = zero_check; lsr=1'd0;gtr=1'd0;eql=1'd0; end // OR , ORI
    4'b1100 : begin result_out =xoR; zero_flag = zero_check; lsr=1'd0;gtr=1'd0;eql=zero_check; end // XOR , XORI
    4'b1001 :begin  result_out =slL; zero_flag = zero_check;lsr=1'd0;gtr=1'd0;eql=1'd0; end // SLL , SLLI
  */  
    default  : begin result_out = 32'd0;zero_flag = 1'b0;lsr=1'd0;gtr=1'd0;eql=1'd0; end
    endcase
  end
  
  
//assign lsr=result_out;
//assign eql=zero_flag;
//assign gtr=(!lsr)&(!gtr);

/*assign lsr=((sel_in==4'b0010)|(sel_in==4'b0011))?result_out:1'bx;
assign eql=(sel_in==4'b0100)?zero_flag:1'bx;
assign gtr=(!lsr)&(!gtr);
*/
  endmodule