`timescale 1ns / 1ps
module mul #(parameter N=8,M=8)(A,B,sn,out);
    input [N-1:0]A;
    input [M-1:0]B;
    input [1:0]sn;
    output reg [M+N-1:0]out;
 


   wire [N-1:0]a;
   wire [M-1:0]b;
   assign a=sn[1]?(A[N-1]?(~(A-1)):A)		:A       ;
   assign b=sn[0]?(B[M-1]?(~(B-1)):B)		:B       ;

   wire [M+N-1:0]Y;
Array_MUL_USign #(N,M)  unsign_forsign(a,b,Y);
//assign out=~(sn[0]^sn[1])?	(A[N-1]|B[M-1] ?~{1'b0,Y[M+N-2:0]}+1 :Y	)		:Y;
always@(*)begin
if(sn==2'b11)begin
    if((A[N-1]^B[M-1])==1)
        out=~{1'b0,Y[M+N-2:0]}+1;
    else 
        out=Y;
end
else if(sn==2'b10)begin
    if((A[N-1])==1)
        out=~{1'b0,Y[M+N-2:0]}+1;
    else 
        out=Y;
end
else 
    out=Y;
end

 


endmodule

