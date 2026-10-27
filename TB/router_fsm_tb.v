  //FSM TESTBENCH 
  //ROUTER 1*3




module router_fsm_tb ;
reg clk,resetn,pkt_valid,parity_done,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
reg [1:0]data_in;

wire busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lft_state;


router_fsm DUT(clk,resetn,busy,data_in,parity_done,pkt_valid,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lft_state);

//module router_fsm(clk,resetn,busy,data_in,parity_done,pkt_valid,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lft_state);

task Initialization;
 begin
	{clk,pkt_valid,data_in,parity_done,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2} = 0;
	resetn = 1'b1;
	@(negedge clk) resetn = 1'b0;
	@(negedge clk) resetn = 1'b1;
 end
endtask


initial
	begin
	    forever #5 clk = ~clk;
	end

task T1;
 begin
    @(negedge clk)
		pkt_valid = 1'b1;
		data_in   = 2'b00;
		fifo_empty_0 = 1'b1;
	@(negedge clk)
	@(negedge clk)
		fifo_full = 1'b0;
		pkt_valid = 1'b0;
	@(negedge clk)
		fifo_full = 1'b0;
 end
endtask


task T2;
 begin
	@(negedge clk)
		pkt_valid = 1'b1;
		data_in   = 2'b01;
		fifo_empty_1 = 1;
	@(negedge clk)
	@(negedge clk)
		fifo_full =1'b1;
	@(negedge clk)
		fifo_full =1'b0;
	@(negedge clk)
		parity_done =1'b0;
		low_pkt_valid =1'b1;
	@(negedge clk)
	@(negedge clk)
		fifo_full =1'b0;
 end
endtask

 
task T3;
 begin
	@(negedge clk)
		pkt_valid = 1'b1;
		data_in   = 2'b10;
		fifo_empty_2 = 1;
    @(negedge clk)
    @(negedge clk)
		fifo_full =1'b1;
	@(negedge clk)
		fifo_full=1'b0;
	@(negedge clk)
		parity_done =1'b0;
		low_pkt_valid=1'b0;
	@(negedge clk)
		fifo_full =1'b0;
		pkt_valid =1'b0;
	@(negedge clk)
	@(negedge clk)
		fifo_full =1'b0;
 end
endtask

task t4;
 begin
	@(negedge clk)
		pkt_valid = 1'b1;
		data_in   = 2'b10;
		fifo_empty_2 = 1;
    @(negedge clk)
    @(negedge clk)
		fifo_full =1'b0;
		pkt_valid =1'b0;
	@(negedge clk)
	@(negedge clk)
		fifo_full =1'b1;
	@(negedge clk)
		fifo_full =1'b0;
	@(negedge clk)
		parity_done=1'b1;
 end
endtask

initial
	begin
		Initialization;
		T3; //T1 o T2 or T3 or T4
		#20
		$finish;
	end
endmodule
	
	
	
	
	
	
  
	 
	
