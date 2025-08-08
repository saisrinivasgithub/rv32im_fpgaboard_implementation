module branchType(branch_instruction,funct3,
//branch_Operation,
                                branch_lsr,
                                branch_grtr,
                                
                                branch_lsrU,
                                branch_grtrU,  
                                                              
                                branch_eql,
                                branch_neql);
input branch_instruction;
input [2:0]funct3;
//output reg  [3:0]branch_Operation;
output reg branch_lsr;
output reg        branch_grtr;

output reg branch_lsrU;
output reg        branch_grtrU;

output reg        branch_eql;
output reg        branch_neql;
 
 
 
always @(*) begin
  if(branch_instruction)begin
         // if it is a branch only
            case (funct3)
                3'b110: begin // BLTU
                  //  branch_Operation = 4'b0011; // sltU
                    branch_lsr = 1'b0;
                    branch_grtr = 1'b0;
                    branch_eql = 1'b0;
                    branch_neql = 1'b0;
                    branch_lsrU = 1'b1;
                    branch_grtrU = 1'b0;
                    

                end
                3'b100: begin // BLT
               //     branch_Operation = 4'b0010; // slt
                    branch_lsr = 1'b1;
                    branch_grtr = 1'b0;
                    branch_eql = 1'b0;
                    branch_neql = 1'b0;
                     branch_lsrU = 1'b0;
                    branch_grtrU = 1'b0;                   
                end
                3'b000: begin // BEQ
                 //   branch_Operation = 4'b0100; // xor
                    branch_lsr = 1'b0;
                    branch_grtr = 1'b0;
                    branch_eql = 1'b1;
                    branch_neql = 1'b0;
                     branch_lsrU = 1'b0;
                    branch_grtrU = 1'b0;                          
                end
                3'b001: begin // BNQ
                //    branch_Operation = 4'b0100; // xor
                    branch_lsr = 1'b0;
                    branch_grtr = 1'b0;
                    branch_eql = 1'b0;
                    branch_neql = 1'b1;
                     branch_lsrU = 1'b0;
                    branch_grtrU = 1'b0;      
                end
                3'b101: begin // BGE
                 //   branch_Operation = 4'b0010; // slt
                    branch_lsr = 1'b0;
                    branch_grtr = 1'b1;
                    branch_eql = 1'b0;
                    branch_neql = 1'b0;
                     branch_lsrU = 1'b0;
                    branch_grtrU = 1'b0; 
                end
                3'b111: begin // BGEU
               //     branch_Operation = 4'b0011; // sltu
                    branch_lsr = 1'b0;
                    branch_grtr = 1'b0;
                    branch_eql = 1'b0;
                    branch_neql = 1'b0;
                     branch_lsrU = 1'b0;
                    branch_grtrU = 1'b1; 
                end
                default: begin
                 //   branch_Operation = 4'b1111; // even if it passed to ALU op, it can't generate any operation
                    branch_lsr = 1'b0;
                    branch_grtr = 1'b0;
                    branch_eql = 1'b0;
                    branch_eql = 1'b0;
                    branch_neql = 1'b0;
                     branch_lsrU = 1'b0;
                    branch_grtrU = 1'b0; 
                end
            endcase
        end
else begin
         //   branch_Operation = 4'b1111; // even if it passed to ALU op, it can't generate any operation
            branch_lsr = 1'b0;
            branch_grtr = 1'b0;
            branch_eql = 1'b0;
                    branch_neql = 1'b0;
                     branch_lsrU = 1'b0;
                    branch_grtrU = 1'b0; 
end

end


/*
always @(*) begin
  if(opcode==7'b1100011)begin
         // if it is a branch only
            case (funct3)
                3'b110: begin // BLTU
                    branch_Operation = 4'b0011; // sltU
                    branch_lsr = 1'b1;
                    branch_grtr = 1'b0;
                    branch_eql = 1'b0;

                end
                3'b100: begin // BLT
                   branch_Operation = 4'b0010; // slt
                    branch_lsr = 1'b1;
                    branch_grtr = 1'b0;
                    branch_eql = 1'b0;
                end
                3'b000: begin // BEQ
                   branch_Operation = 4'b0100; // xor
                    branch_lsr = 1'b0;
                    branch_grtr = 1'b0;
                    branch_eql = 1'b1;
                end
                3'b001: begin // BNQ
                   branch_Operation = 4'b0100; // xor
                    branch_lsr = 1'b1;
                    branch_grtr = 1'b1;
                    branch_eql = 1'b1;
                end
                3'b101: begin // BGE
                  branch_Operation = 4'b0010; // slt
                    branch_lsr = 1'b0;
                    branch_grtr = 1'b1;
                    branch_eql = 1'b0;
                end
                3'b111: begin // BGEU
                  branch_Operation = 4'b0011; // sltu
                    branch_lsr = 1'b0;
                    branch_grtr = 1'b1;
                    branch_eql = 1'b0;
                end
                default: begin
                    branch_Operation = 4'b1111; // even if it passed to ALU op, it can't generate any operation
                    branch_lsr = 1'b0;
                    branch_grtr = 1'b0;
                    branch_eql = 1'b0;
                end
            endcase
        end
else begin
            branch_Operation = 4'b1111; // even if it passed to ALU op, it can't generate any operation
            branch_lsr = 1'b0;
            branch_grtr = 1'b0;
            branch_eql = 1'b0;
end

end
*/

endmodule
