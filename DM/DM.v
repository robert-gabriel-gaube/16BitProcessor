module DM (
    input clk,
    input [15:0]rez,
    input load,
    input store,
    input push,
    input pop,
    input [15:0] val,
    input [15:0] sp,
    output reg [15:0] out
);
   reg [15:0] memory [0:255];
   reg [15:0] internal_sp;  // Internal register for sp

  always @(posedge clk) begin
    if (load) begin
      out <= memory[val];
    end else if (store) begin
      memory[val] <= rez;
    end else if (push) begin
      memory[sp] <= rez;
      internal_sp <= sp + 1;  // Increment internal_sp
    end else if (pop) begin
      internal_sp <= sp - 1;  // Decrement internal_sp
      out <= memory[sp];
    end
  end

endmodule

