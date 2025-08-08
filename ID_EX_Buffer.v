module ID_EX_Buffer (
    input ID_EX_ce,       // Clock enable input
    input ID_EX_clk,      // Clock input
    input ID_EX_rst,      // Reset input
    input ID_EX_nop,      

    // Input data from ID stage
    input rs1_valid_D,
    input rs2_valid_D,
    input rd_valid_D,
    
    input [4:0]reg_read_addr_1_D,
    input [4:0]reg_read_addr_2_D,
    input [31:0] reg_read_data_1_D,
    input [31:0] reg_read_data_2_D,
    input [4:0]reg_write_dest_D,
    input [31:0] immediate_D,
    input [31:0]PCplus4_D,
    
    // Branch detection signal and data
    input [31:0]PC_D,
    input PCnew_D,
    input [31:0] PCin1_D,

    // Control signals
    input [3:0] alu_op_D,
    input mem_read_D, mem_write_D, selRs2Imm_D, selRs1PC_D, gprs_we_i_D,
    input ebreak_D,
    
    //write back signals
    input ld_D,
    input jal_D,
    input jalr_D,
    input lui_D,
    input auipc_D,
    //input auipc_D, this functionality is take care of the selRs1PC_D, in the alu in selection, the the respective output would be taken care by the ALU_out
    
    
    //mem signals 
    input byte_D, half_word_D, full_word_D, byteU_D, half_wordU_D,
    
    //alu_signals
    input [1:0] sn_D,
    input Mul_en_D, Div_en_D,
    input [1:0] M_sel_D,
    input result_sel_D, // Multiplication out or ALU rv32I out

    // Output data to EX stage
    output reg rs1_valid_E,
    output reg rs2_valid_E,
    output reg [4:0]reg_read_addr_1_E,
    output reg[4:0]reg_read_addr_2_E,
    output reg [31:0] reg_read_data_1_E,
    output reg [31:0] reg_read_data_2_E,
    output reg [4:0]reg_write_dest_E,
    output reg [31:0] immediate_E,
    output reg [31:0]PCplus4_E,

    // Output branch detection signal and data to EX stage
    output reg  [31:0]PC_E,
    output reg PCnew_E,
    output reg [31:0] PCin1_E,

    // Output control signals to EX stage
    output reg [3:0] alu_op_E,
    output reg mem_read_E, mem_write_E, selRs2Imm_E, selRs1PC_E, gprs_we_i_E,
    output reg ebreak_E,
    output reg ld_E,
    output reg jal_E,
    output reg jalr_E,
    output reg lui_E,
    output reg auipc_E,
    output reg byte_E, half_word_E, full_word_E, byteU_E, half_wordU_E,
    output reg [1:0] sn_E,
    output reg Mul_en_E, Div_en_E,
    output reg [1:0] M_sel_E,
    output reg result_sel_E // Multiplication out or ALU rv32I out
);

    // Clock gating
  //  wire clk_enabled = ID_EX_ce ? ID_EX_clk : 1'b0;
wire clk_enabled = ID_EX_clk;

    // Register update logic
    always @(posedge clk_enabled ) begin if(ID_EX_ce)begin
        if (ID_EX_rst | ID_EX_nop) begin
            // Reset values
            rs1_valid_E<=0;
            rs2_valid_E<=0;
            reg_read_addr_1_E<=0;
            reg_read_addr_2_E<=0;
            reg_read_data_1_E <= 0;
            reg_read_data_2_E <= 0;
            reg_write_dest_E<=0;
            immediate_E <= 0;
            PCplus4_E<=0;
            PC_E<=0;
            PCnew_E <=0 ;
            PCin1_E <= 0;
            alu_op_E <= 0;
            mem_read_E <= 0;
            mem_write_E <= 0;
            selRs2Imm_E <= 0;
            if(ID_EX_rst)begin
                        ebreak_E<=0;end
            selRs1PC_E <= 0;
            gprs_we_i_E <= 0;
            ld_E <= 0;
            jal_E <= 0;
            jalr_E <= 0;
            lui_E <= 0;
            auipc_E <= 0;
            byte_E <= 0;
            half_word_E <= 0;
            full_word_E <= 0;
            byteU_E <= 0;
            half_wordU_E <= 0;
            sn_E <= 0;
            Mul_en_E <= 0;
            Div_en_E <= 0;
            M_sel_E <= 0;
            result_sel_E <= 0;
           
        end

         else begin 
            // Update values with inputs
            rs1_valid_E<=rs1_valid_D;
            rs2_valid_E<=rs2_valid_D;
            reg_read_addr_1_E<=reg_read_addr_1_D;
            reg_read_addr_2_E<=reg_read_addr_2_D;
            reg_read_data_1_E <= reg_read_data_1_D;
            reg_read_data_2_E <= reg_read_data_2_D;
            reg_write_dest_E<=reg_write_dest_D;
            immediate_E <= immediate_D;
            PCplus4_E<=PCplus4_D;
            PC_E<=PC_D;
            PCnew_E <= PCnew_D;
            PCin1_E <= PCin1_D;
            alu_op_E <= alu_op_D;
            mem_read_E <= mem_read_D;
            mem_write_E <= mem_write_D;
            ebreak_E<=ebreak_D;
            selRs2Imm_E <= selRs2Imm_D;
            selRs1PC_E <= selRs1PC_D;
            gprs_we_i_E <= gprs_we_i_D;
            ld_E <= ld_D;
            jal_E <= jal_D;
            jalr_E <= jalr_D;
            lui_E <= lui_D;
            auipc_E <= auipc_D;
            byte_E <= byte_D;
            half_word_E <= half_word_D;
            full_word_E <= full_word_D;
            byteU_E <= byteU_D;
            half_wordU_E <= half_wordU_D;
            sn_E <= sn_D;
            Mul_en_E <= Mul_en_D;
            Div_en_E <= Div_en_D;
            M_sel_E <= M_sel_D;
            result_sel_E <= result_sel_D;
        end
    end
end
endmodule

