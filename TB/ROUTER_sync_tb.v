module router_sync_tb;
reg detect_add, clk, wr_enb_reg, resetn,rd_enb_0, rd_enb_1, rd_enb_2,empty_0, empty_1, empty_2,full_0, full_1, full_2;

reg [1:0] data_in;

wire fifo_full,soft_rst_0, soft_rst_1, soft_rst_2,vld_out_0, vld_out_1, vld_out_2;

wire [2:0] wr_enb;

router_sync DUT(detect_add,data_in,wr_enb,clk,resetn,vld_out_0,vld_out_1,vld_out_2,rd_enb_0,rd_enb_1,rd_enb_2,
fifo_full,empty_0,empty_1,empty_2,soft_rst_0,soft_rst_1,soft_rst_2,full_0,full_1,full_2,wr_enb_reg);
    
	
task initialize;
 begin 
    
	  {detect_add, resetn,rd_enb_0, rd_enb_1, rd_enb_2,empty_0, empty_1, empty_2,full_0, full_1, full_2,wr_enb_reg} = 0;
	  data_in = 2'b00;
	  @(negedge clk)resetn = 0;
	  @(negedge clk)resetn = 1;

	end
endtask 
     initial 
	   begin 
	       clk = 1'b0;
	end 
	  always #5 clk = ~clk ;
	
task detect;
   input det_add;
   input [1:0] d_in;
   begin
        @(negedge clk)
		detect_add = det_add;
	   data_in  = d_in;
	 end
	endtask
	
task write ;

input write_enable;
	begin
	    @(negedge clk)
	     wr_enb_reg = write_enable;
	end
endtask

task read;
input a,b,c;
	begin
	    @(negedge clk)
		
		rd_enb_0 = a;
		rd_enb_1 = b;
		rd_enb_2 = c;
	end
endtask

task empty;
	input d,e,f;
		begin
		   @(negedge clk)
			
			empty_0 = d;
			empty_1 = e;
			empty_2 = f;
		end
	endtask
	
task full_det;
	input f0,f1,f2;
	
	begin
	@(negedge clk)
		full_0 = f0;
		full_1 = f1;
		full_2 = f2;
	end
endtask

initial
	begin
	initialize;

	    detect(1'b1,2'b10);
		detect (1'b0,2'b10);
		write(1);
		read(1,0,1);
		empty(1'b0,1'b0,1'b1);
		full_det(1'b0,1'b0,1'b1);
		#500
		$finish;

		
	end
endmodule
		
	
			
			
	   

	   
	   

      
	 