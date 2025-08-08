`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.07.2025 16:15:46
// Design Name: 
// Module Name: display_bcd_7segment_4digit
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


module display_bcd_7segment_4digit( 
     data_in,
     seg, digit_sel, DP, clk  );
     
  
  //Declare inputs,outputs and internal variables.
     input clk;
   
     wire [1:0]dp_sel;  // Select lines for Display   
     input [15:0] data_in;    //Inputs from switches 13 to 0 
     output [6:0] seg;   // Seven Segment display pins 
       
    output [3:0]digit_sel;   // Selecting one of the four seven segment dislays 
    output DP;               // point LED; Enable for fractions numbers display 
    
   wire [6:0]seg1, seg2, seg3, seg4;
    
    seven_segment  data_in1 (.data_in(data_in[3:0]), .seg(seg1));
    seven_segment  data_in2 (.data_in(data_in[7:4]), .seg(seg2)); 
   seven_segment  data_in3 (.data_in(data_in[11:8]), .seg(seg3));  
    seven_segment data_in4 (.data_in(data_in[15:12]), .seg(seg4)); 
  
  counterDP uut (.clk(clk),.counter(dp_sel));
  assign digit_sel = dp_sel[1]?(dp_sel[0]?4'b1000:4'b0100):(dp_sel[0]?4'b0010:4'b0001);  
  assign seg = dp_sel[1]?(dp_sel[0]?seg4:seg3):(dp_sel[0]?seg2:seg1);
  
  assign DP = 1'b1; 
  
endmodule
