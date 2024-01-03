module mux2to1 #(parameter data_width = 8)(
    input wire [data_width-1:0] data_0,
    input wire [data_width-1:0] data_1,
    input wire sel,
    output wire [data_width-1:0] data_out
);
    assign data_out = (sel) ? data_1 : data_0;

endmodule

module sign_extend #(parameter from_size = 8, parameter to_size = 16)(
    input [from_size-1:0] data_in,
    output [to_size-1:0] data_out
);
    assign data_out = {{to_size - from_size{data_in[from_size-1]}}, data_in};

endmodule
  