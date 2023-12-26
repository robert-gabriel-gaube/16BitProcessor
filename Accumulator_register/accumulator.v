module accumulator(
    input [15:0] ALU_rez,
    input reset, clk,
    input str_rez,
    output reg [15:0] out
);

    always @(posedge clk, posedge reset) begin
        #4
        if (reset) out <= 16'h0000;
	    else if (str_rez) out <= ALU_rez;
    end

endmodule
