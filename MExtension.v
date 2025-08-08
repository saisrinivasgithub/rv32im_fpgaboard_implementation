module MExtension(
    input Mul_en,
    input Div_en,
    input [31:0] A,
    input [31:0] B,
    input [1:0] Sign,
    output [31:0] AB_msb,
    output [31:0] AB_lsb,
    output [31:0] AbyB_REM,
    output [31:0] AbyB_QUO
);


localparam MUL_SIZE=33; 
wire [MUL_SIZE-1:0] mul1, mul2;
wire [2*MUL_SIZE-1:0] mul_out;
wire [31:0] Num, Denm;
wire [31:0] quo, rem;

assign mul1 = Mul_en ?{Sign&A[31], A} : {(MUL_SIZE){1'b0}};//if multiplicer size is 33
assign mul2 = Mul_en ?{Sign&B[31], B} : {(MUL_SIZE){1'b0}};//if multiplicer size is 33
assign Num = Div_en ? A : 32'd1;
assign Denm = Div_en ? B : 32'd1;

mul #(MUL_SIZE, MUL_SIZE) Mul_instance(mul1, mul2, Sign, mul_out);
Div #(32) Div_instance(Num, Denm, Sign[0] & Sign[1], quo, rem);

assign AB_msb=mul_out[63:32];
assign AB_lsb=mul_out[31:0];
assign AbyB_REM=rem;
assign AbyB_QUO=quo;

endmodule