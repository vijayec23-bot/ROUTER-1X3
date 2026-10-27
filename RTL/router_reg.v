module router_reg (clk,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,
full_state,lfd_state,parity_done,low_pkt_valid,error,dout);

input clk,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
input [7:0] data_in;
output reg parity_done,low_pkt_valid,error;
output reg [7:0] dout;

reg [7:0] header_byte;
reg [7:0]fifo_full_state;
reg [7:0]internal_parity;
reg [7:0]packet_parity_byte;

// parity_done
always@(posedge clk)
 begin
	if(!resetn) {dout,error,parity_done,low_pkt_valid} <= 0;
	if(!resetn || detect_add) parity_done <= 1'b0;
	else if((ld_state && !fifo_full && !pkt_valid) || (laf_state && low_pkt_valid && !parity_done))
		parity_done <= 1'b1;
 end
 
 always@(posedge clk)
  begin
	  if(detect_add && pkt_valid && (data_in[1:0]!=3))
		header_byte <= data_in;
  end
  
  
  //op
 always@(posedge clk)
  begin
    if(lfd_state && pkt_valid)
		dout <= header_byte;
  end
  
 always@(posedge clk)
  begin
	if(ld_state && !fifo_full)
		dout <=data_in;
   
    else if(ld_state && fifo_full)
		fifo_full_state <= data_in;
  end
  
 always@(posedge clk)
   begin
	  if(!fifo_full && laf_state)
	     dout <= fifo_full_state;
   end
  

	
always @(posedge clk)
			begin
				if(!resetn || detect_add || (!pkt_valid && rst_int_reg)) low_pkt_valid <= 1'b0; 
				else if(ld_state && !pkt_valid) low_pkt_valid <= 1'b1;
			end 
	
always@(posedge clk)
    begin
	    if(detect_add && pkt_valid)
			internal_parity <= data_in;
	end

always@(posedge clk)
	begin
		if(!resetn || (!pkt_valid && rst_int_reg)) internal_parity <= 8'b00;
		else if(ld_state && !fifo_full && pkt_valid)
			internal_parity <= internal_parity^data_in;
	end
	// error logic
always @(posedge clk)
			begin 
				if(parity_done && (packet_parity_byte != internal_parity)) error <= 1'b1;
				else error <= 1'b0;
			end 
	
endmodule
		
	
		
	

			
		
	  