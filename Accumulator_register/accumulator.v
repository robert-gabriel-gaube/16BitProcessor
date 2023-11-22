module accumulator(
    input [15:0] ALU_rez,
    input reset,
    input str_rez,
    output reg [15:0] out
);

    always @(*) begin
        if (reset) begin
            out = 16'h0000;
        end 
	else begin
            if (str_rez) begin
                out = ALU_rez;
            end
        end
    end

endmodule
