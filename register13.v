module register13(input clk,resetn,pktvalid,fifofull,rstintreg,detectadd,ldstate,lafstate,fullstate,lfdstate,
                  input [7:0]datain,
                  output reg paritydone,lowpktvalid,error,
                  output reg [7:0]dout);
reg [7:0]temp,temp2,intparity,packetparity;
//parity done
always@(posedge clk)
begin
if (!resetn)
begin
dout=0;
error=0;
paritydone=0;
lowpktvalid=0;
end
else
begin 
if(ldstate && ((!fifofull) & (!pktvalid)))
paritydone=1'b1;
else if(lafstate && lowpktvalid && !paritydone)
paritydone=1'b1;
else
   if(detectadd)
paritydone=1'b0;
   else
paritydone=1'b0;
end

//pktvalid
//always@(posedge clk)
begin
if(!resetn)
  lowpktvalid=1'b0;
else
   begin
    if(rstintreg)
         lowpktvalid=1'b0;
     else if((ldstate==1'b1) && (pktvalid==1'b0))
         lowpktvalid=1'b1;
end
end
//dout
//always@(posedge clk)
begin
if (!resetn)
dout<=8'b0;
else
begin 
  if(detectadd && pktvalid)
    temp=datain;
   else if (lfdstate)
     dout=temp;
    else if (ldstate &&(!fifofull))
     dout=datain;
     else if (ldstate && fifofull)
     temp2=datain;
    else if (lafstate)
     dout=temp2;
    end
end
//internalparity
//always@(posedge clk)
begin
  if(!resetn)
    intparity=8'b0;
  else 
  begin
  intparity=intparity^temp;
  intparity=intparity^((ldstate && pktvalid)?datain:temp2);
  end
end
//packet parity
//always@(posedge clk)
begin 
if (!resetn)
 packetparity=8'b0;
else if((!pktvalid) && (ldstate))
packetparity=datain;
end
//error
//always@(posedge clk)
begin
if(!resetn)
intparity=0;
else
if(packetparity!=intparity)
error=1'b1;
else
error=1'b0;
end
end
endmodule
