module Div #(parameter WIDTH = 32)(Num,Denm,sn,quo,rem);

    //the size of input and output ports of the division module is generic.
    
    //input and output ports.
    input [WIDTH-1:0] Num;
    input [WIDTH-1:0] Denm;
    input sn;
    output [WIDTH-1:0] quo;
    output reg [WIDTH-1:0] rem;
    
    wire [WIDTH-1:0]A,B;
      
    reg [WIDTH-1:0] Res = 0;
    reg [WIDTH-1:0] a1,b1;
    reg [WIDTH:0] p1;   
    integer i;
    
 //assign A=A[WIDTH]?(~Num[31:0]+1'b1) : Num  ;
 //assign A=A[WIDTH]?(~Denm[31:0]+1'b1) : Denm  ;
    assign A=sn?(Num[WIDTH-1]?(~(Num-1)):Num)		:Num       ;
   assign B=sn?(Denm[WIDTH-1]?(~(Denm-1)):Denm)		:Denm       ;

 wire neg;
 assign neg =A[WIDTH-1] | B[WIDTH-1];
 
    always@ (A or B)
    begin
        //initialize the variables.
        a1 = A;
        b1 = B;
        p1= 0;
        for(i=0;i < WIDTH;i=i+1)    begin //start the for loop
            p1 = {p1[WIDTH-2:0],a1[WIDTH-1]};
            a1[WIDTH-1:1] = a1[WIDTH-2:0];
            p1 = p1-b1;
            if(p1[WIDTH-1] == 1)    begin
                a1[0] = 0;
                p1 = p1 + b1;   end
            else
                a1[0] = 1;
            if(i==WIDTH-1)
                rem=p1;
        end
        Res = a1;   
    end 

assign quo=(Num[WIDTH-1]^Denm[WIDTH-1])? (~Res+1'b1) : Res;
endmodule
