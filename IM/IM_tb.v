module IM_tb;
    reg clk;
    reg en_write;
    reg [9:0] address;
    reg [15:0] data_in;
    wire [15:0] data_out;

    IM inst(
        .clk(clk),
        .en_write(en_write),
        .address(address),
        .data_in(data_in),
        .data_out(data_out)
    );

    localparam CLOCK_CYCLES = 10, CLOCK_PERIOD = 100;

    initial begin 
        clk = 0;
        repeat(CLOCK_CYCLES * 2)
            #(CLOCK_PERIOD / 2) clk = ~clk;
    end

    initial begin 
        en_write = 1;
        #500 en_write = 0;
    end

    initial begin 
        data_in = 16'h0001;
        #100 data_in = 16'h0011;
        #100 data_in = 16'h0111;
        #100 data_in = 16'h1111;
        #100 data_in = 16'h4444;
    end

    initial begin 
        address = 0;
        #100 address = 1;
        #100 address = 2;
        #100 address = 3;
        #100 address = 10'hFFF;

        #100 address = 0;
        #100 address = 1;
        #100 address = 2;
        #100 address = 10'hFFF;
    end
endmodule