module PC_tb;
  reg clk;
  reg reset;
  reg branch;
  reg stall;
  reg [9:0]adder_input;
  reg [9:0]br_address;
  wire [9:0]instr_address;
  localparam CLOCK_CYCLES = 10, CLOCK_PERIOD = 100;

  
  PC inst1(
    .clk(clk),
    .reset(reset),
    .branch(branch),
    .stall(stall),
    .adder_input(adder_input),
    .br_address(br_address),
    .instr_address(instr_address)
  );
  
  initial begin 
        clk = 0;
        repeat(CLOCK_CYCLES * 2)
            #(CLOCK_PERIOD / 2) clk = ~clk;
  end
  
  initial begin
    reset = 1;
    #200 reset = 0;
    branch = 0;
    stall = 0;
    adder_input = 0;
  end
  
  initial begin
    stall=0;
    branch=1;
    br_address=10'b0000000011; // 3
    #300
    branch=0;
    #300
    stall=1;
    #300
    stall=0;
    branch=1;
    br_address=10'b0000000010; // 2
  end
endmodule
