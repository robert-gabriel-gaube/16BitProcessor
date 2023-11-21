module PC(
  input [9:0]br_address,
  input branch, stall, clk, reset,
  output reg [9:0]instr_address
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
    instr_address<=instr_address+1;
    end  
end
endmodule