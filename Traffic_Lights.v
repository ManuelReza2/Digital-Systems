module Traffic_Lights(light_highway, light_SR, C, clk, rst_n);
parameter HGRE_SRED=2'b00, // Highway green and side road red
   HYEL_SRED = 2'b01,// Highway yellow and side road red
   HRED_SGRE=2'b10,// Highway red and side road green
   HRED_SYEL=2'b11;// Highway red and side road yellow
input C, // sensor
   clk, // clock = 50 MHz
   rst_n; // reset active low
  output reg[2:0] light_highway, light_SR; 

reg[27:0] count=0,count_delay=0;
reg delay10s=0, delay3s1=0,delay3s2=0,RED_count_en=0,YELLOW_count_en1=0,YELLOW_count_en2=0;
wire clk_enable; // clock enable signal for 1s
reg[1:0] state, next_state;
// next state
always @(posedge clk or negedge rst_n)
begin
if(~rst_n)
 state <= 2'b00;
else 
 state <= next_state; 
end
// FSM
always @(*)
begin
case(state)
HGRE_SRED: begin // Green on highway and red on farm way
 RED_count_en=0;
 YELLOW_count_en1=0;
 YELLOW_count_en2=0;
 light_highway = 3'b001;
 light_SR = 3'b100;
  if(C) next_state = HYEL_SRED; 
 // if sensor detects vehicles on farm road, 
 // turn highway to yellow -> green
 else next_state =HGRE_SRED;
end
HYEL_SRED: begin// yellow on highway and red on farm way
  light_highway = 3'b010;
  light_SR = 3'b100;
  RED_count_en=0;
 YELLOW_count_en1=1;
 YELLOW_count_en2=0;
  if(delay3s1) next_state = HRED_SGRE;
  // yellow for 3s, then red
  else next_state = HYEL_SRED;
end
HRED_SGRE: begin// red on highway and green on farm way
 light_highway = 3'b100;
 light_SR = 3'b001;
 RED_count_en=1;
 YELLOW_count_en1=0;
 YELLOW_count_en2=0;
  if(delay10s) next_state = HRED_SYEL;
 // red in 10s then turn to yello -> green again for high way
 else next_state =HRED_SGRE;
end
HRED_SYEL:begin// red on highway and yellow on farm way
 light_highway = 3'b100;
 light_SR = 3'b010;
 RED_count_en=0;
 YELLOW_count_en1=0;
 YELLOW_count_en2=1;
  if(delay3s2) next_state = HGRE_SRED;
 // turn green for highway, red for farm road
 else next_state =HRED_SYEL;
end
default: next_state = HGRE_SRED;
endcase
end
// fpga4student.com FPGA projects, VHDL projects, Verilog projects
// create red and yellow delay counts
always @(posedge clk)
begin
if(clk_enable==1) begin
 if(RED_count_en||YELLOW_count_en1||YELLOW_count_en2)
  count_delay <=count_delay + 1;
  if((count_delay == 9)&&RED_count_en) 
  begin
   delay10s=1;
   delay3s1=0;
   delay3s2=0;
   count_delay<=0;
  end
  else if((count_delay == 2)&&YELLOW_count_en1) 
  begin
   delay10s=0;
   delay3s1=1;
   delay3s2=0;
   count_delay<=0;
  end
  else if((count_delay == 2)&&YELLOW_count_en2) 
  begin
   delay10s=0;
   delay3s1=0;
   delay3s2=1;
   count_delay<=0;
  end
  else
  begin
   delay10s=0;
   delay3s1=0;
   delay3s2=0;
  end 
 end
end
// create 1s clock enable 
always @(posedge clk)
begin
 count <=count + 1;
 //if(count == 50000000) // 50,000,000 for 50 MHz clock running on real FPGA
  if(count == 50000000) // for testbench
  count <= 0;
end
 assign clk_enable = count==3 ? 1: 0; // 50,000,000 for 50MHz running on FPGA
endmodule 
