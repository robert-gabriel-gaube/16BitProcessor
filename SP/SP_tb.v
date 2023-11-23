module SP_tb;
    reg pop;
    reg push;
    reg reset;
    wire [15:0] out;

    SP sp(
        .pop(pop),
        .push(push),
        .reset(reset),
        .out(out)
    );

    initial begin
        reset = 1;
        pop = 0;
        push = 0;

	#10
	reset = 0;

        #10;
        pop = 1;
	#10;
        pop = 0;
	#10;
        pop = 1;
	#10;
        pop = 0;
	#10;
        pop = 1;


	#10;
	reset = 0;

        #10;
        pop = 1;
	#10;
        pop = 0;
	#10;
        pop = 1;
	#10;
        pop = 0;

	#10
        push = 1;
        #10;
        push = 0;

	#10;
        reset = 1;

	#10
        push = 1;
        #10;
        push = 0;
    end

endmodule
