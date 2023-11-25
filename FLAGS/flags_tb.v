module flags_tb;
  reg [3:0]ALU_flags;
  reg ALU_ready;
  reg reset;
  reg clk;
  wire [3:0]out;
  
  flags inst(
    .ALU_flags(ALU_flags),
    .ALU_ready(ALU_ready),
    .reset(reset),
    .clk(clk),
    .out(out)
  );
  
  localparam CLOCK_CYCLES = 10, CLOCK_PERIOD = 100;
  
  initial
  begin
    clk = 0;
    repeat(CLOCK_CYCLES * 2)
        #(CLOCK_PERIOD / 2) clk = ~clk;
  end
  
  initial 
  begin
    reset = 1;
      #25;
    reset = 0;
  end
  
  initial 
  begin
    
      // out = ALU_flags
      // reset = 0;
      ALU_ready = 1;
      ALU_flags = 0'b0001;
      #200;
      
      // out = out(unchanged)
      // reset = 0;
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
