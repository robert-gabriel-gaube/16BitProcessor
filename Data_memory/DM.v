module DM(
    input [15:0] rez,
    input load, store, push, pop, clk,
    input [15:0] sp,
    input [8:0] address,
    output reg [8:0]address_reg,
    output reg [15:0] data_out
);

reg [15:0] memory [0:65535];


always @(posedge clk) begin 
    #1
    address_reg <= address;
    #4
    if(push)        memory[sp] <= rez;
    else if(store)  memory[address_reg] <= rez;
    else if(pop)    data_out <= memory[sp];
    else if(load)   data_out <= memory[address_reg];
end

endmodule