`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.08.2025 14:10:46
// Design Name: 
// Module Name: dataMemory
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


 `define  INPUT_SWITCH__OUTPUT_7_SEGMENT


module dataMemory #(parameter DATA_MEM_SIZE=900)(
 input clk,
 
 input byte,half_word,full_word,byteU,half_wordU,  //byte data,word data, half_word data
 
 //input [15:0]   mem_access_addr,//byte address
 input [31:0]   mem_access_addr,
 input [31:0]   mem_write_data,
 input     mem_write,
 
 input mem_read,
 //output reg [31:0]   mem_read_data
 output [31:0]   mem_read_data
 
 
 
 
 
 //-----------Pheripheral Memory mapping  ports----------

    `ifdef INPUT_SWITCH__OUTPUT_7_SEGMENT
    
      ,  input [15:0] switch_in_data,
        output reg [31:0] display_7_seg_data
    `endif
    
 
 //---------------------------------


 
);
  `ifdef INPUT_SWITCH__OUTPUT_7_SEGMENT
//  parameter DISPLYA_7_SEG_ADDRESS=DATA_MEM_SIZE; //it toatal requires 4 byte addresses 
//  parameter SWITCH_ADDRESS=DISPLYA_7_SEG_ADDRESS+4;
    localparam DISPLYA_7_SEG_ADDRESS=32'h40000004; //it toatal requires 4 byte addresses 
  localparam SWITCH_ADDRESS=32'h40000000;
  
        reg [31:0] display_7_seg_mem;
        reg [15:0] switch_in_mem;
`endif


reg [31:0]read_data;
integer i;

localparam col=32;
localparam  row_d=DATA_MEM_SIZE;

  (* ram_style = "block" *)
reg [col - 1:0] memory [row_d - 1:0];
integer f1;
//wire [29:0] ram_addr={16'd0,mem_access_addr[15:2]};
wire [29:0] ram_addr={mem_access_addr[31:2]};


initial
begin
 $readmemh("data.mem", memory,0,row_d-1);
//  for(p=0;p<DATA_MEM_SIZE;p=p+1)
//    memory[p]=32'd0;
 end
 /*initial begin
        // Initialize all memory locations to 0
        for ( i = 0; i < row_d; i = i + 1) begin
            memory[i] = 32'd0;
        end
        
        // Optionally set specific memory locations with test values
        memory[0] = 32'h400000b7;  // Example data values
        memory[1] = 32'h0000a103;
        memory[2] = 32'h0020a223;
        memory[3] = 32'hff9ff06f;
        memory[4] = 32'hffdff06f;
        // Add more initffdff06fialization as needed
    end */     


  always @(posedge clk) begin                     //asynchronous write from Data Memory
   //----------------Data writing to mem---
      if((mem_write==1'b1)*(mem_access_addr<DATA_MEM_SIZE))begin
        if(byte == 1'b1 )begin
            if((~mem_access_addr[1])&(~mem_access_addr[0]))           //00
            memory[ram_addr][7:0] <= mem_write_data[7:0]; 
            if((~mem_access_addr[1])&(mem_access_addr[0]))           //01
            memory[ram_addr][15:8] <= mem_write_data[7:0];
            if((mem_access_addr[1])&(~mem_access_addr[0]))           //10
            memory[ram_addr][23:16] <= mem_write_data[7:0];
            if((mem_access_addr[1])&(mem_access_addr[0]))           //11
            memory[ram_addr][31:24] <= mem_write_data[7:0];
        end
        else if(( half_word==1'b1)&(mem_access_addr+1<32'd10240))begin         //If half word my max address would be 102388
            if(mem_access_addr[1])                           //1 
            memory[ram_addr][31:16] <= mem_write_data[15:0];
            if(~mem_access_addr[1])                           //0 
            memory[ram_addr][15:0] <= mem_write_data[15:0]; 
        end
        //else if ((full_word==1'b1)&(mem_access_addr+3<32'd10240))      //If full word my max address would be 102386
        else if ((mem_access_addr+3<32'd10240))    
            memory[ram_addr] <= mem_write_data[31:0];
     end
     
//----------data reading from mem--------------
 if ((mem_read==1'b1)*(mem_access_addr<DATA_MEM_SIZE))
			         read_data[31:0] <=memory[ram_addr];		         
 else if(mem_read==1'b0) read_data[31:0] <=32'd0;


//-----------------Pheriphiral logic---------------------
`ifdef INPUT_SWITCH__OUTPUT_7_SEGMENT
    //---------display_7_seg_data read adn write logic---------
    if(mem_access_addr==DISPLYA_7_SEG_ADDRESS)begin
        if(mem_write)
            display_7_seg_data<=mem_write_data;
         else 
             read_data[31:0]<=display_7_seg_data;
    end
    //-------------------Switch input pins mem reading  
    if((mem_access_addr==SWITCH_ADDRESS)&(mem_write==0))begin 
             read_data[31:0]<=switch_in_mem;
    end
    //--------------- alwyas switch mem writing............. 
     switch_in_mem<=switch_in_data; 
`endif


  end
 

assign  mem_read_data=read_data;

endmodule
