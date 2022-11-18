module fifo13tb();
reg clk,resetn,wr_en,sreset_0,re_enb,lfd_state;
reg [7:0]d_in;
wire empty,full;
wire[7:0]d_out;
fifo13 DUT(clk,resetn,wr_en,sreset_0,re_enb,lfd_state,
        d_in,empty,full,d_out);
initial
begin
clk=0;
forever #10 clk=~clk;
end
initial
begin
resetn=0;
#50;
resetn=1;
sreset_0=1;
#50;
sreset_0=0;
end
task writereadgen(input a,b,c);
begin
wr_en=a;
re_enb=b;
lfd_state=c;
#10;
end
endtask
task datagen(input[7:0]d);
begin
d_in=d;
end
endtask
initial
begin
writereadgen(1,0,0);#50;
datagen(10101010);#50;
writereadgen(1,0,1);#50;
datagen(01010101);#50;
writereadgen(0,1,0);#50;
datagen(11001100);#50;
writereadgen(0,1,1);#50;
datagen(00110011); #50;
writereadgen(1,1,0); #50;
datagen(11110000); #50;
writereadgen(1,1,1); #50;
datagen(11110011); #50;
end
initial
$monitor("clk=%b,resetn=%b,wr_en=%b,sreset_0=%b,re_enb=%b,lfd_state=%b,d_in=%b,empty=%b,full=%b,d_out=%b"
           ,clk,resetn,wr_en,sreset_0,re_enb,lfd_state,
        d_in,empty,full,d_out);
initial
#1000
$finish;
endmodule

