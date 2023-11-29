module INC_DEC_SP(
    input wire pop,
    input wire [15:0] sp,
    output [15:0] val
);

    assign val = (pop == 1) ? (sp + 1) : (sp - 1);

endmodule
