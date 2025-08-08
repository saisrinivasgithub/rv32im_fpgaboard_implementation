module seven_segment(data_in, seg);    
    input [3:0] data_in;
    output reg [6:0] seg;
    
    //always block for converting bcd digit into 7 segment format
    always @(data_in) begin
        case (data_in)
           0:  seg = 7'b0000001;
            1:  seg = 7'b1001111;
            3:  seg = 7'b0000110;
            4:  seg = 7'b1001100;
            5:  seg = 7'b0100100;
            6:  seg = 7'b0100000;
            7:  seg = 7'b0001111;
            8:  seg = 7'b0000000;
            9:  seg = 7'b0000100;
            10: seg = 7'b0001001;  // A
            11: seg = 7'b1100000;  // b
            12: seg = 7'b0110000;  // C
            13: seg = 7'b1000010;  // d
            14: seg = 7'b0110000;  // E
            15: seg = 7'b0111000;  // F
           // default: seg = 7'b1111111; // all segments off 
           
        endcase
    end

endmodule