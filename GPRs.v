`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.01.2024 12:44:35
// Design Name: 
// Module Name: GPRs
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

//synchronous rst signal , if rstis 1 ,then rs1data,rs2data would be zero, annd rd[0]=0
//negedge write

module GPRs(
    input wire clk,
    input wire rst,
    input wire we_i,                     
    input wire[4:0] waddr_i,     
    input wire[31:0] wdata_i,          
    input wire[4:0] raddr1_i,     
    output reg [31:0] rdata1_o,         
    input wire[4:0] raddr2_i,     
    output reg [31:0] rdata2_o      
);

    reg [31:0] regs [0:31];

    // Initial block to initialize memory
    initial begin
  $readmemh("reg.mem" ,regs, 0, 31);
   end
   
   //showing the regsiter values in the terminal 
   /*always@(posedge clk)begin     
        // Display initial register values
        $display("Initial Register Values:");
        for (integer i = 0; i < 32; i = i + 1) begin
            $display("\tregs[%0d] = %d", i, regs[i]);
        end
    end
  */  

    // Always block for register write and reset in negative edge clk
      always @ (negedge clk ) begin
	        if ((we_i == 1'b1) && (waddr_i!= 5'd0)&(rst==0)) 
	                regs[waddr_i] <= wdata_i;
	        else   
	                regs[0] <=32'd0;       //if eriting address is zero then the r[0] is zero
	        end

    // Assign output values
    always @* begin
        rdata1_o = rst ? 32'd0 : regs[raddr1_i];
        rdata2_o = rst ? 32'd0 : regs[raddr2_i];
    end

endmodule


/*
module GPRs(
	

	    input wire clk,
	    input wire rst,
	    // from ex
	    input wire we_i,                     // write register flag
	    input wire[4:0] waddr_i,     // write register address
	    input wire[31:0] wdata_i,          // write register data
	    // from id
	    input wire[4:0] raddr1_i,     // read register 1 address
	    output [31:0] rdata1_o,         // read register 1 data
	 
	    input wire[4:0] raddr2_i,     // read register 2 addres
	    output [31:0] rdata2_o      // read register 2 data
	    );
	

	    reg[31:0] regs[0:31];
	    integer f1;
 initial
 begin
//  $readmemb("instructions.mem", memory,0,row_i-1);
  $readmemb("C:/Users/gvtkv/OneDrive - iittp.ac.in/IIT Tirupati/Acadamics/BTP/RISC-V processor/shared codes/rv32iprocessorcodes-keerthija/project_keerthija_codes/project_keerthija_codes.srcs/sources_1/new/reg.mem", regs,0,31);

  $fmonitor("time = %d\n", $time,
"\tregs[0] = %d\n", regs[0],
"\tregs[1] = %d\n", regs[1],
"\tregs[2] = %d\n", regs[2],
"\tregs[3] = %d\n", regs[3],
"\tregs[4] = %d\n", regs[4],
"\tregs[5] = %d\n", regs[5],
"\tregs[6] = %d\n", regs[6],
"\tregs[7] = %d\n", regs[7],
"\tregs[8] = %d\n", regs[8],
"\tregs[9] = %d\n", regs[9],
"\tregs[10] = %d\n", regs[10],
"\tregs[11] = %d\n", regs[11],
"\tregs[12] = %d\n", regs[12],
"\tregs[13] = %d\n", regs[13],
"\tregs[14] = %d\n", regs[14],
"\tregs[15] = %d\n", regs[15],
"\tregs[16] = %d\n", regs[16],
"\tregs[17] = %d\n", regs[17],
"\tregs[18] = %d\n", regs[18],
"\tregs[19] = %d\n", regs[19],
"\tregs[20] = %d\n", regs[20],
"\tregs[21] = %d\n", regs[21],
"\tregs[22] = %d\n", regs[22],
"\tregs[23] = %d\n", regs[23],
"\tregs[24] = %d\n", regs[24],
"\tregs[25] = %d\n", regs[25],
"\tregs[26] = %d\n", regs[26],
"\tregs[27] = %d\n", regs[27],
"\tregs[28] = %d\n", regs[28],
"\tregs[29] = %d\n", regs[29],
"\tregs[30] = %d\n", regs[30],
"\tregs[31] = %d\n", regs[31]);

#5000;
 end	    
	
	    // write register
	    always @ (posedge clk ) begin
	        if ((we_i == 1'b1) && (waddr_i!= 5'd0)&(rst==0)) 
	                regs[waddr_i] <= wdata_i;
	        else   
	                regs[0] <=32'd0;       //rsting condition
	        end
	    
	assign rdata1_o=rst?32'd0:regs[raddr1_i];
	assign rdata2_o=rst?32'd0:regs[raddr2_i];
	
	
	endmodule*/
