module router_fifo_tb;

reg clk;
reg resetn;
reg wr_enb;
reg rd_enb;
reg lft_state;
reg soft_rst;
reg [7:0] data;

wire [7:0] data_out;
wire empty;
wire full;

router_fifo DUT(
    .clk(clk),
    .resetn(resetn),
    .wr_enb(wr_enb),
    .soft_rst(soft_rst),
    .rd_enb(rd_enb),
    .data(data),
    .lft_state(lft_state),
    .empty(empty),
    .data_out(data_out),
    .full(full)
);

integer i;

initial
    clk = 0;

always #10 clk = ~clk;

// Initialization

task initialize;
begin
    wr_enb = 0;
    rd_enb = 0;
    lft_state = 0;
    soft_rst = 0;
    resetn = 1;
    data = 0;
end
endtask

// Reset

task reset_fifo;
begin
    @(negedge clk)
    resetn = 0;

    @(negedge clk)
    resetn = 1;
end
endtask

// Write Packet

task write_packet;

reg [7:0] header;
reg [7:0] payload;
reg [7:0] parity;

begin

    header = {6'd10,2'b01};

    wr_enb = 1;

    // Header

    @(negedge clk)
    begin
        lft_state = 1;
        data = header;
    end

    // Payload

    for(i=0;i<10;i=i+1)
    begin
        @(negedge clk)
        begin
            lft_state = 0;
            payload = $random;
            data = payload;
        end
    end

    // Parity

    @(negedge clk)
    begin
        parity = $random;
        data = parity;
    end

    @(negedge clk)
    begin
        wr_enb = 0;
        data = 0;
    end

end

endtask

// Read Packet

task read_packet;

begin

    @(negedge clk)
    rd_enb = 1;

    repeat(12)
        @(negedge clk);

    rd_enb = 0;

end

endtask

// Monitor

initial
begin
    $monitor("TIME=%0t WR=%b RD=%b DATA_IN=%h DATA_OUT=%h EMPTY=%b FULL=%b",
             $time,wr_enb,rd_enb,data,data_out,empty,full);
end

// Test Sequence

initial
begin

    initialize;

    reset_fifo;

    #20;

    write_packet;

    #40;

    read_packet;

    #100;

    $finish;

end

endmodule