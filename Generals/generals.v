module mux2to1 #(parameter data_width = 8)(
    input wire [data_width-1:0] data_0,
    input wire [data_width-1:0] data_1,
    input wire sel,
    output wire [data_width-1:0] data_out
);
    assign data_out = (sel) ? data_1 : data_0;

endmodule

module mux9to1(
    input [143:0] data_in,
    input [3:0] select,                        
    output reg [15:0] data_out
);

    always @*
        case (select)
            4'b0000: data_out = data_in[15:0];
            4'b0001: data_out = data_in[31:16];
            4'b0010: data_out = data_in[47:32];
            4'b0011: data_out = data_in[63:48];
            4'b0100: data_out = data_in[79:64];
            4'b0101: data_out = data_in[95:80];
            4'b0110: data_out = data_in[111:96];
            4'b0111: data_out = data_in[127:112];
            4'b1000: data_out = data_in[143:128];
        endcase

endmodule

module sign_extend #(parameter from_size = 8, parameter to_size = 16)(
    input [from_size-1:0] data_in,
    output [to_size-1:0] data_out
);
    assign data_out = {{to_size - from_size{data_in[from_size-1]}}, data_in};

endmodule

module incrementer #(parameter data_width = 10)(
    input [data_width-1:0] in,
    output [data_width-1:0] out
);
    assign out = in + 1;

endmodule
  