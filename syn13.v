module syn13(input [1:0]data_in, 
             input clk,resetn,detect_add,wr_en_reg,ren0,ren1,ren2,full0,full1,full2,empty0,empty1,empty2,
             output  validout_0,validout_1,validout_2,
             output reg sreset_0,sreset_1,sreset_2,
             output reg fifo_full,
             output  reg[2:0]write_enb);
integer readcount0;
integer readcount1;
integer readcount2;
assign validout_0=~empty0;
assign validout_1=~empty1;
assign validout_2=~empty2;
//reset
always@(posedge clk)
begin
if((!resetn) )
begin
//write_enb = 3'b0;
{write_enb,sreset_0,sreset_1,sreset_2,fifo_full}=0;
end

//fifofull
begin
case(data_in)
2'b00 : fifo_full=full0;
2'b01 : fifo_full=full1;
2'b10 :  fifo_full=full2;
default :  fifo_full=2'bz;
endcase
end

//detect address
begin
if((detect_add) ||(wr_en_reg))
begin
case(data_in)
00 :  write_enb=3'b001;
01 :  write_enb=3'b010;
10 :  write_enb=3'b100;
11 :  write_enb=3'b000;
endcase
end
end
//validout

//soft reset generation
//if clkcount is more than 30 from readenable and validout
//always@(posedge clk)
begin
if(~validout_0)
	begin
	readcount0 = 0;
	sreset_0= 0;
	end
else if(ren0)
    begin
 readcount0 = 0;
	sreset_0= 0;
    end
else if (~ren0)
 if(readcount0==30)
   begin
   sreset_0=1;
  readcount0=0;
   end
  else
  begin
  readcount0=readcount0+1;
  sreset_0=0;
  end
else
sreset_0=0;
end
//soft reset 1
//always@(posedge clk)
begin
if(~validout_1)
	begin
	readcount1 = 0;
	sreset_1= 0;
	end
else if(ren0)
    begin
 readcount1 = 0;
	sreset_1= 0;
    end
else if (~ren1)
 if(readcount1==30)
   begin
   sreset_1=1;
   readcount1=0;
   end
  else
  begin
  readcount1=readcount1+1;
  sreset_1=0;
  end
else
sreset_1=0;
end
//softreset 2
//always@(posedge clk)
begin
if(~validout_2)
	begin
	readcount2 = 0;
	sreset_2= 0;
	end
  if(ren2)
    begin
 readcount2 = 0;
	sreset_2= 0;
    end
else if (~ren2)
 if(readcount2==30)
   begin
   sreset_2=1;
   readcount2=0;
   end
  else
  begin
  readcount2=readcount2+1;
  sreset_2=0;
  end
else
sreset_2=0;
end
end
endmodule

