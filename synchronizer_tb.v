module synchronizer_tb();
reg [1:0]data_in; 
reg clk,resetn,detect_add,wr_en_reg,ren0,ren1,ren2,full0,full1,full2,empty0,empty1,empty2;
wire validout_0,validout_1,validout_2;
wire sreset_0,sreset_1,sreset_2;
wire fifo_full;
wire[2:0]write_enb;
syn13 synchronizer(data_in,clk,resetn,detect_add,wr_en_reg,ren0,ren1,ren2,full0,full1,full2,empty0,empty1,empty2,validout_0,validout_1,validout_2,
             sreset_0,sreset_1,sreset_2,fifo_full,write_enb);
initial
begin
clk=0;
forever #10 clk=~clk;
end
initial
begin
resetn=0;     #50;
resetn=1;
end
task datagen(input[1:0]z);
begin
data_in=z;
end
endtask
task task1(input a,b);
begin
detect_add=a;
wr_en_reg=b;
end
endtask
task task2(input r0,r1,r2,f0,f1,f2,e0,e1,e2);
begin
ren0=r0;
ren1=r1;
ren2=r2;
full0=f0;
full1=f1;
full2=f2;
empty0=e0;
empty1=e1;
empty2=e2;
end
endtask
initial
begin
#30;
task1(0,1);
task2(1,0,0,1,0,0,1,0,0);
#20;
datagen(2'b00);  task1(1,1); #20; task2(1,0,0,1,0,0,1,0,0);
#50;
datagen(2'b01);  task1(0,1); #20; task2(1,0,0,1,0,0,1,0,0);
datagen(2'b10);  task1(1,1); #20; task2(1,0,0,1,0,1,0,0,1);
datagen(2'b11);  task1(1,1); #20; task2(0,1,0,0,1,0,0,1,1);
datagen(2'b10);  task1(1,1); #20; task2(0,0,1,0,0,1,0,0,0);
end
initial
$monitor("data_in=%b,clk=%b,resetn=%b,detect_add=%b,wr_en_reg=%b,ren0=%b,ren1=%b,ren2=%b,full0=%b,full1=%b,full2=%b,empty0=%b,empty1=%b,empty2=%b,validout_0=%b,validout_1=%b,validout_2=%b,sreset_0=%b,,sreset_1=%b,sreset_2=%b,fifo_full=%b,write_enb=%b"
                   ,data_in,clk,resetn,detect_add,wr_en_reg,ren0,ren1,ren2,full0,full1,full2,empty0,empty1,empty2,validout_0,validout_1,validout_2,
             sreset_0,sreset_1,sreset_2,fifo_full,write_enb);
initial
#3000
$finish;
endmodule 