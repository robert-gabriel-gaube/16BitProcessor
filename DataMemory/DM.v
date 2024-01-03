module DM(
    input [15:0] rez,
    input store, push, pop, clk,
    input [15:0] sp,
    input [8:0] address,
    output [15:0] data_out
);
    reg [8:0] address_reg;
    reg [15:0] memory [0:65535];


    always @(posedge clk) begin 
        #1 address_reg <= address; #4

        if(push)        memory[sp] <= rez;
        else if(store)  memory[address_reg] <= rez;
    end
    
    assign data_out = (pop) ? memory[sp] : memory[address_reg];

endmodule