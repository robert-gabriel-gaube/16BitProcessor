module flags(
  input [3:0]ALU_flags,
  input ALU_ready,reset,
  output reg [3:0]out
);

always @(*)
begin
  if(reset)
    out<=0'b0000;
  else 
    begin
    if(ALU_ready)
      out<=ALU_flags;
    end
end

endmodule