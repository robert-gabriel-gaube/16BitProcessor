module PC_adder(
    input [9:0] in,
    output [9:0] out
);
    assign out = in + 1;

endmodule

module PC(
    input [9:0] adder_input,
    input [9:0] br_address,
    input branch, stall, clk, reset,
    output reg [9:0] instr_address
);

  always @(posedge clk, posedge reset) begin 
    if(reset)           instr_address <= 0;
    else if(branch) #1  instr_address <= br_address;
    else if(!stall)     instr_address <= adder_input;
  end

endmodule