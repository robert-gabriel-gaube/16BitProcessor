module PC_adder(
  input [9:0]in,
  output reg [9:0]out
);
  always(*)
  begin
    out = in + 1;
  end
endmodule


module PC(
  input [9:0]adder_input,
  input [9:0]br_address,
  input branch, stall, clk, reset,
  output reg [9:0]instr_address
);

PC_adder adder_inst(
    .in(instr_address),
    .out(adder_input)
  );

always @(posedge clk, posedge reset)
begin
  if(reset)
    instr_address<=0;
  else 
    begin
    if(branch)
      instr_address<=br_address;
    else if(!stall)
    instr_address<=adder_input;
    end  
end
endmodule