module SP_tb;
    reg pop, push, reset, clk;
    wire [15:0] val, out;
    localparam CLOCK_CYCLES = 10, CLOCK_PERIOD = 20;

    SP SP_inst(
        .pop(pop),
        .push(push),
        .reset(reset),
        .new_val(val),
        .clk(clk),
        .out(out)
    );

    INC_DEC_SP INC_DEC_SP_inst(
        .pop(pop),
        .sp(out),
        .val(val)
    );

    initial begin 
        clk = 0;
        repeat(CLOCK_CYCLES * 2)
            #(CLOCK_PERIOD / 2) clk = ~clk;
    end

    initial begin
        push = 1;
        pop = 0;
        reset = 1;
        #20 

	reset = 0;
	pop = 1;
	push = 0;
        #20 

	push = 0;
        pop = 1;
        #20;
	push = 0;
        pop = 1;
	#20;
	push = 0;
        pop = 1;
	#20;

	push = 1;
        pop = 0;
        #20;
	push = 1;
        pop = 0;
        #20;
	push = 1;
        pop = 0;
	#20;
    end
endmodule
