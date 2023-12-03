module IM (
    input clk,
    input en_write,
    input [9:0] address,
    input [15:0] data_in,
    output [15:0] data_out
);
    reg [15:0] memory [0:1023];

    always @(posedge clk) begin
        if(en_write) memory[address] = data_in;
        else memory[address] = memory[address];
    end

    assign data_out = (en_write) ? 0 : memory[address];
endmodule