`timescale 1ns / 1ps

module PCF (
input en,
    input clk,
    input rst,
    
    // Control signal
    input PCSel,
    
    //input data
    input [31:0] PCTarget,
    
    //    input [31:0] PCPlusImm,
    //input [31:0] PCRs1plusImm,
    
    output  [31:0] PCplus4,
    output reg [31:0] PCF
);

// Instantiate PCPlus4Adder module
PCPlus4Adder pc_4_adder_instance (
    .PC(PCF),             // Connecting PCF to PC input of PCPlus4Adder
    .PCplus4(PCplus4)     // Connecting PCPlus4 to PCPlus4 output of PCPlus4Adder
);

// Always block for PCF calculation
always @(posedge clk) begin  if(en)begin
    if (rst == 1'b1) begin
         PCF <= 32'b0;
       // PCF <= 32'h4c;          //Fibanacchi.mem starting
    end else begin
        case (PCSel)
            1'b0: PCF <= PCplus4;
            1'b1: PCF <= PCTarget;
        endcase
    end
end
end
endmodule
