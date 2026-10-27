module router_fsm(clk,resetn,busy,data_in,parity_done,pkt_valid,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lft_state);

input clk,resetn,pkt_valid,data_in,parity_done,soft_rst_0,soft_rst_1,soft_rst_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;

output busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lft_state;
input [1:0] data_in;

reg [1:0] addr;
reg [2:0] next_state,present_state;

parameter DECODE_ADDRESS 	= 3'b000,
		  LOAD_FIRST_DATA 	= 3'b001,
		  LOAD_DATA       	= 3'b010,
		  LOAD_PARITY	  	= 3'b011,
		  CHECK_PARITY_ERROR= 3'b100,
		  FIFO_FULL_STATE   = 3'b101,
		  LOAD_AFTER_FULL   = 3'b110,
		  WAIT_TILL_EMPTY	= 3'b111;

always@(posedge clk)
	begin
	
	     if(!resetn)
			begin
				addr <= 2'b11;
		    end
		
		else if(detect_add)
			 begin
				addr <= data_in[1:0];
			end 
	end
	//present_state logic
always@(posedge clk)
	begin
	
		if(!resetn || soft_rst_0 || soft_rst_1 || soft_rst_2) present_state <= DECODE_ADDRESS;
		else present_state <= next_state;
	end
	
//Next State Logic

always@(*)
	begin
		next_state = present_state;
		case(present_state)
				DECODE_ADDRESS : begin
									if( (pkt_valid && (data_in[1:0] == 0) && fifo_empty_0) ||
									    (pkt_valid && (data_in[1:0] == 1) && fifo_empty_1) ||
									    (pkt_valid && (data_in[1:0] == 2) && fifo_empty_2) ) 
									  next_state = LOAD_FIRST_DATA;
									
									else if((pkt_valid && (data_in[1:0] == 0) && !fifo_empty_0) ||
									       (pkt_valid && (data_in[1:0] == 1) && !fifo_empty_1) ||
									       (pkt_valid && (data_in[1:0] == 2) && !fifo_empty_2))
											next_state = WAIT_TILL_EMPTY;
								 end
				LOAD_FIRST_DATA : begin
									next_state = LOAD_DATA;
								  end
				LOAD_DATA		: begin
									if(fifo_full)next_state = FIFO_FULL_STATE;
									else if(!fifo_full && !pkt_valid)next_state = LOAD_PARITY;
								 end
				
				
				FIFO_FULL_STATE : begin
									if(!fifo_full)next_state = LOAD_AFTER_FULL;
								 end
				LOAD_AFTER_FULL	: begin
									if(!parity_done&& low_pkt_valid) next_state = LOAD_PARITY;
								    else if(parity_done) next_state = DECODE_ADDRESS;
									else if(!parity_done && !low_pkt_valid) next_state = LOAD_DATA;
								  end
				LOAD_PARITY		: begin
									next_state = CHECK_PARITY_ERROR;
								  end
			CHECK_PARITY_ERROR  : begin
									if(fifo_full)next_state = FIFO_FULL_STATE;
									else next_state = DECODE_ADDRESS;
								  end
				WAIT_TILL_EMPTY : begin
									if( (fifo_empty_0 && (addr == 2'b00)) ||
									    (fifo_empty_1 && (addr == 2'b01)) ||
									    (fifo_empty_2 && (addr == 2'b10)) )
									begin
										next_state = LOAD_FIRST_DATA;
									end
								  end
		endcase
	end
	//output logic
	assign detect_add = ((present_state == DECODE_ADDRESS));
	assign ld_state	  = ((present_state == LOAD_DATA));
	assign laf_state  = ((present_state == LOAD_AFTER_FULL));
	assign full_state = ((present_state == FIFO_FULL_STATE));
	assign lft_state  = ((present_state == LOAD_FIRST_DATA));
	assign busy		  = ((present_state == LOAD_FIRST_DATA) || (present_state == LOAD_PARITY) || (present_state == FIFO_FULL_STATE) || (present_state == LOAD_AFTER_FULL)||(present_state == WAIT_TILL_EMPTY)||
						(present_state == CHECK_PARITY_ERROR));
	
	assign write_enb_reg = ((present_state == LOAD_DATA) || (present_state == LOAD_PARITY) || (present_state == LOAD_AFTER_FULL));
	assign rst_int_reg   = ((present_state == CHECK_PARITY_ERROR));
	
	endmodule
									   
				
								  
				
									  
				
				
									
									
									
									
									
								 
				
									
									
									
									
	
		
			
		
		
		
		

