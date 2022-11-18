module register_tb();
reg clk,resetn,pktvalid,fifofull,rstintreg,detectadd,ldstate,lafstate,fullstate,lfdstate;
reg [7:0]datain;
wire paritydone,lowpktvalid,error;
wire [7:0]dout;
register13 register(clk,resetn,pktvalid,fifofull,rstintreg,detectadd,ldstate,lafstate,fullstate,lfdstate,datain,paritydone,lowpktvalid,error,dout);
initial
begin
clk=0;
forever #10 clk=~clk;
end
initial
begin
detectadd=0;
forever #30 detectadd=~detectadd;
end
initial
begin
pktvalid=0;
forever #50 pktvalid=~pktvalid;
end
initial
begin
resetn=0;
#50;
resetn=1;
end
task input1(input a,b,d,e,f,g);
begin
fifofull=a;
rstintreg=b;
//detectadd=c;
ldstate=d;
lafstate=e;
fullstate=f;
lfdstate=g;
//pktvalid=h;
end
endtask
task input2(input [7:0]z);
datain=z;
endtask
initial
begin
input1(1,1,0,1,1,0);
#10;
input2(8'b10101010);
#10;
input1(1,0,1,1,0,1);
#10;
input2(8'b01010101);
#10;
input1(0,0,1,0,0,0);
#10;
input2(8'b11110000);
input1(0,0,1,0,0,0);
#50;
end
initial
$monitor("clk=%b,resetn=%b,pktvalid=%b,fifofull=%b,rstintreg=%b,detectadd=%b,ldstate=%b,lafstate=%b,fullstate=%b,lfdstate=%b,datain=%b,paritydone=%b,lowpktvalid=%b,error=%b,dout=%b"
            ,clk,resetn,pktvalid,fifofull,rstintreg,detectadd,ldstate,lafstate,fullstate,lfdstate,datain,paritydone,lowpktvalid,error,dout);
initial
#1000
$finish;
endmodule
