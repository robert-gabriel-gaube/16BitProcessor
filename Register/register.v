module register (
    input clk, en,
    input [15:0] D,
    output [15:0] Q
);

    wire [15:0] mux_out;

    mux inst0(
        .sel(en),
        .inp1(Q),
        .inp2(D),
        .out(mux_out)
    );

    DFF inst1(
        .clk(clk),
        .D(mux_out),
        .Q(Q)
    );
    
endmodule