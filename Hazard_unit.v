module Hazard_unit (
    input clk,
    input rst,
    //Ebreak instruction signal
    input ebreak_E,
    
    //branch instruction for the data forwarding
    input branch_instruction_D,
    input jump_D,
    //Control hazards signals
    input PCnew_E,
    //Data Hazards Signals
    input rs1_valid_E,
    input rs2_valid_E,
    
    input gprs_we_i_E,
    input gprs_we_i_M,
    input gprs_we_i_W,
    
    
    
    input [4:0] reg_read_addr_1_E,
    input [4:0] reg_read_addr_2_E,
    input [4:0] reg_read_addr_1_D,
    input [4:0] reg_read_addr_2_D,
    
    input Rtype_D,
    
    //Loaded data in WB and EX stage
    input [4:0] reg_write_dest_W,
    input [4:0] reg_write_dest_E,
    //ALU_out data in the Execution stage
    input [4:0] reg_write_dest_M,
    input wire ld_E,ld_M, ld_W,
    output reg [1:0] ForwardAE,
    output reg [1:0] ForwardBE,
    output reg [1:0] ForwardAD,
    output reg [1:0] ForwardBD,
    
    output reg IF_ID_nop, ID_EX_nop, EX_MEM_nop, MEM_WB_nop,
    output reg IF_ID_ce, ID_EX_ce, EX_MEM_ce, MEM_WB_ce, PC_ce,
    output IF_ID_rst, ID_EX_rst, EX_MEM_rst, MEM_WB_rst, PC_rst
);

assign ID_EX_rst = rst;
assign EX_MEM_rst = rst;
assign MEM_WB_rst = rst;
//Control hazard
//assign IF_ID_rst = PCnew_E;
assign IF_ID_rst = rst;

wire branch_or_jump=branch_instruction_D |jump_D;
always @(*) begin
    //default no stall
    IF_ID_ce = 1'b1;
    ID_EX_ce = 1'b1;
    EX_MEM_ce = 1'b1;
    MEM_WB_ce = 1'b1;
    PC_ce = 1'b1;
    ForwardAE = 2'b00;         
    ForwardBE = 2'b00;
    ForwardAD = 2'b00;
    ForwardBD = 2'b00;

    IF_ID_nop=0;
     ID_EX_nop=0;
      EX_MEM_nop=0;
       MEM_WB_nop=0;    
  
  //ebreak      
       if( ebreak_E)begin
        PC_ce = 1'b0;       //stall PC cntrt
   IF_ID_ce = 1'b0;         //stall fetch , decode buffer
    ID_EX_ce = 1'b0; //OR      ID_EX_nop=1;
    EX_MEM_ce = 1'b1;
    MEM_WB_ce = 1'b1;
       
       end


        
    //control hazard
    if(PCnew_E)begin
      ID_EX_nop=1'b1; 
        IF_ID_nop=1'b1;
         IF_ID_ce = 1'b1;
   
    EX_MEM_ce = 1'b1;
    MEM_WB_ce = 1'b1;
    PC_ce = 1'b1;
    ForwardAE = 2'b00;         
    ForwardBE = 2'b00;
    ForwardAD = 2'b00;
    ForwardBD = 2'b00;
      EX_MEM_nop=0;
       MEM_WB_nop=0;    
         //set above buffers with no operation
    end
   
 //   else begin   //data hazard in the execution unit
    //ForwardAE
    if ((reg_read_addr_1_E != 0)&(rs1_valid_E)) begin       //should check when the rs1 is valid, non zero
    
       //ALU data forwarding or stall
         if ((reg_read_addr_1_E == reg_write_dest_M)&(gprs_we_i_M)) begin
            if (ld_M == 1'b1) begin //stall
        //        EX_MEM_ce = 1'b1;MEM_WB_ce = 1'b1;ForwardAE = 2'b01; ForwardBE = 2'b00;ForwardAD = 2'b00;ForwardBD = 2'b00;IF_ID_nop=0;ID_EX_nop=0; MEM_WB_nop=0; 
                IF_ID_ce = 1'b0;
                ID_EX_ce = 1'b0;
                PC_ce = 1'b0;
                EX_MEM_nop=1'b1;
            end  if (ld_M == 1'b0) begin //alu_out forwarding
        //        EX_MEM_ce = 1'b1;MEM_WB_ce = 1'b1;PC_ce = 1'b1; ForwardBE = 2'b00;ForwardAD = 2'b00;ForwardBD = 2'b00;IF_ID_nop=0;ID_EX_nop=0;EX_MEM_nop=0; MEM_WB_nop=0; 
        //        IF_ID_ce = 1'b1;
       //         ID_EX_ce = 1'b1;
                ForwardAE = 2'b10; //rs1data=alu_out
            end
        end    
    
        else if ((reg_read_addr_1_E == reg_write_dest_W)&(gprs_we_i_W)) begin
            if (ld_W == 1'b1) begin
     //          IF_ID_ce = 1'b1; ID_EX_ce = 1'b1;EX_MEM_ce = 1'b1;MEM_WB_ce = 1'b1;PC_ce = 1'b1;ForwardBE = 2'b00;ForwardAD = 2'b00;ForwardBD = 2'b00;IF_ID_nop=0;ID_EX_nop=0;EX_MEM_nop=0; MEM_WB_nop=0; 
               ForwardAE = 2'b01; //rs1data=mem_data
                
            end else begin
    //        IF_ID_ce = 1'b1; ID_EX_ce = 1'b1;EX_MEM_ce = 1'b1;MEM_WB_ce = 1'b1;PC_ce = 1'b1; ForwardBE = 2'b00;ForwardAD = 2'b00;ForwardBD = 2'b00;IF_ID_nop=0;ID_EX_nop=0;EX_MEM_nop=0; MEM_WB_nop=0; 
                ForwardAE = 2'b11; //rs1data=ALU_OUT_W
            end
        end
    

        

 
    end
    //ForwardBE
    if ((reg_read_addr_2_E != 0)&(rs2_valid_E)) begin       // //should check when the rs2 is valid, non zero
        //ALU data forwarding or stall
        if ((reg_read_addr_2_E == reg_write_dest_M)&(gprs_we_i_M)) begin
            if (ld_M == 1'b1) begin //stall
                IF_ID_ce = 1'b0;
                ID_EX_ce = 1'b0;
                PC_ce = 1'b0;
                EX_MEM_nop=1'b1;
            end else if (ld_M == 1'b0) begin
       //         IF_ID_ce = IF_ID_ce?1'b1:1'b0;          //if its zero , then make it zero ,
       //         ID_EX_ce = ID_EX_ce?1'b1:1'b0;
                ForwardBE = 2'b10; //rs2data=alu_out
            end
        end   
         
        else if ((reg_read_addr_2_E == reg_write_dest_W)&(gprs_we_i_W)) begin
            if (ld_W == 1'b1) begin
                ForwardBE = 2'b01; //rs2data=mem_data
            end else begin
                ForwardBE = 2'b11; //rs2data=ALU_OUT_W
            end
        end
    end
    
    
    
    
    //----------------2 consecutive laod instructions stall , fordata dependent,
    //ACTUALLY THIS CASE is  to reslove this data dependencies 
    /*	lw	a4,-20(s0)
         	lw	a5,-24(s0)
          	mul	a5,a4,a5
          	*/
     if ((reg_read_addr_1_D != 0))begin
        
            if ((reg_read_addr_1_D == reg_write_dest_E)&(gprs_we_i_E)) begin //stall
                if(ld_E/* & ld_M*/)begin//--------------------------2 consecutive laod instructions stall
                    if ((reg_read_addr_2_D == reg_write_dest_M)&(gprs_we_i_M)) begin //stall
                          IF_ID_ce = 1'b0;
                            PC_ce = 1'b0;
                            ID_EX_nop=1'b1;//nop
                    end
                end

            end                
     end
    if ((reg_read_addr_2_D != 0))begin
        if ((reg_read_addr_2_D == reg_write_dest_E)&(gprs_we_i_E)) begin //stall   
             if(ld_E /*& ld_M*/)begin//--------------------------2 consecutive laod instructions stall         
       
                if ((reg_read_addr_1_D == reg_write_dest_M)&(gprs_we_i_M)) begin //stall
                          IF_ID_ce = 1'b0;
                            PC_ce = 1'b0;
                            ID_EX_nop=1'b1;//nop
                end  
            end
         end
            
    end
  
  
  
    //ForwardAD
    if ((reg_read_addr_1_D != 0)&branch_or_jump) begin
        //IF_ID_ce = 1'b1; ID_EX_ce = 1'b1;EX_MEM_ce = 1'b1;MEM_WB_ce = 1'b1;PC_ce = 1'b1;ForwardAE = 2'b01; ForwardBE = 2'b00;ForwardAD = 2'b00;ForwardBD = 2'b00;IF_ID_nop=0;ID_EX_nop=0;EX_MEM_nop=0; MEM_WB_nop=0; 

        if ((reg_read_addr_1_D == reg_write_dest_E)&(gprs_we_i_E)) begin //stall
            
            IF_ID_ce = 1'b0;
            PC_ce = 1'b0;
            ID_EX_nop=1'b1;//nop
            
            
        end
                //ALU data forwarding or stall
         else if ((reg_read_addr_1_D == reg_write_dest_M)&(gprs_we_i_M)) begin
            if (ld_M == 1'b1) begin //stall
                IF_ID_ce = 1'b0;
                PC_ce = 1'b0;
                ID_EX_nop=1'b1;//nop
            end else if (ld_M == 1'b0) begin //alu_out forwarding
        //        IF_ID_ce = 1'b1;
        //        ID_EX_ce = 1'b1;
                ForwardAD = 2'b10; //rs1data=alu_out
        //        ID_EX_nop=1'b0;// REMOVE THE NOP SIGNAL ON IT
            end
        end


        else if ((reg_read_addr_1_D == reg_write_dest_W)&(gprs_we_i_W)) begin
            if (ld_W == 1'b1) begin
                ForwardAD = 2'b01; //rs1data=mem_data
            end else begin
                ForwardAD = 2'b11; //rs1data=ALU_OUT_W
            end
        end
        
       
    end
    //ForwardBD
    if ((reg_read_addr_2_D != 0)&branch_or_jump) begin
        //IF_ID_ce = 1'b1; ID_EX_ce = 1'b1;EX_MEM_ce = 1'b1;MEM_WB_ce = 1'b1;PC_ce = 1'b1;ForwardAE = 2'b01; ForwardBE = 2'b00;ForwardAD = 2'b00;ForwardBD = 2'b00;IF_ID_nop=0;ID_EX_nop=0;EX_MEM_nop=0; MEM_WB_nop=0; 



        if ((reg_read_addr_2_D == reg_write_dest_E)&(gprs_we_i_E)) begin //stall
            IF_ID_ce = 1'b0;
            PC_ce = 1'b0;
            ID_EX_nop=1'b1;//nop
          
        end
        
       
        //ALU data forwarding or stall
        else if (((reg_read_addr_2_D == reg_write_dest_M))&(gprs_we_i_M)) begin
            if (ld_M == 1'b1) begin //stall
                IF_ID_ce = 1'b0;
                PC_ce = 1'b0;
                ID_EX_nop=1'b1;//nop
            end else if (ld_M == 1'b0) begin
          //      IF_ID_ce = 1'b1;
          //      ID_EX_ce = 1'b1;
                ForwardBD = 2'b10; //rs2data=alu_out
            end
        end

        else if ((reg_read_addr_2_D == reg_write_dest_W)&(gprs_we_i_W)) begin
            if (ld_W == 1'b1) begin
                ForwardBD = 2'b01; //rs1data=mem_data
            end else begin
                ForwardBD = 2'b11; //rs1data=ALU_OUT_W
            end
        end
    end
    

end
//end
endmodule
