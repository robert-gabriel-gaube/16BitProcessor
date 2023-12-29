module DM_tb;

  // Parameters
  parameter CLK_PERIOD = 10; // in nanoseconds

  // Signals
  reg [15:0] rez;
  reg load, store, push, pop, clk;
  reg [15:0] sp;
  reg [8:0] address;
  wire [15:0] data_out;

  // Instantiate the design under test (DUT)
  DM my_DM (
    .rez(rez),
    .load(load),
    .store(store),
    .push(push),
    .pop(pop),
    .clk(clk),
    .sp(sp),
    .address(address),
    .data_out(data_out)
  );

  // Clock generation
  always #((CLK_PERIOD)/2) clk = ~clk;

  // Initial stimulus
  initial begin
    // Initialize inputs
    rez = 16'h0000;
    load = 0;
    store = 0;
    push = 0;
    pop = 0;
    clk = 0;
    sp = 16'h0000;
    address = 9'h000;

    // Apply stimulus
    #5 store = 1; address = 9'h001; rez = 16'h1234; // Store data at address 1
    #5 load = 1; store = 0; address = 9'h001; // Load data from address 1
    #5 load = 0; push = 1; sp = 16'h002; rez = 16'h5678; // Push data to stack
    #5 pop = 1; sp = 16'h002; // Pop data from stack

  end

endmodule