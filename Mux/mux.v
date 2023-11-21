module mux (
    input sel,
    input [15:0] inp1, inp2,
    output [15:0] out
);

    assign out = (sel) ? inp2 : inp1;

endmodule