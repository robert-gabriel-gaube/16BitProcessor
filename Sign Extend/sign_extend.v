module sign_extend (
  input  acc_s,
  input  [7:0] val,
  input  acc_op,
  output reg [15:0] out
);

  always @(*)
  begin
    if (!acc_op)
       out = {{8{val[7]}}, val};
    else
      out = {{8{acc_s}}, val};
  end
  
endmodule
  