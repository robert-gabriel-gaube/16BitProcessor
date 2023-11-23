module SP(
    input wire pop,
    input wire push,
    input wire reset,
    output reg [15:0] out
);

    always @(*) begin
        if (reset == 1)
            out = 16'hFFFF;
        else if (pop == 1)
            out = out + 1;
        else if (push == 1)
            out = out - 1;
    end

endmodule
