module EX_MEM_Buffer (
    input EX_MEM_ce,                   // Clock enable input
    input EX_MEM_clk,                  // Clock input
    input EX_MEM_rst,                  // Reset input
    input EX_MEM_nop,
    
    // Input data from EX stage
    input [31:0] immediate_E,
    input [4:0] reg_write_dest_E,
    input [31:0] ALU_out_E,
    input [31:0]reg_read_data_2_E,
    input [31:0] PCplus4_E,
   
    
    // Memory Control signals
    input mem_read_E, mem_write_E, gprs_we_i_E,
    input byte_E, half_word_E, full_word_E, byteU_E, half_wordU_E,
     
    // Write back control signals 
    input ld_E, jal_E, jalr_E, lui_E,

    // Output data to MEM stage
    output reg [31:0] ALU_out_M,
    output reg [4:0] reg_write_dest_M,
    output reg [31:0] immediate_M,
 
    output reg [31:0]reg_read_data_2_M,
    output reg [31:0]PCplus4_M,

    
    // Output control signals to MEM stage
    output reg mem_read_M, mem_write_M, gprs_we_i_M,
    output reg byte_M, half_word_M, full_word_M, byteU_M, half_wordU_M,
    
    // OUTPUT Write back control signals 
    output reg ld_M, jal_M, jalr_M, lui_M
);

    // Clock gating
  //  wire clk_enabled = EX_MEM_ce ? EX_MEM_clk : 1'b0;
   wire clk_enabled =   EX_MEM_clk ;

    // Register update logic
    always @(posedge clk_enabled) begin if(EX_MEM_ce)begin
        if (EX_MEM_rst | EX_MEM_nop) begin
            // Reset values
            ALU_out_M <= 0;
            reg_write_dest_M <= 0;
            immediate_M <= 0;
            reg_read_data_2_M<= 0;
            PCplus4_M<=0;
            mem_read_M <= 0;
            mem_write_M <= 0;
            gprs_we_i_M <= 0;
            byte_M <= 0;
            half_word_M <= 0;
            full_word_M <= 0;
            byteU_M <= 0;
            half_wordU_M <= 0;
            ld_M <= 0;
            jal_M <= 0;
            jalr_M <= 0;
            lui_M <= 0;
        end else begin
            // Update values with inputs
            ALU_out_M <= ALU_out_E;
            reg_write_dest_M <= reg_write_dest_E;
            immediate_M <= immediate_E;
            reg_read_data_2_M<=reg_read_data_2_E;
            PCplus4_M<=PCplus4_E;
            mem_read_M <= mem_read_E;
            mem_write_M <= mem_write_E;
            gprs_we_i_M <= gprs_we_i_E;
            byte_M <= byte_E;
            half_word_M <= half_word_E;
            full_word_M <= full_word_E;
            byteU_M <= byteU_E;
            half_wordU_M <= half_wordU_E;
            ld_M <= ld_E;
            jal_M <= jal_E;
            jalr_M <= jalr_E;
            lui_M <= lui_E;
        end
    end
end
endmodule