module register_tb;
    reg clk, en;
    reg [15:0] D;
    wire [15:0] Q;
    localparam CLOCK_CYCLES = 10, CLOCK_PERIOD = 100;

    register inst(
        .en(en),
        .clk(clk),
        .D(D),
        .Q(Q)
    );

    initial begin 
        clk = 0;
        repeat(CLOCK_CYCLES * 2)
            #(CLOCK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        en = 0;
        #500 en = 1;
        #200 en = 0;
        #100 en = 1;
    end

    initial begin 
        D = 16'h0000;
        #200 D = 16'h0013; // 19
        #200 D = 16'h0031; // 49
        #500 D = 16'h0001; // 1
    end

endmodule 