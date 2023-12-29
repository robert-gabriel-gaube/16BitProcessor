module accumulator(
    input [15:0] alu_out,
    input reset, clk,
    input str_rez,
    output reg [15:0] out
);

    always @(posedge clk, posedge reset) begin
        #4;
        if(reset)           out <= 16'h0000;
	    else if(str_rez)    out <= alu_out;
    end

endmodule
