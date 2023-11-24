module PCxIM;
    reg clk, reset, branch, stall, en_write;
    reg [9:0] br_address;
    reg [15:0] data_in;
    wire [9:0] instr_address;
    wire [15:0] data_out;

    localparam CLOCK_CYCLES = 20, CLOCK_PERIOD = 100;
    
    PC inst0(
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .stall(stall),
        .br_address(br_address),
        .instr_address(instr_address)
    );

    IM inst1(
        .clk(clk),
        .en_write(en_write),
        .address(instr_address),
        .data_in(data_in),
        .data_out(data_out)
    );

    initial begin 
        clk = 0;
        repeat(CLOCK_CYCLES * 2)
            #(CLOCK_PERIOD / 2) clk = ~clk;
    end

    initial begin 
        reset = 1'b1;
        #50 reset = 1'b0;
        #450 reset = 1'b1;
        #50 reset = 1'b0;
    end

    initial begin 
        br_address = 10'h000;
        branch = 1'b0;
        stall = 1'b0;
        en_write = 1'b1;
        #500 en_write = 1'b0;
    end

    initial begin 
        data_in = 16'h0011;
    end

endmodule