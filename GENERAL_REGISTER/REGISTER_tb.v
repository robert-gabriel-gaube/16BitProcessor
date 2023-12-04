module REGISTER_X_tb;
    reg reset;
    reg clk;
    reg acc_op;
    reg load;
    reg [15:0]acc_val;
    reg [15:0]data_val;
    wire [15:0]out;

    REGISTER_X inst(
        .reset(reset),
        .clk(clk),
        .acc_op(acc_op),
        .load(load),
        .acc_val(acc_val),
        .data_val(data_val),
        .out(out)
    );

    localparam CLOCK_CYCLES = 10, CLOCK_PERIOD = 100;

    initial
    begin 
    clk = 0;
    repeat(CLOCK_CYCLES * 2)
        #(CLOCK_PERIOD / 2) clk = ~clk;
    end

    initial 
    begin
        reset = 0;
        #25;
    end

    initial
    begin
        // out = 0
        reset = 1;
        acc_op = 1;
        acc_val = 16'h0002; 
        load = 0;
        data_val = 16'h0001;
        #200;

        // out = acc_val
        reset = 0;
        acc_op = 1;
        acc_val = 16'h0002;
        load = 0;
        data_val = 16'h0001;
        #200;

        // out = data_val
        reset = 0;
        acc_op = 0;
        acc_val = 16'h0002;
        load = 1;
        data_val = 16'h0001;
        #200;
        
        //out = 0
        reset = 1;
    end

endmodule