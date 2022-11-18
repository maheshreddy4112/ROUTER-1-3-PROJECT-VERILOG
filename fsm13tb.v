module fsm13tb();
reg clk,resetn,pkt_valid,soft_reset_0,soft_reset_1,soft_reset_2;
reg fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,low_pkt_valid,parity_done;
reg [1:0]data_in;
wire detect_add,ld_state,laf_state,full_state,write_en_reg,rst_int_reg,lfd_state,busy;
fsm13 fsm1(clk,resetn,pkt_valid,soft_reset_0,soft_reset_1,soft_reset_2,
           fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,low_pkt_valid,parity_done,
          data_in,detect_add,ld_state,laf_state,full_state,write_en_reg,rst_int_reg,lfd_state,busy);
initial
begin
clk=0;
forever #10 clk=~clk;
end
task lowresetgen;
begin
resetn=0;
#50; resetn= 1;
end
endtask
task packetvalidgen(input z);
begin
pkt_valid=z;
end
endtask
task softresetgen( input a,b,c);
begin
soft_reset_0=a;
soft_reset_1=b;
soft_reset_2=c;
end
endtask
task fifofullgen(input d);
begin
fifo_full=d;
end
endtask
task fifoemptygen(input e,f,g);
begin
fifo_empty_0=e;
fifo_empty_1=f;
fifo_empty_2=g;
end
endtask
task lowpacketvalid;
begin
low_pkt_valid=1;
#70; low_pkt_valid=0;
end
endtask
task paritydonegen(input h);
begin
parity_done=h;
end
endtask
task datagen(input [1:0]g);
begin
data_in=g;
end
endtask
initial
begin
lowresetgen;
//packetvalidgen;
softresetgen(0,0,0);
fifofullgen(0);
fifoemptygen(1,1,1);
//lowpacketvalid;
//paritydonegen(1);
datagen(2'b01);
packetvalidgen(1);
softresetgen(0,0,0);
fifofullgen(0);
fifoemptygen(1,1,1);
//lowpacketvalid;
//paritydonegen(1);
//packetvalidgen;
softresetgen(0,0,0);
fifofullgen(1);
fifoemptygen(0,0,0);
//lowpacketvalid;
//paritydonegen(0);
end
initial
$monitor("clk=%b,resetn=%b,pkt_valid=%b,soft_reset_0=%b,soft_reset_1=%b,soft_reset_2=%b,fifo_full=%b,fifo_empty_0=%b,fifo_empty_1=%b,fifo_empty_2=%b,low_pkt_valid=%b,parity_done=%b,data_in=%b,detect_add=%b,ld_state=%b,laf_state=%b,full_state=%b,write_en_reg=%b,rst_int_reg=%b,lfd_state=%b",clk,resetn,pkt_valid,soft_reset_0,soft_reset_1,soft_reset_2,
           fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,low_pkt_valid,parity_done,
          data_in,detect_add,ld_state,laf_state,full_state,write_en_reg,rst_int_reg,lfd_state);
initial
#1000
$finish;
endmodule
