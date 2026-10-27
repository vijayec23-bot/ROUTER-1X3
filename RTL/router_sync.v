module router_sync(detect_add,data_in,wr_enb,clk,resetn,vld_out_0,vld_out_1,vld_out_2,rd_enb_0,rd_enb_1,rd_enb_2,
fifo_full,empty_0,empty_1,empty_2,soft_rst_0,soft_rst_1,soft_rst_2,full_0,full_1,full_2,wr_enb_reg);
    

input detect_add, clk, resetn,wr_enb_reg;
input rd_enb_0, rd_enb_1, rd_enb_2;
input empty_0, empty_1, empty_2;
input full_0, full_1, full_2;
input [1:0] data_in;

reg [1:0] temp;

output reg [2:0] wr_enb;
output reg fifo_full;
output reg soft_rst_0, soft_rst_1, soft_rst_2;
output vld_out_0, vld_out_1, vld_out_2;

reg [4:0] count_0, count_1, count_2;


// Address Capture


always @(posedge clk)
begin
    if(!resetn)
        temp <= 2'b11;
    else if(detect_add)
        temp <= data_in;
end


// Write Enable Generation


always @(*)
begin

	if(wr_enb_reg)
	begin
    case(temp)
        2'b00 : wr_enb = 3'b001;
        2'b01 : wr_enb = 3'b010;
        2'b10 : wr_enb = 3'b100;
        default : wr_enb = 3'b000;
    endcase
	end
end


// Valid Output Generation


assign vld_out_0 = ~empty_0;      
assign vld_out_1 = ~empty_1;
assign vld_out_2 = ~empty_2;


// FIFO Full Generation



always @(*)
begin
    case(temp)
        2'b00 : fifo_full = full_0;
        2'b01 : fifo_full = full_1;
        2'b10 : fifo_full = full_2;
        default : fifo_full = 1'b0;
    endcase
end


// Soft Reset FIFO0


always @(posedge clk)
begin
    if(!resetn)
    begin
        count_0 <= 5'd0;
        soft_rst_0 <= 1'b0;
    end

    else if(rd_enb_0)
    begin
        count_0 <= 5'd0;
        soft_rst_0 <= 1'b0;
    end

    else if(vld_out_0)
    begin
        if(count_0 == 5'd29)
        begin
            soft_rst_0 <= 1'b1;
            count_0 <= 5'd0;
        end
        else
        begin
            count_0 <= count_0 + 1'b1;
            soft_rst_0 <= 1'b0;
        end
    end

    else
    begin
        count_0 <= 5'd0;
        soft_rst_0 <= 1'b0;
    end
end


// Soft Reset FIFO1

always @(posedge clk)
begin
    if(!resetn)
    begin
        count_1 <= 5'd0;
        soft_rst_1 <= 1'b0;
    end

    else if(rd_enb_1)
    begin
        count_1 <= 5'd0;
        soft_rst_1 <= 1'b0;
    end

    else if(vld_out_1)
    begin
        if(count_1 == 5'd29)
        begin
            soft_rst_1 <= 1'b1;
            count_1 <= 5'd0;
        end
        else
        begin
            count_1 <= count_1 + 1'b1;
            soft_rst_1 <= 1'b0;
        end
    end

    else
    begin
        count_1 <= 5'd0;
        soft_rst_1 <= 1'b0;
    end
end



always @(posedge clk)
begin
    if(!resetn)
    begin
        count_2 <= 5'd0;
        soft_rst_2 <= 1'b0;
    end

    else if(rd_enb_2)
    begin
        count_2 <= 5'd0;
        soft_rst_2 <= 1'b0;
    end

    else if(vld_out_2)
    begin
        if(count_2 == 5'd29)
        begin
            soft_rst_2 <= 1'b1;
            count_2 <= 5'd0;
        end
        else
        begin
            count_2 <= count_2 + 1'b1;
            soft_rst_2 <= 1'b0;
        end
    end

    else
    begin
        count_2 <= 5'd0;
        soft_rst_2 <= 1'b0;
    end
end

endmodule