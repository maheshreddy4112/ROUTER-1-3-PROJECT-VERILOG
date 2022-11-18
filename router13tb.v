module router13tb();
reg clk,resetn,pkt_valid,read_enb_0,read_enb_1,read_enb_2;
reg [7:0]data_in;
wire [7:0]data_out_0,data_out_1,data_out_2;
wire vld_out_0,vld_out_1,vld_out_2,error,busy;
router13 DUT(clk,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in,data_out_0,data_out_1,data_out_2,vld_out_0,vld_out_1,vld_out_2,error,busy);
integer i,j;
parameter Tp = 20;
//clock generation
always
    begin
	   clk = 1'b0;
	   #(Tp/2) clk=1'b1;
	   #(Tp/2);
	end
//resetn task
task rstn;
    begin
	    @(negedge clk)
		resetn = 1'b0;
		@(negedge clk)
		resetn = 1'b1;
	end
endtask
task initialize;
    begin
        {read_enb_0,read_enb_1,read_enb_2,pkt_valid,data_in}=0;
         resetn = 0;
    end
endtask
task pkt_gen_14;
reg [7:0]payload_data,parity,header;
reg [5:0]payload_len;
reg [1:0]addr;
    begin
	    @(negedge clk);
		wait(~busy)
		@(negedge clk);
		payload_len = 6'd14;
		addr = 2'b00;
		header = {payload_len,addr};
		parity = 0;
		data_in = header;
		pkt_valid = 1;
		parity = parity ^ header;
		@(negedge clk);
		wait(~busy)
		for(i=0;i<payload_len;i=i+1)
		begin
		  @(negedge clk);
		   wait(~busy)
		   payload_data = {$random}%256;
		   data_in = payload_data;
		   parity = parity ^data_in;
	    end
		@(negedge clk)
		wait(~busy)
		pkt_valid = 0;
		data_in = parity;
	end
endtask	
task pkt_gen_16;
reg [7:0]payload_data,parity,header;
reg [5:0]payload_len;
reg [1:0]addr;
    begin
	  @(negedge clk);
      wait(~busy)  
      @(negedge clk);
	  payload_len = 6'd16;
	  addr = 2'b01;
	  header = {payload_len,addr};
	  parity = 0;
	  data_in = header;
	  pkt_valid = 1;
	  parity = parity ^ header;
	  @(negedge clk);
	  wait(~busy)
	  for(j=0;j<payload_len;j=j+1)
	  begin
	    @(negedge clk)
		wait(~busy)
		payload_data = {$random}%256;
		data_in = payload_data;
		parity = parity ^data_in;
	  end
	  @(negedge clk)
      wait(~busy)
	  pkt_valid = 0;
	  data_in = parity;
	end
endtask
initial
    begin
	    initialize;
		rstn;
		#20;
		pkt_gen_14;
		repeat(2)
		@(negedge clk);
		read_enb_0 = 1'b1;
		#450;
		initialize;
		rstn;
		#20;
		pkt_gen_16;
		repeat(2)
		@(negedge clk);
		read_enb_1 = 1'b1;
    end
initial
    #2000 $finish;
endmodule
