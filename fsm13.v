module fsm13( input clk,resetn,pktvalid,softreset0,softreset1,softreset2,
            input fifofull,fifoempty0,fifoempty1,fifoempty2,lowpktvalid,paritydone,
            input [1:0]data,
            output detectadd,ldstate,lafstate,fullstate,writeenreg,rstintreg,lfdstate,busy);
reg [2:0]state,nextstate;
parameter
dadress = 000,
lfirstdata   = 001,
waittillempty=010,
loaddata=011,
loadparity=100,
checkparity=101,
fifofullstate=110,
loadafterdata=111;
always@(posedge clk)
begin
if(!resetn)
state=dadress;
else
state=nextstate;
end
always@(*)
begin
case(state)
dadress : if ( pktvalid && (data[1:0]==2'b00 | data[1:0]==2'b01 | data[1:0]==2'b10) && (fifoempty0|fifoempty1|fifoempty2))
           nextstate <= lfirstdata;
          else if(pktvalid && (data[1:0]==2'b00 | data[1:0]==2'b01 |data[1:0]==2'b10) && ((!fifoempty0)|(!fifoempty1)|(!fifoempty2)))
           nextstate<=waittillempty;
           else
           nextstate<=dadress;
lfirstdata: nextstate<=loaddata;
waittillempty: if((fifoempty0) && (data[1:0]==2'b00) || (fifoempty1) && (data[1:0]==2'b00) || (fifoempty2) && (data[1:0]==2'b00))
              nextstate<=lfirstdata;
             else
              nextstate<=waittillempty;
loaddata: if((!fifofull) && (!pktvalid))
          nextstate<=loadparity;
           else if(fifofull)
           nextstate<=fifofullstate;
           else
           nextstate<=loaddata;
loadparity: nextstate<=checkparity;
checkparity: if (fifofull)
           nextstate<=fifofullstate;
           else
             nextstate<=dadress;
fifofullstate: if(!fifofull)
              nextstate<=loadafterdata;
              else
                nextstate<=fifofullstate;
loadafterdata: if((!paritydone) && (!lowpktvalid))
                 nextstate<=loaddata;
                 else if ((!paritydone) && (lowpktvalid))
                 nextstate<=loadparity;
                 else
                 nextstate<=dadress;
endcase
end
assign detectadd=(state==dadress)? 1'b1 :1'b0;
assign ldstate=(state==loaddata)?1'b1 : 1'b0;
assign lfdstate=(state==lfirstdata)?1'b1:1'b0;
assign lafstate=(state==loadafterdata)?1'b1:1'b0;
assign rstintreg=(state==checkparity)?1'b1:1'b0;
assign fullstate=(state==fifofullstate)?1'b1:1'b0;
assign writeenreg=((state==loaddata)||(state==loadparity)||(state==loadafterdata))?1'b1:1'b0;
assign rstintreg=((state==checkparity))?1'b1:1'b0;
assign busy = ((state==lfirstdata)||(state==loadparity)||(state==fifofullstate)||(state==loadafterdata)||(state==waittillempty)||(state==checkparity))?1'b1:1'b0;
endmodule













