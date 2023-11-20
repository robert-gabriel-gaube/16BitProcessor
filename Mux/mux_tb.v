module mux_tb;
    reg sel;
    reg [15:0] inp1, inp2;
    wire [15:0] out;

    mux inst(
        .sel(sel),
        .inp1(inp1),
        .inp2(inp2),
        .out(out)
    );

    initial begin
        sel = 1'b0;
        inp1 = 16'h0013; // 19
        inp2 = 16'h0031; // 49
        #100 sel = 1'b1;
        #100 sel = 1'b0;
        #100 sel = 1'b0;
        #100 sel = 1'b1;
    end

endmodule