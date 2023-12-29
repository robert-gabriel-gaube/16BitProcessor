module accumulator_tb;

    reg [15:0] ALU_rez;
    reg reset, str_rez;
    wire [15:0] out;

    accumulator dut(
        .ALU_rez(ALU_rez),
        .reset(reset),
        .str_rez(str_rez),
        .out(out)
    );

    initial begin
	ALU_rez = 16'hFFFF;
        reset = 0;
        str_rez = 1;
        #10;
        str_rez = 0;
        #10;

	ALU_rez = 16'hFF01;
        reset = 0;
        str_rez = 0;
        #10;
        reset = 0;
        #10;

	ALU_rez = 16'h0FFF;
        reset = 1;
        str_rez = 1;
        #10;
        str_rez = 0;
        #10;

        ALU_rez = 16'h0123;
        reset = 1;
        str_rez = 0;
        #10;
        str_rez = 0;
        #10;
    end

endmodule