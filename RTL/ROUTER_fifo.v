module router_fifo(
    input clk,
    input resetn,
    input wr_enb,
    input soft_rst,
    input rd_enb,
    input lft_state,
    input [7:0] data,

    output reg [7:0] data_out,
    output reg empty,
    output reg full
);

reg [8:0] mem [15:0];
reg [4:0] w_ptr, r_ptr;
reg [7:0] count;

integer i;

// Reset
always @(posedge clk)
begin
    if(!resetn)
    begin
        for(i=0;i<16;i=i+1)
		begin
            mem[i] <= 9'b0;
		end

        w_ptr   <= 5'd0;
        r_ptr   <= 5'd0;
        count   <= 8'd0;
        data_out<= 8'd0;
    end

    else
    begin

        // Write
        if(wr_enb && !full)
        begin
            mem[w_ptr[3:0]] <= {lft_state,data};
            w_ptr <= w_ptr + 1'b1;
        end

        // Read
        if(rd_enb && !empty)
        begin
            data_out <= mem[r_ptr[3:0]][7:0];
            r_ptr <= r_ptr + 1'b1;
        end

        // Count for packet length
        if(mem[r_ptr[3:0]][8] && rd_enb)
		begin
            count <= mem[r_ptr[3:0]][7:2] + 1;
		end

        else if(rd_enb && count != 0)
		begin
            count <= count - 1'b1;
		end
		else if(soft_rst || !count)
		begin
		     data_out <= 8'dz;
		end

    end
end

// Empty and Full logic

always @(*)
begin
    empty = (w_ptr == r_ptr);

    full = ((w_ptr[3:0] == r_ptr[3:0]) &&
            (w_ptr[4] != r_ptr[4]));
end

endmodule