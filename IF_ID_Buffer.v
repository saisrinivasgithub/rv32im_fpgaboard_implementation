module IF_ID_Buffer (
    input IF_ID_ce,
    output Instr_ce,
    
    input IF_ID_clk,
    input IF_ID_rst,
    
    input IF_ID_nop,
    output Instr_nop,
    
    input [31:0] PC_F,
    output reg[31:0] PC_D,
    
    input [31:0] instruction_F,
    
    
    input [31:0] PCplus4_F,
    output reg [31:0] PCplus4_D,
    
    
    output  [31:0] instruction_D
);
assign Instr_ce=IF_ID_ce;
assign Instr_nop=IF_ID_nop;

//wire clk_enabled=IF_ID_ce?IF_ID_clk:1'b0;
wire clk_enabled=IF_ID_clk;

//when the instrmem is synchronus reading , then no need of extra buffer resiter for that,
//assign instruction_D = (IF_ID_rst| IF_ID_nop)? 32'd0:instruction_F;
assign instruction_D = instruction_F;


//posedge rest is useful to reset the system asynchronosouly
always @(posedge clk_enabled ) begin
if(IF_ID_ce)begin
    if (IF_ID_rst) begin
        PC_D <= 32'd0;
        PCplus4_D<=32'd0;
        //instruction_D <= 32'd0;
        end
    else if(IF_ID_nop)begin      
      PC_D <= 32'd0;
   //PC_D<=PC_F;
        PCplus4_D<=32'd0;
    //    instruction_D <= 32'd0;
        
    end 
    else begin
        PC_D<=PC_F;
        
        PCplus4_D<= PCplus4_F;
      //  instruction_D <= instruction_F;
    end
end
end


endmodule