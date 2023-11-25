module PC_tb;
  reg clk, reset, branch, stall;
  reg [9:0]br_address;
  wire [9:0]adder_input, instr_address;

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

  PC_adder inst0(
    .in(instr_address),
    .out(adder_input)
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
  end
  
  initial begin
    stall=0; branch=1;
    br_address=10'h003; // 3
    #300 branch=0;
    #300 stall=1;
    #300 stall=0;
    branch=1;
    br_address=10'h002; // 2
  end
endmodule
