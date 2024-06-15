`timescale 1ns/1ps
module ALU (output reg [31:0] AluRes, input [31:0] A,B, input [3:0] Opcode);


always @(A, B, Opcode)
begin 

case (Opcode)
4'b0000 : AluRes = 32'b0;
4'b0001 : AluRes = A+1;
4'b0010 : AluRes = A+B;
4'b0011 : AluRes = A-1;
4'b0100 : AluRes = A-B;
4'b0101 : AluRes = B-A;
4'b0110 : AluRes = A*B;
4'b0111 : AluRes = B;
4'b1000 : AluRes = A&B;
4'b1001 : AluRes = A|B;
4'b1010 : AluRes = A^B;
4'b1011 : AluRes = ~A ;	
4'b1100 : AluRes = A<<1;
4'b1101 : AluRes = A<<B;
4'b1110 : AluRes = A>>1;
4'b1111 : AluRes = A>>B;
default: AluRes=32'bz;
endcase
end
endmodule 

module ALU_TEST() ;
reg [3:0] Opcode;
reg [31:0] a,b;
wire [31:0] AluRes;

ALU UUT(.AluRes(AluRes), .a(a), .b(b), .Opcode(Opcode));

initial 
begin
#10 a = 32'd4; 
#10 b = 32'd2;
#10 Opcode = 4'b0000; 
#10 Opcode = 4'b0001;
#10 Opcode = 4'b0010;
#10 Opcode = 4'b0011; 
#10 Opcode = 4'b0100; 
#10 Opcode = 4'b0101; 
#10 Opcode = 4'b0110; 
#10 Opcode = 4'b0111; 
#10 Opcode = 4'b1000;
#10 Opcode = 4'b1001;
#10 Opcode = 4'b1010;
#10 Opcode = 4'b1011; 
#10 Opcode = 4'b1100;  
#10 Opcode = 4'b1101; 
#10 Opcode = 4'b1110;  
#10 Opcode = 4'b1111;  
end

endmodule 
