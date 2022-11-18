module router13(input clk,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,
              input [7:0]data_in,
              output [7:0]data_out_0,data_out_1,data_out_2,
              output vld_out_0,vld_out_1,vld_out_2,error,busy);
wire [2:0]write_enb;
reg [1:0]datain;
wire detect_add,wr_en_reg,full0,full1,full2,empty0,empty1,empty2,soft_reset_0,
         soft_reset_1,soft_reset_2,fifo_full;
wire low_pkt_valid,parity_done,ld_state,laf_state,full_state,rst_int_reg,lfd_state;
wire [7:0]d_in;
always@(lfd_state)
begin
datain={data_in[1],data_in[0]};
end
syn13 synchronizer(datain,clk,resetn,detect_add,wr_en_reg,read_enb_0,read_enb_1,read_enb_2,full0,full1,full2,empty0,empty1,empty2,vld_out_0,vld_out_1,vld_out_2,
             soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,write_enb);
fsm13 fsm1(clk,resetn,pkt_valid,soft_reset_0,soft_reset_1,soft_reset_2,
           fifo_full,empty0,empty1,empty2,low_pkt_valid,parity_done,
          datain,detect_add,ld_state,laf_state,full_state,wr_en_reg,rst_int_reg,lfd_state,busy);
fifo13 fifo1(clk,resetn,write_enb[0],soft_reset_0,read_enb_0,lfd_state,
        d_in,empty0,full0,data_out_0);
fifo13 fifo2(clk,resetn,write_enb[1],soft_reset_1,read_enb_1,lfd_state,
        d_in,empty1,full1,data_out_1);
fifo13 fifo3(clk,resetn,write_enb[2],soft_reset_2,read_enb_2,lfd_state,
        d_in,empty2,full2,data_out_2);
register13 register(clk,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,data_in,parity_done,low_pkt_valid,error,d_in);

endmodule
