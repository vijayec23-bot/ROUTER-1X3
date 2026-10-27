module router_reg_tb;
reg clk,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
reg [7:0] data_in;
integer i;

wire parity_done,low_pkt_valid,error;
wire [7:0] dout;

router_reg DUT(clk,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,
full_state,lfd_state,parity_done,low_pkt_valid,error,dout);

task initialize;
 begin
	{clk,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state} = 0;
	resetn =1'b1;
	@(negedge clk)resetn = 1'b0;
	@(negedge clk)resetn = 1'b1;
 end
endtask
 initial
	begin
		forever #5 clk =~clk;
	end

task T1;
 
	reg [7:0] header_byte,payload,parity;
	reg [5:0] payload_len;
    begin
	@(negedge clk)
		detect_add =1;
		pkt_valid =1;
		parity =0;
		payload =6;
		header_byte = {payload_len,2'b01};
		data_in = header_byte;
		parity = parity^data_in;
	
	
	
	@(negedge clk)
		lfd_state =1;
		detect_add =0;
	
	@(negedge clk)
		lfd_state =0;
		ld_state  =1;
	
	for(i=0;i< payload_len; i=i+1)
	begin
		@(negedge clk)
			fifo_full =0;
			payload = {$random} % 256;
			data_in = payload;
			parity = parity^data_in;
	end
	
	@(negedge clk)
		rst_int_reg = 1;
		rst_int_reg = 0;
		resetn = 0;
		
	@(negedge clk)
		pkt_valid= 0;
		data_in=parity ;
	
 end
endtask

	task T2;
		
			reg [7:0] header_byte,payload,parity;
			reg [5:0] payload_len;
			begin
			@(negedge clk)
				detect_add =1;
				pkt_valid =1;
				parity =0;
				payload =6;
				payload_len = 10;
				header_byte = {payload_len,2'b01};
				data_in = header_byte;
				parity = parity^data_in;
	
			
	
			@(negedge clk)
				lfd_state =1;
				detect_add =0;
	
			@(negedge clk)
				lfd_state =0;
				ld_state  =1;
	
			for(i=0;i< payload_len; i=i+1)
				begin
				@(negedge clk)
					fifo_full =0;
					payload = {$random} % 256;
					data_in = payload;
					parity = parity^data_in;
				end
				
				@(negedge clk)
				pkt_valid= 0;
				data_in = parity+5;
				

	
				@(negedge clk)
					rst_int_reg = 1;
					rst_int_reg = 0;
			
					resetn = 0;
				end
				
			endtask

	initial
		begin
			initialize;
			T2;
			$finish;
			#50;
		end

endmodule
			
			
		
		
		
	
