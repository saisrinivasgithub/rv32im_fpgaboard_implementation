module InstructionMemry_withWrite #(parameter INSTR_SIZE=1024)(
input instrWrEn,
input [31:0]InstrWrAdd,
input [7:0]InstrWrData,

input clk,
input Instruct_Mem_op,
input Instr_ce,
 input[31:0] pc,            //byte address
 output reg [31:0] instruction
);
localparam col=32;
localparam row_i=INSTR_SIZE;

(* ram_style = "block" *)
 reg [col - 1:0] memory [row_i - 1:0];
 
 wire [29:0]rom_addr;
 assign rom_addr[29:0] = pc[31: 2];


initial
 begin
$readmemh("data.mem", memory,0,5);
/*memory[0]=32'h400000b7;
 memory[1]=32'h0000a103;
 memory[2]=32'h0020a223;
 memory[3]=32'hff9ff06f;
 memory[4]=32'hffdff06f;
 memory[5]=32'hffdff06f;*/
 // memory[0]=32'h400000b7;
 //memory[1]=32'h0000a103;
 //memory[2]=32'h0040a083;
 //memory[3]=32'h00a12023;
 //memory[4]=32'hfff0006f;
// memory[5]=32'hffdff06f;
 
 
 //$readmemh("C:/Users/gvtkv/OneDrive - iittp.ac.in/IIT Tirupati/Acadamics/BTP/RISC-V processor/PIPELINED/rv32im_piplined_synchronous_memories/uploaded codes/squareRoot.mem", memory,0,row_i-1);
//$readmemh("Fibanacchi.mem", memory,0,row_i-1);
//$readmemh("mul_div.mem", memory,0,row_i-1);
 end

//assign instruction = Instruct_Mem_op? memory[rom_addr[$clog2(row_i):0]]:32'd0;// we are giving 5 bit address since instr mem size is 32 only  
// assign instruction = Instruct_Mem_op? memory[rom_addr[29:0]]:32'd0;

//wire Instr_clk=Instr_ce?clk:0;
wire Instr_clk=clk;
always@(posedge Instr_clk)begin if(Instr_ce)begin
if(!Instruct_Mem_op)
instruction<=32'd0;
else if (Instruct_Mem_op)
instruction<=memory[rom_addr[29:0]];
end
end

/*
wire [29:0]wrAddWord; 
assign wrAddWord=InstrWrAdd[31:2];

 always@(posedge clk)begin
 if(instrWrEn==1'b1)begin
 case(InstrWrAdd[1:0])
 2'b00: memory[wrAddWord[9:0]][7:0]=InstrWrData;
 2'b01: memory[wrAddWord[9:0]][15:8]=InstrWrData;
 2'b10: memory[wrAddWord[9:0]][23:16]=InstrWrData;
 2'b11: memory[wrAddWord[9:0]][31:24]=InstrWrData;
 endcase 
 end
 end
 */
endmodule
