module MEM_WB_Buffer(
    input MEM_WB_ce,                   // Clock enable input
    input MEM_WB_clk,                  // Clock input
    input MEM_WB_rst,                  // Reset input
    input MEM_WB_nop,
    
    // Input data from MEM stage
    input [31:0] mem_read_data_M,
    input [4:0] reg_write_dest_M,
    input gprs_we_i_M,
    input [31:0] ALU_out_M,
    input [31:0] immediate_M,
    input [31:0]PCplus4_M,

    // Control signals
    input ld_M, jal_M, jalr_M, lui_M, 


input [1:0]mem_access_addr_1_0_bits_M,
//Memory  data _in
 input byte_M, half_word_M,full_word_M,byteU_M,half_wordU_M,
 
    // Output data to WB stage
  
    output reg [4:0] reg_write_dest_W,
    output reg  gprs_we_i_W,
    output reg [31:0] ALU_out_W,
    output reg [31:0] immediate_W,
    output reg  [31:0]PCplus4_W,

    // Output control signals to W stage
    output reg ld_W, jal_W, jalr_W, lui_W,
    
    //output of the synchronous read memory data
     //output wire [31:0] mem_read_data_W
     output reg [31:0] mem_read_data_W
);


//assign mem_read_data_W=(MEM_WB_rst | MEM_WB_nop)? 32'd0:mem_read_data_M;
reg [1:0]mem_access_addr_1_0_bits_W;
reg byte_W, half_word_W,full_word_W,byteU_W,half_wordU_W;

always@(*)begin 
if(ld_W)begin
if (!(MEM_WB_rst | MEM_WB_nop))begin
 if( byte_W == 1'b1 )begin
                    if(mem_access_addr_1_0_bits_W[0]&mem_access_addr_1_0_bits_W[1])begin        //11            
            mem_read_data_W <={{24{mem_read_data_M[31]}},mem_read_data_M[31:24]};
            end
                    else if(mem_access_addr_1_0_bits_W[1]&(~mem_access_addr_1_0_bits_W[0]))begin         //10     
            mem_read_data_W <={{24{mem_read_data_M[23]}},mem_read_data_M[23:16]};
            end
                    else if((~mem_access_addr_1_0_bits_W[1])&mem_access_addr_1_0_bits_W[0])begin            //01            
            mem_read_data_W <={{24{mem_read_data_M[15]}},mem_read_data_M[15:8]};
            end
                 //   if((~mem_access_addr_1_0_bits_W[0])&(~mem_access_addr_1_0_bits_W[1]))begin            //00 
        else    mem_read_data_W <={{24{mem_read_data_M[7]}},mem_read_data_M[7:0]};
         //  end
      end
         else if (half_word_W==1'b1)begin
             if(mem_access_addr_1_0_bits_W[1])                 //1
                 mem_read_data_W <={{16{mem_read_data_M[31]}},mem_read_data_M[31:16]};
         //if(~mem_access_addr_1_0_bits_W[1])                 //0
           else      mem_read_data_W <={{16{mem_read_data_M[15]}},mem_read_data_M[15:0]};  
      end       
 
            
            
          else if( byteU_W == 1'b1 )begin
                    if(mem_access_addr_1_0_bits_W[1]&mem_access_addr_1_0_bits_W[0])begin        //11            
            mem_read_data_W  <={24'd0,mem_read_data_M[31:24]};
            end
                   else if(mem_access_addr_1_0_bits_W[1]&(~mem_access_addr_1_0_bits_W[0]))begin         //10     
            mem_read_data_W  <={24'd0,mem_read_data_M[23:16]};
            end
                    else if((~mem_access_addr_1_0_bits_W[1])&mem_access_addr_1_0_bits_W[0])begin            //01            
            mem_read_data_W  <={24'd0,mem_read_data_M[15:8]};
            end
                 // if((~mem_access_addr_1_0_bits_W[1])&(~mem_access_addr_1_0_bits_W[0]))begin            //00 
       else     mem_read_data_W  <={24'd0,mem_read_data_M[7:0]};
      //  end 
   end
      
         else if (half_wordU_W==1'b1)begin
             if(mem_access_addr_1_0_bits_W[1])                 //1
                 mem_read_data_W  <={16'd0,mem_read_data_M[31:16]};
         //   if(~mem_access_addr_1_0_bits_W[1])                 //0
           else   mem_read_data_W <={16'd0,mem_read_data_M[15:0]};  
   end
        //else if (full_word==1'b1)
   else
            mem_read_data_W  <=mem_read_data_M;
 end
    else
             mem_read_data_W  <=32'd0; 
             end
 else
             mem_read_data_W  <=32'd0; 
             end






    // Clock gating
    always @(posedge MEM_WB_clk ) begin
        if (MEM_WB_rst | MEM_WB_nop) begin
            // Reset values
        //    mem_read_data_W <= 0;
            reg_write_dest_W <= 0;
            gprs_we_i_W<=0;
            ALU_out_W <= 0;
            immediate_W <= 0;
            PCplus4_W<=0;
            ld_W <= 0;
            jal_W <= 0;
            jalr_W <= 0;
            lui_W <= 0;
            mem_access_addr_1_0_bits_W<=0;
            
            byte_W <= 0;            
            half_word_W <= 0;  
            full_word_W <= 0;  
            byteU_W <= 0;          
            half_wordU_W <=0;
            
        end else if (MEM_WB_ce) begin
            // Update values with inputs
     //       mem_read_data_W <= mem_read_data_M;
            reg_write_dest_W <= reg_write_dest_M;
            gprs_we_i_W=gprs_we_i_M;
            ALU_out_W <= ALU_out_M;
            immediate_W <= immediate_M;
            PCplus4_W<=PCplus4_M;
            ld_W <= ld_M;
            jal_W <= jal_M;
            jalr_W <= jalr_M;
            lui_W <= lui_M;
            mem_access_addr_1_0_bits_W<=mem_access_addr_1_0_bits_M;
            
            byte_W <= byte_M;            
            half_word_W <= half_word_M;  
            full_word_W <= full_word_M;  
            byteU_W <= byteU_M;          
            half_wordU_W <= half_wordU_M;
        end
    end

endmodule