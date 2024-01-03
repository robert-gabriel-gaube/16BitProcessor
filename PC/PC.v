module PC_adder(
    input [9:0] in,
    output [9:0] out
);
    assign out = in + 1;

endmodule

module PC(
    input [9:0] new_pc_val,
    input [9:0] branch_address,
    input branch, stall, clk, reset,
    output reg [9:0] pc_out
);

  always @(posedge clk, posedge reset) begin 
    if(reset)           pc_out <= 0;
    else if(branch) #1  pc_out <= branch_address;
    else if(!stall)     pc_out <= new_pc_val;
  end

endmodule