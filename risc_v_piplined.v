`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.04.2024 16:09:54
// Design Name: 
// Module Name: risc_v_piplined
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



 
 `define  INPUT_SWITCH__OUTPUT_7_SEGMENT
 
 
//////////////////////////////////////////////////////////////////////////////////
`default_nettype wire

module risc_v_piplined#(parameter DATA_MEM_SIZE= 10240,INSTR_SIZE= 1024)(
input clk,rst,ce

    //instrcution mem write
//,input instrWrEn,
//input [31:0]InstrWrAdd,
//input [7:0]InstrWrData,
,output [1:0]reg_write_data_W_out
,output gprs_we_i_W


 
 //-----------Pheripheral Memory mapping  ports----------
    `ifdef INPUT_SWITCH__OUTPUT_7_SEGMENT,
      input [15:0] switch_in_data,
        output [31:0] display_7_seg_data
    `endif
 //---------------------------------
 
    );
 //wire [1:0]reg_write_data_W_out;
wire instrWrEn;
wire [31:0]InstrWrAdd;
wire [7:0]InstrWrData;

   
    

// Declarations for the Fetch stage variables
wire [31:0] PC_F;            // 32-bit Program Counter output
wire [31:0] instruction_F;   // 32-bit instruction output
wire [31:0] PCplus4_F;       // 32-bit PC plus 4 output
//wire PCnew_E;               // Branch detection signal input
wire PC_ce;                // Clock input
wire PC_rst;                // Reset input

// IF_ID stage wire declarations
//wire [31:0] PC_D;              // 32-bit PC output
//wire [31:0] instruction_D;     // 32-bit instruction output
wire [31:0] PCplus4_D;         // 32-bit PC plus 4 output
wire IF_ID_ce;                 // Clock enable input
wire IF_ID_clk;                // Clock input
wire IF_ID_rst;                // Reset input
   wire IF_ID_nop;
wire Instr_nop;
wire Instr_ce;


// ID stage wire declarations
wire [31:0] PC_D;                      // 32-bit PC input
wire [31:0] instruction_D;             // 32-bit instruction input
wire [4:0] reg_read_addr_1_D;          // 5-bit register read address 1 output
wire [4:0] reg_read_addr_2_D;          // 5-bit register read address 2 output
wire [31:0] reg_read_data_1_D;         // 32-bit register read data 1 output
wire [31:0] reg_read_data_2_D;         // 32-bit register read data 2 output
wire [4:0] reg_write_dest_D;          // 5-bit register write destination output
wire [31:0] immediate_D;               // 32-bit immediate data output
wire PCnew_D;                          // Branch detection signal output
wire [31:0] PCin1_D;                   // 32-bit PCin1 data output
wire [3:0] alu_op_D;                   // 4-bit ALU operation output
wire mem_read_D;                       // Memory read control output
wire mem_write_D;                      // Memory write control output
wire selRs2Imm_D;                      // Select Rs2 or Immediate control output
wire selRs1PC_D;                       // Select Rs1 or PC control output
wire gprs_we_i_D;                      // GPRs write enable control output
wire ld_D;                             // Load control output
wire jal_D;                            // Jump and Link control output
wire jalr_D;                           // Jump and Link Register control output
wire lui_D;                            // Load Upper Immediate control output
wire auipc_D;                          // Add Upper Immediate to PC control output
wire branch_instruction_D;               //branch instruction signals
wire byte_D;                           // Byte control output
wire half_word_D;                      // Half word control output
wire full_word_D;                      // Full word control output
wire byteU_D;                          // Unsigned byte control output
wire half_wordU_D;                     // Unsigned half word control output
wire [1:0] sn_D;                       // Shift amount control output
wire Mul_en_D;                         // Multiplication enable control output
wire Div_en_D;                         // Division enable control output
wire [1:0] M_sel_D;                    // Select control output for DIV REM, LSB result, and MSB result
wire result_sel_D;                     // Multiplication result selection control output
wire ebreak_D;                         // Ebreak instruction control signal
wire [1:0] ForwardAD;                  // Forwarding control signal for operand A input
wire [1:0] ForwardBD;                  // Forwarding control signal for operand B input
wire rs1_valid_D;
wire rs2_valid_D;

    

// ID_EX stage wire declarations
wire [4:0] reg_read_addr_1_E;          // 5-bit register read address 1 output
wire [4:0] reg_read_addr_2_E;          // 5-bit register read address 2 output
wire [31:0] reg_read_data_1_E;         // 32-bit register read data 1 output
wire [31:0] reg_read_data_2_E;         // 32-bit register read data 2 output
wire [4:0] reg_write_dest_E;          // 5-bit register write destination output
wire [31:0] immediate_E;               // 32-bit immediate data output
wire PCnew_E;                          // Branch detection signal output
wire [31:0] PCin1_E;                   // 32-bit PCin1 data output
wire [3:0] alu_op_E;                   // 4-bit ALU operation output
wire mem_read_E;                       // Memory read control output
wire mem_write_E;                      // Memory write control output
wire selRs2Imm_E;                      // Select Rs2 or Immediate control output
wire selRs1PC_E;                       // Select Rs1 or PC control output
wire gprs_we_i_E;                      // GPRs write enable control output
wire ld_E;                             // Load control output
wire jal_E;                            // Jump and Link control output
wire jalr_E;                           // Jump and Link Register control output
wire lui_E;                            // Load Upper Immediate control output
wire auipc_E;                          // Add Upper Immediate to PC control output
wire byte_E;                           // Byte control output
wire half_word_E;                      // Half word control output
wire full_word_E;                      // Full word control output
wire byteU_E;                          // Unsigned byte control output
wire half_wordU_E;                     // Unsigned half word control output
wire [1:0] sn_E;                       // Shift amount control output
wire Mul_en_E;                         // Multiplication enable control output
wire Div_en_E;                         // Division enable control output
wire [1:0] M_sel_E;                    // Select control output for DIV REM, LSB result, and MSB result
wire result_sel_E;                     // Multiplication result selection control output
wire [31:0]PC_E;                       //
wire ebreak_E;                         // Ebreak instruction control signal
   wire ID_EX_nop;
   wire [31:0]PCplus4_E;
 wire rs1_valid_E;
wire rs2_valid_E;  
//new
wire ID_EX_clk;
wire ID_EX_rst;   
wire ID_EX_ce ; // stall is a signal from the hazard detection unit// EX stage wire declarations
wire [31:0] ALU_out_E;                     // 32-bit ALU output
wire [1:0] ForwardAE;                      // Forwarding control signal for operand A input
wire [1:0] ForwardBE;                      // Forwarding control signal for operand B input
//wire [31:0] mem_read_data_W;               // 32-bit memory read data from WB stage input
//wire [31:0] ALU_out_M;                     // 32-bit ALU output from MEM stage input
wire [31:0]PCplus4_M;
wire [31:0]rdata2_fd;

// EX_MEM_Buffer stage wire declarations
wire [31:0] ALU_out_M;                 // 32-bit ALU output
wire [4:0] reg_write_dest_M;           // 5-bit register write destination
wire [31:0] immediate_M;               // 32-bit immediate value
wire [31:0]reg_read_data_2_M;          // 32 bit data needed to be writeen in the memory
wire mem_read_M;                       // Memory read control signal
wire mem_write_M;                      // Memory write control signal
wire gprs_we_i_M;                      // Register file write enable control signal
wire byte_M;                           // Byte memory access control signal
wire half_word_M;                      // Half-word memory access control signal
wire full_word_M;                      // Full-word memory access control signal
wire byteU_M;                          // Unsigned byte memory access control signal
wire half_wordU_M;                     // Unsigned half-word memory access control signal
wire ld_M;                             // Load control signal
wire jal_M;                            // Jump and link control signal
wire jalr_M;                           // Jump and link register control signal
wire lui_M;                            // Load upper immediate control signal
   wire EX_MEM_nop;
   //new
   wire EX_MEM_clk;
   wire EX_MEM_rst;
   wire EX_MEM_ce ;  
   
// MEM stage wire declarations
wire [31:0] mem_read_data_M;           // 32-bit data read from memory
wire [1:0]mem_access_addr_1_0_bits_M;
assign mem_access_addr_1_0_bits_M=reg_read_data_2_M[1:0];  //2 lsbs of the data memory writing location

// MEM_WB stage wire declarations
wire [31:0] mem_read_data_W;           // 32-bit data to WB stage
wire [4:0] reg_write_dest_W;           // 5-bit register write destination to WB stage
wire [31:0] ALU_out_W;                 // 32-bit ALU output to WB stage
wire [31:0] immediate_W;               // 32-bit immediate value to WB stage
wire ld_W;                             // Load control signal to WB stage
wire jal_W;                            // Jump and link control signal to WB stage
wire jalr_W;                           // Jump and link register control signal to WB stage
wire lui_W;                            // Load upper immediate control signal to WB stage
    wire MEM_WB_stal;
    wire MEM_WB_ce;  
    wire     MEM_WB_clk; 
       wire  MEM_WB_rst ;
       wire  MEM_WB_nop;
// Write back stage wire declarations
/*
wire [31:0] mem_read_data_W;           // 32-bit data from MEM stage
wire [4:0] reg_write_dest_W;           // 5-bit register write destination from MEM stage
wire [31:0] ALU_out_W;                 // 32-bit ALU output from MEM stage
wire [31:0] immediate_W;               // 32-bit immediate value from MEM stage
wire ld_W;                             // Load control signal
wire jal_W;                            // Jump and link control signal
wire jalr_W;                           // Jump and link register control signal
wire lui_W;                            // Load upper immediate control signal
*/
wire [31:0] reg_write_data_W; // Output data to be written to the register file
wire [31:0]PCplus4_W;
//wire gprs_we_i_W;               

//hazard unit variable
wire jump_D;

    
IF #(
    .INSTR_SIZE(INSTR_SIZE)    // Parameter specifying the instruction size
) IF_instance (
    .clk(clk),                  // Clock input
    .rst(rst),                  // Reset input

.PC_ce(PC_ce),

.ebreak_E(ebreak_E),    //egrak to top the instruction memory


    // New target PC address control signal
    .PCnew_E(PCnew_E),         // PCnew signal input
    .Instr_ce(Instr_ce),
    .Instr_nop(Instr_nop),

    // Input data
    .immediate_E(immediate_E), // 32-bit immediate data input
    .PCin1_E(PCin1_E),         // 32-bit PCin1 data input

    // PC outputs
    .PCplus4_F(PCplus4_F),     // 32-bit PCPlus4 data output
    .PC_F(PC_F),               // 32-bit PC data output

    // Instructions
    .instruction_F(instruction_F),   // 32-bit instructionF data output

    // Instruction memory write
    .instrWrEn(instrWrEn),         // Instruction write enable input
    .InstrWrAdd(InstrWrAdd),       // 32-bit instruction memory address input
    .InstrWrData(InstrWrData)      // 8-bit instruction memory data input
);

IF_ID_Buffer IF_ID_instance (
    .IF_ID_ce(IF_ID_ce),                      // Clock enable input
    .Instr_ce(Instr_ce),
    
    .IF_ID_clk(IF_ID_clk),                    // Clock input
    .IF_ID_rst(IF_ID_rst),                    // Reset input

    // Fetch data inputs
    .PC_F(PC_F),                              // 32-bit PC data input
    .instruction_F(instruction_F),            // 32-bit instruction data input
    .PCplus4_F(PCplus4_F),                    // 32-bit PC plus 4 data input

    .IF_ID_nop(IF_ID_nop),                 // Branch detection signal output
    .Instr_nop(Instr_nop),
    
    // Output data to ID stage
    .PC_D(PC_D),                              // 32-bit PC data output
    .instruction_D(instruction_D),            // 32-bit instruction data output
    .PCplus4_D(PCplus4_D)                     // 32-bit PC plus 4 data output
);


ID ID_instance (
    .clk(clk),                          // Input clock signal
    .rst(rst),                          // Input reset signal

    // Fetch data inputs
    .PC_D(PC_D),                        // 32-bit PC data input
    .instruction_D(instruction_D),      // 32-bit instruction data input

    // Decode computable data outputs
    .reg_read_addr_1_D(reg_read_addr_1_D),       // 5-bit register address 1 output
    .reg_read_addr_2_D(reg_read_addr_2_D),       // 5-bit register address 2 output
    .reg_read_data_1_D(reg_read_data_1_D),       // 32-bit register data 1 output
    .reg_read_data_2_D(reg_read_data_2_D),       // 32-bit register data 2 output
    .reg_write_dest_D(reg_write_dest_D),         // 32-bit register write destination output
    .immediate_D(immediate_D),                   // 32-bit immediate data output

    // GPRs write back data inputs
    .reg_write_dest_W(reg_write_dest_W),         // 5-bit register write destination input
    .reg_write_data_W(reg_write_data_W),         // 32-bit register write data input
    .gprs_we_i_W(gprs_we_i_W),                    //gprs write en from the write back stage

    //for data forwarding for the branch , detection
    .ForwardAD(ForwardAD),
    .ForwardBD(ForwardBD),
     
     // Data from MEM stage
    .mem_read_data_W(mem_read_data_W),         // 32-bit memory read data from WB stage input
    .ALU_out_M(ALU_out_M),                      // 32-bit ALU output from MEM stage input
    .ALU_out_W(ALU_out_W),


    // Branch detection signal and data outputs
    .PCnew_D(PCnew_D),                            // Output for new PC value
    .PCin1_D(PCin1_D),                            // 32-bit input data for PC

    // Control signals outputs
    .alu_op_D(alu_op_D),                          // 4-bit ALU operation output
    .mem_read_D(mem_read_D),                      // Memory read control output
    .mem_write_D(mem_write_D),                    // Memory write control output
    .selRs2Imm_D(selRs2Imm_D),                    // Select Rs2 or Immediate control output
    .selRs1PC_D(selRs1PC_D),                      // Select Rs1 or PC control output
    .gprs_we_i_D(gprs_we_i_D),                    // GPRs write enable control output
    .ld_D(ld_D),                                  // Load control output
    .jal_D(jal_D),                                // Jump and Link control output
    .jalr_D(jalr_D),                              // Jump and Link Register control output
    .lui_D(lui_D),                                // Load Upper Immediate control output
    .auipc_D(auipc_D),                            // Add Upper Immediate to PC control output
    .branch_instruction_D(branch_instruction_D),
    .byte_D(byte_D),                              // Byte control output
    .half_word_D(half_word_D),                    // Half word control output
    .full_word_D(full_word_D),                    // Full word control output
    .byteU_D(byteU_D),                            // Unsigned byte control output
    .half_wordU_D(half_wordU_D),                  // Unsigned half word control output
    .sn_D(sn_D),                                  // Shift amount control output
    .Mul_en_D(Mul_en_D),                          // Multiplication enable control output
    .Div_en_D(Div_en_D),                          // Division enable control output
    .M_sel_D(M_sel_D),                            // Select control output for DIV REM, LSB result, and MSB result
    .result_sel_D(result_sel_D)   ,                // Multiplication result selection control output
    .ebreak_D(ebreak_D)                           // Ebreak instruction control signal
    ,
    .rs1_valid_D(rs1_valid_D),
    .rs2_valid_D(rs2_valid_D)
);


ID_EX_Buffer ID_EX_instance (
    .ID_EX_ce(ID_EX_ce),               // Clock enable input
    .ID_EX_clk(ID_EX_clk),             // Clock input
    .ID_EX_rst(ID_EX_rst),             // Reset input
.ID_EX_nop(ID_EX_nop),

    // Input data from ID stage
     .rs1_valid_D(rs1_valid_D),
    .rs2_valid_D(rs2_valid_D),
    
    .reg_read_addr_1_D(reg_read_addr_1_D),     // 5-bit register read address 1 input
    .reg_read_addr_2_D(reg_read_addr_2_D),     // 5-bit register read address 2 input
    .reg_read_data_1_D(reg_read_data_1_D),     // 32-bit register read data 1 input
    .reg_read_data_2_D(reg_read_data_2_D),     // 32-bit register read data 2 input
    .reg_write_dest_D(reg_write_dest_D),       // 32-bit register write destination input
    .immediate_D(immediate_D),                 // 32-bit immediate data input
    .PCplus4_D(PCplus4_D),
    
    // Branch detection signal and data
    .PC_D(PC_D),
    .PCnew_D(PCnew_D),                 // Branch detection signal input
    .PCin1_D(PCin1_D),                 // 32-bit PCin1 data input

    // Control signals
    .alu_op_D(alu_op_D),               // 4-bit ALU operation input
    .mem_read_D(mem_read_D),           // Memory read control signal input
    .mem_write_D(mem_write_D),         // Memory write control signal input
    .selRs2Imm_D(selRs2Imm_D),         // Rs2/Immediate selection control signal input
    .selRs1PC_D(selRs1PC_D),           // Rs1/PC selection control signal input
    .gprs_we_i_D(gprs_we_i_D),         // Register write enable control signal input

    // Write back signals
    .ld_D(ld_D),                       // Load instruction control signal input
    .jal_D(jal_D),                     // Jump and link instruction control signal input
    .jalr_D(jalr_D),                   // Jump and link register instruction control signal input
    .lui_D(lui_D),                     // Load upper immediate instruction control signal input
    .ebreak_D(ebreak_D),               // Ebreak instruction control signal

    // Memory signals
    .byte_D(byte_D),                   // Byte memory access control signal input
    .half_word_D(half_word_D),         // Half-word memory access control signal input
    .full_word_D(full_word_D),         // Full-word memory access control signal input
    .byteU_D(byteU_D),                 // Unsigned byte memory access control signal input
    .half_wordU_D(half_wordU_D),       // Unsigned half-word memory access control signal input

    // ALU signals
    .sn_D(sn_D),                       // Shift amount control signal input
    .Mul_en_D(Mul_en_D),               // Multiply enable control signal input
    .Div_en_D(Div_en_D),               // Divide enable control signal input
    .M_sel_D(M_sel_D),                 // Multiplexer selection control signal input
    .result_sel_D(result_sel_D),       // Result selection control signal input

    // Output data to EX stage
     .rs1_valid_E(rs1_valid_E),
    .rs2_valid_E(rs2_valid_E),
    .reg_read_addr_1_E(reg_read_addr_1_E),     // 5-bit register read address 1 output
    .reg_read_addr_2_E(reg_read_addr_2_E),     // 5-bit register read address 2 output
    .reg_read_data_1_E(reg_read_data_1_E),     // 32-bit register read data 1 output
    .reg_read_data_2_E(reg_read_data_2_E),     // 32-bit register read data 2 output
    .reg_write_dest_E(reg_write_dest_E),       // 32-bit register write destination output
    .immediate_E(immediate_E),                 // 32-bit immediate data output
    .PCplus4_E(PCplus4_E),
    
    // Output branch detection signal and data to EX stage
    .PC_E(PC_E),
    .PCnew_E(PCnew_E),                 // Branch detection signal output
    .PCin1_E(PCin1_E),                 // 32-bit PCin1 data output

    // Output control signals to EX stage
    .alu_op_E(alu_op_E),               // 4-bit ALU operation output
    .mem_read_E(mem_read_E),           // Memory read control signal output
    .mem_write_E(mem_write_E),         // Memory write control signal output
    .selRs2Imm_E(selRs2Imm_E),         // Rs2/Immediate selection control signal output
    .selRs1PC_E(selRs1PC_E),           // Rs1/PC selection control signal output
    .gprs_we_i_E(gprs_we_i_E),         // Register write enable control signal output
    .ld_E(ld_E),                       // Load instruction control signal output
    .jal_E(jal_E),                     // Jump and link instruction control signal output
    .jalr_E(jalr_E),                   // Jump and link register instruction control signal output
    .lui_E(lui_E),                     // Load upper immediate instruction control signal output
    .auipc_E(auipc_E),                 // Add upper immediate to PC instruction control signal output
    .byte_E(byte_E),                   // Byte memory access control signal output
    .half_word_E(half_word_E),         // Half-word memory access control signal output
    .full_word_E(full_word_E),         // Full-word memory access control signal output
    .byteU_E(byteU_E),                 // Unsigned byte memory access control signal output
    .half_wordU_E(half_wordU_E),       // Unsigned half-word memory access control signal output
    .sn_E(sn_E),                       // Shift amount control signal output
    .Mul_en_E(Mul_en_E),               // Multiply enable control signal output
    .Div_en_E(Div_en_E),               // Divide enable control signal output
    .M_sel_E(M_sel_E),                 // Multiplexer selection control signal output
    .result_sel_E(result_sel_E),        // Result selection control signal output
    .ebreak_E(ebreak_E)                // Ebreak instruction control signal
);

EX EX_instance (
    .reg_read_data_1_E(reg_read_data_1_E),     // 32-bit register read data 1 input
    .reg_read_data_2_E(reg_read_data_2_E),     // 32-bit register read data 2 input
    .immediate_E(immediate_E),                 // 32-bit immediate input
    .PC_E(PC_E),                               // 32-bit PC input

.rdata2_fd(rdata2_fd),

    // Control signals
    .selRs2Imm_E(selRs2Imm_E),                 // Rs2/Immediate selection control signal input
    .selRs1PC_E(selRs1PC_E),                   // Rs1/PC selection control signal input
    .alu_op_E(alu_op_E),                       // 4-bit ALU operation input
    .sn_E(sn_E),                               // Shift amount control signal input
    .Mul_en_E(Mul_en_E),                       // Multiply enable control signal input
    .Div_en_E(Div_en_E),                       // Divide enable control signal input
    .M_sel_E(M_sel_E),                         // Multiplexer selection control signal input
    .result_sel_E(result_sel_E),               // Result selection control signal input

    // Output data
    .ALU_out_E(ALU_out_E),                     // 32-bit ALU output
    .ALU_out_W(ALU_out_W),
    
    // Data forwarding
    .ForwardAE(ForwardAE),                     // Forwarding control signal for operand A input
    .ForwardBE(ForwardBE),                     // Forwarding control signal for operand B input


    // Data from MEM stage
    .mem_read_data_W(mem_read_data_W),         // 32-bit memory read data from WB stage input
    .ALU_out_M(ALU_out_M)                      // 32-bit ALU output from MEM stage input
);


EX_MEM_Buffer EX_MEM_Buffer_instance (
    .EX_MEM_ce(EX_MEM_ce),                           // Clock enable input
    .EX_MEM_clk(EX_MEM_clk),                         // Clock input
    .EX_MEM_rst(EX_MEM_rst),                         // Reset input
.EX_MEM_nop(EX_MEM_nop),

    // Input data from EX stage
    .immediate_E(immediate_E),                       // 32-bit immediate input
    .reg_write_dest_E(reg_write_dest_E),             // 5-bit register write destination input
    .ALU_out_E(ALU_out_E),                           // 32-bit ALU output input
    .reg_read_data_2_E(rdata2_fd),            // 32 bit rs2data to write it in memory , came from the forwarding unit------------------------
    .PCplus4_E(PCplus4_E),
    
    
    // Memory Control signals
    .mem_read_E(mem_read_E),                         // Memory read control signal input
    .mem_write_E(mem_write_E),                       // Memory write control signal input
    .gprs_we_i_E(gprs_we_i_E),                       // Register file write enable control signal input
    .byte_E(byte_E),                                 // Byte memory access control signal input
    .half_word_E(half_word_E),                       // Half-word memory access control signal input
    .full_word_E(full_word_E),                       // Full-word memory access control signal input
    .byteU_E(byteU_E),                               // Unsigned byte memory access control signal input
    .half_wordU_E(half_wordU_E),                     // Unsigned half-word memory access control signal input
     
    // Write back control signals 
    .ld_E(ld_E),                                     // Load data control signal input
    .jal_E(jal_E),                                   // Jump and link control signal input
    .jalr_E(jalr_E),                                 // Jump and link register control signal input
    .lui_E(lui_E),                                   // Load upper immediate control signal input

    // Output data to MEM stage
    .ALU_out_M(ALU_out_M),                           // 32-bit ALU output output
    .reg_write_dest_M(reg_write_dest_M),             // 5-bit register write destination output
    .immediate_M(immediate_M),                       // 32-bit immediate output
    .reg_read_data_2_M(reg_read_data_2_M),            // 32 bit rs2data to write it in memory 
    .PCplus4_M(PCplus4_M),
    
    // Output control signals to MEM stage
    .mem_read_M(mem_read_M),                         // Memory read control signal output
    .mem_write_M(mem_write_M),                       // Memory write control signal output
    .gprs_we_i_M(gprs_we_i_M),                       // Register file write enable control signal output
    .byte_M(byte_M),                                 // Byte memory access control signal output
    .half_word_M(half_word_M),                       // Half-word memory access control signal output
    .full_word_M(full_word_M),                       // Full-word memory access control signal output
    .byteU_M(byteU_M),                               // Unsigned byte memory access control signal output
    .half_wordU_M(half_wordU_M),                     // Unsigned half-word memory access control signal output
    
    // OUTPUT Write back control signals 
    .ld_M(ld_M),                                     // Load data control signal output
    .jal_M(jal_M),                                   // Jump and link control signal output
    .jalr_M(jalr_M),                                 // Jump and link register control signal output
    .lui_M(lui_M)                                    // Load upper immediate control signal output
);

MEM #(
    .DATA_MEM_SIZE(DATA_MEM_SIZE)                   // Parameter: Size of the data memory
) MEM_instance (
    .clk(clk),                                       // Clock input
    
    .byte_M(byte_M),                                 // Byte memory access control signal input
    .half_word_M(half_word_M),                       // Half-word memory access control signal input
    .full_word_M(full_word_M),                       // Full-word memory access control signal input
    .byteU_M(byteU_M),                               // Unsigned byte memory access control signal input
    .half_wordU_M(half_wordU_M),                     // Unsigned half-word memory access control signal input
    
    .ALU_out_M(ALU_out_M),                           // 32-bit ALU output input (byte address)
    .reg_read_data_2_M(reg_read_data_2_M),           // 32-bit data to be written into the memory
    
    .mem_read_M(mem_read_M),                         // Memory read control signal input
    .mem_write_M(mem_write_M),                       // Memory write control signal input
    .mem_read_data_M(mem_read_data_M)                // 32-bit data read from memory output
    
       //-----------Pheripheral Memory mapping  ports----------
    `ifdef INPUT_SWITCH__OUTPUT_7_SEGMENT  
    ,.switch_in_data(switch_in_data),
    .display_7_seg_data(display_7_seg_data)
     `endif                          
 //---------------------------------
 
 
);

MEM_WB_Buffer MEM_WB_Buffer_instance (
    .MEM_WB_ce(MEM_WB_ce),                           // Clock enable input
    .MEM_WB_clk(MEM_WB_clk),                         // Clock input
    .MEM_WB_rst(MEM_WB_rst),                         // Reset input
.MEM_WB_nop(MEM_WB_nop),


//inputs to get the required specific data memory
.mem_access_addr_1_0_bits_M(mem_access_addr_1_0_bits_M),
    .byte_M(byte_M),                                 // Byte memory access control signal output
    .half_word_M(half_word_M),                       // Half-word memory access control signal output
    .full_word_M(full_word_M),                       // Full-word memory access control signal output
    .byteU_M(byteU_M),                               // Unsigned byte memory access control signal output
    .half_wordU_M(half_wordU_M),                     // Unsigned half-word memory access control signal output
    


    // Input data from MEM stage
    .mem_read_data_M(mem_read_data_M),               // 32-bit data from MEM stage
    .reg_write_dest_M(reg_write_dest_M),             // 5-bit register write destination from MEM stage
     .gprs_we_i_M(gprs_we_i_M),                      // gprs write enable fro  the wb satge as output signa;l
    .ALU_out_M(ALU_out_M),                           // 32-bit ALU output from MEM stage
    .immediate_M(immediate_M),                       // 32-bit immediate value from MEM stage
.PCplus4_M(PCplus4_M),

    // Control signals
    .ld_M(ld_M),                                     // Load control signal
    .jal_M(jal_M),                                   // Jump and link control signal
    .jalr_M(jalr_M),                                 // Jump and link register control signal
    .lui_M(lui_M),                                   // Load upper immediate control signal

    // Output data to WB stage
    .mem_read_data_W(mem_read_data_W),               // 32-bit data to WB stage
    .reg_write_dest_W(reg_write_dest_W),             // 5-bit register write destination to WB stage
    .gprs_we_i_W(gprs_we_i_W),                      // gprs write enable fro  the wb satge as output signal
    .ALU_out_W(ALU_out_W),                           // 32-bit ALU output to WB stage
    .immediate_W(immediate_W),                       // 32-bit immediate value to WB stage
.PCplus4_W(PCplus4_W),
    // Output control signals to W stage
    .ld_W(ld_W),                                     // Load control signal to WB stage
    .jal_W(jal_W),                                   // Jump and link control signal to WB stage
    .jalr_W(jalr_W),                                 // Jump and link register control signal to WB stage
    .lui_W(lui_W)                                    // Load upper immediate control signal to WB stage
    
);

WB WB_instance (
    // Input data
    .ALU_out_W(ALU_out_W),             // 32-bit ALU output from MEM stage
    .mem_read_data_W(mem_read_data_W), // 32-bit data from MEM stage
    .PCplus4_W(PCplus4_W),             // 32-bit PC plus 4 data
    .immediate_W(immediate_W),         // 32-bit immediate value from MEM stage
    
    // Control signals
    .ld_W(ld_W),                       // Load control signal
    .jal_W(jal_W),                     // Jump and link control signal
    .jalr_W(jalr_W),                   // Jump and link register control signal
    .lui_W(lui_W),                     // Load upper immediate control signal
    
    // Output
    .reg_write_data_W(reg_write_data_W) // 32-bit data to be written to register file
);

Hazard_unit Hazard_unit_inst (
    // Clock and reset signals
    .clk(clk),
    .rst(rst),
    
    //ebrak instruction signal
    .ebreak_E(ebreak_E), 
    
    .branch_instruction_D(branch_instruction_D),
    .jump_D(jump_D),
    // Control hazards signals
    .PCnew_E(PCnew_E),
    
    .PC_ce(PC_ce),
    .PC_rst(PC_rst),
    
    // Data hazards signals
    .rs1_valid_E(rs1_valid_E),
    .rs2_valid_E(rs2_valid_E),
    
    .gprs_we_i_E(gprs_we_i_E),
    . gprs_we_i_M( gprs_we_i_M),
    .gprs_we_i_W(gprs_we_i_W),
    
    
    .reg_read_addr_1_E(reg_read_addr_1_E),
    .reg_read_addr_2_E(reg_read_addr_2_E),
  
   .ld_E(ld_E),
    .ld_M(ld_M),
    .ld_W(ld_W),
    
    .reg_write_dest_M(reg_write_dest_M),
      .reg_write_dest_E(reg_write_dest_E),
            .reg_write_dest_W(reg_write_dest_W),
    
    // Forwarding signals
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    
    // Control enable signals
    .IF_ID_ce(IF_ID_ce),
    .ID_EX_ce(ID_EX_ce),
    .EX_MEM_ce(EX_MEM_ce),
    .MEM_WB_ce(MEM_WB_ce),
    .MEM_WB_nop(MEM_WB_nop),
    .IF_ID_nop(IF_ID_nop),
    .ID_EX_nop(ID_EX_nop),
    .EX_MEM_nop(EX_MEM_nop),
    
    // Control reset signals
    .IF_ID_rst(IF_ID_rst),
    .ID_EX_rst(ID_EX_rst),
    .EX_MEM_rst(EX_MEM_rst),
    .MEM_WB_rst(MEM_WB_rst),
    
    .ForwardAD(ForwardAD),
    .ForwardBD(ForwardBD),
    
    
   .reg_read_addr_1_D(reg_read_addr_1_D),       // 5-bit register address 1 output
    .reg_read_addr_2_D(reg_read_addr_2_D)      // 5-bit register address 1 output
    
    
   
);



// IF_ID_Buffer Module
assign IF_ID_clk = clk;


// ID_EX_Buffer Module
assign ID_EX_clk = clk;


// EX_MEM_Buffer Module
assign EX_MEM_clk = clk;


// MEM_WB_Buffer Module
assign MEM_WB_clk = clk;

assign reg_write_data_W_out[0]=reg_write_data_W[0];
assign reg_write_data_W_out[1]=reg_write_data_W[31];



endmodule
