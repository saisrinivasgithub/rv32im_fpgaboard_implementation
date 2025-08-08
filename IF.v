`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2024 11:48:58
// Design Name: 
// Module Name: IF
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


module IF #(parameter INSTR_SIZE=145722) (
    input clk,
    input rst,

    //ebreak instruction
    input ebreak_E,
    input Instr_ce,
    input Instr_nop,
    
    //new target PC address control signal
    input PCnew_E,
    
    //input data
      input [31:0] immediate_E,
    input [31:0] PCin1_E,

 //   input [31:0] immediate_DF,
  //  input [31:0] PCin1_DF,

    //PC counter signals
   input PC_ce,
   //input PC_rst,
    //PC OUTPUTS 
    output wire [31:0] PCplus4_F,
    output wire [31:0] PC_F,
    
    
    //instructions
    output [31:0]instruction_F,
    
    //instrcution mem write
input instrWrEn,
input [31:0]InstrWrAdd,
input [7:0]InstrWrData

    );
    
  wire Instruct_Mem_op=(!(Instr_nop|rst |ebreak_E));
    // InstructionMemory#(INSTR_SIZE) instrctionmeminstance(.start(!rst),.pc(pc_current),.instruction(instruction));
InstructionMemry_withWrite #(INSTR_SIZE) InstructionMemory_inst_wth_wr (
    .instrWrEn(instrWrEn),
    .InstrWrAdd(InstrWrAdd),
    .InstrWrData(InstrWrData),

    .clk(clk),                 // Input: Clock signal
    .Instruct_Mem_op(Instruct_Mem_op), // Input: Start signal for initiating read operation, controled by the  the ebreak ,or Imnstructn mem reset  only
    .Instr_ce(Instr_ce),
    .pc(PC_F),                   // Input: Program counter for reading
    .instruction(instruction_F)  // Output: Instruction output
);


//Adder to calcuate the pcTarget 
//assigning iinputs to get addeded when only new jump/brach pc adrresss is detected
wire [31:0]PCTarget; 
wire [31:0]PCin1_pcAddTarget,immediate_addPcTarget;
assign  PCin1_pcAddTarget        =PCnew_E?PCin1_E:32'd0;
assign  immediate_addPcTarget    =PCnew_E?immediate_E:32'd0;

Han_Carlson_adder_32  #(32) PCTargetAdder(
    .A(PCin1_pcAddTarget),
    .B(immediate_addPcTarget),
    .Cin(1'b0),
    .Sum(PCTarget)
);

wire PC_clk,PC_rst;
assign PC_rst=rst;
//assign PC_clk=PC_ce?clk:1'b0; 
assign PC_clk=clk;

PCF PCF_instance (
    .en(PC_ce),
    .clk(PC_clk),                   // Connect clk input (not specifying size as it's a single bit)
    .rst(PC_rst),                   // Connect rst input (not specifying size as it's a single bit)
    .PCSel(PCnew_E),               // Connect PCnew_E input ,if PCnew_E is 0 then PC=PC+4 , if PCnew_E=1 ,then PC=
    .PCTarget(PCTarget),         // Connect PCTarget input (size is already specified as [31:0])

    .PCplus4(PCplus4_F),           // Connect PCPlus4 output (size is already specified as [31:0])
    .PCF(PC_F)                    // Connect PCF output (size is already specified as [31:0])
);





endmodule
