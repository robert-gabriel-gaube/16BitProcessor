module DM(
    input [15:0] rez,
    input load, store, push, pop, clk,
    input [15:0] sp,
    input [8:0] address,
    output [15:0] data_out
);

reg [15:0] memory [0:65535];

always @(posedge clk) begin 
    if(store) memory[address] <= rez;
    else if(push) memory[sp] <= rez;
end

assign data_out = (load) ? memory[address] : (pop ? memory[sp] : 0);

endmodule