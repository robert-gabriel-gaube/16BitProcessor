module INC_DEC_SP(
    input wire pop,
    input wire [15:0] sp,
    output reg [15:0] val
);

    always @(*) begin
        if (pop == 1) begin
            val = sp + 1;
        end else begin
            val = sp - 1;
        end
    end

endmodule

