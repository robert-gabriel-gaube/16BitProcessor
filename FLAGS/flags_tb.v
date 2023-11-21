module flags_tb;
  reg [3:0]ALU_flags;
  reg ALU_ready;
  reg reset;
  wire [3:0]out;
  
  flags inst(
    .ALU_flags(ALU_flags),
    .ALU_ready(ALU_ready),
    .reset(reset),
    .out(out)
  );
  
  initial 
  begin
      // out = ALU_flags
      reset = 0;
      ALU_ready = 1;
      ALU_flags = 0'b0001;
      #200;
      
      // out = out(unchanged)
      reset = 0;
      ALU_ready = 0;
      ALU_flags = 0'b0010;
      #200;
      
      // out = 0'b0000
      reset = 1;
      ALU_ready = 0;
      ALU_flags = 0'b0011;
      #200;
      
      // out = 0'b0000
      reset = 1;
      ALU_ready = 1;
      ALU_flags = 0'b0100;
      #200;
      
  end
  
endmodule
