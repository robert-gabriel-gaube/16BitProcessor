module DM_tb;

  reg clk;
  reg  load, store, push, pop;
  reg [15:0] sp,rez,val;
  wire [15:0] out;

  // Instantiate the Design Under Test (DUT)
  DM uut (
    .clk(clk),
    .rez(rez),
    .load(load),
    .store(store),
    .push(push),
    .pop(pop),
    .val(val),
    .sp(sp),
    .out(out)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Stimulus generation
  initial begin
    // Initialize inputs
    clk = 0;