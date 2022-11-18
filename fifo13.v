module fifo13(input clk,resetn,wr_en,sreset_0,re_enb,lfd_state,
              input [7:0]d_in,
              output reg empty,full,
              output reg[7:0]d_out);
//internal registers
reg[3:0]read_poin;
reg[3:0]write_poin;
reg [4:0]fifo_counter;
reg[8:0]mem[15:0];
integer i;
//empty and full signals
always@(posedge clk)
begin
begin
empty=(fifo_counter==5'b0)?1'b1:1'b0;
full=(fifo_counter==5'b10000)?1'b1:1'b0;
end
//always@(posedge clk)
begin
if(!resetn || sreset_0)
begin
for(i=0;i<16;i=i+1)
mem[i]=0;
write_poin=4'b0;
read_poin=4'b0;
{d_out,empty,full,fifo_counter}=0;
end
end
//write operatiom
//always@(posedge clk)
begin
if(wr_en && (!re_enb) && (!full))
begin 
write_poin=write_poin+1'b1;
mem[write_poin]={lfd_state,d_in};
fifo_counter=fifo_counter+1'b1;
end
else
write_poin=write_poin;
end
//read operation
////always@(posedge clk)
begin
if(re_enb && (!wr_en) && (!empty))
begin
read_poin=read_poin+1'b1;
d_out=mem[read_poin];
fifo_counter=fifo_counter-1'b1;
end
else
read_poin=read_poin;
end
//write and read operaation
//always@(posedge clk)
begin
if((re_enb & (!empty)) && (wr_en & (!full)))
begin
read_poin=read_poin+1'b1;
write_poin=write_poin+1'b1;
mem[read_poin]=d_in;
d_out=mem[write_poin];
end
else
begin
read_poin=read_poin;
write_poin=write_poin;
end
end
//always@(posedge clk)
	begin
		
		 if(re_enb && (!empty))
			begin
				if(mem[read_poin[3:0]][8])                          
                                        fifo_counter<=mem[read_poin[3:0]][7:2]+1'b1;

				else if(fifo_counter!=6'd0)
					fifo_counter<=fifo_counter-1'b1;
				
			end
	
	end
	end
endmodule

