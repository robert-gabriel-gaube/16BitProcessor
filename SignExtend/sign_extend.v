module sign_extend #(
  parameter from_size = 8, 
  parameter to_size = 16
)(
  input [from_size-1:0] in_data,
  output [to_size-1:0] out_data
);

  assign out_data = {{to_size - from_size{in_data[from_size-1]}}, in_data};

endmodule
  