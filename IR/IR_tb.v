`timescale 1ns/1ns

module IR_tb;

  // Declarațiile semnalelor
  reg clk;
  reg [15:0] instr;
  wire [5:0] op_code;
  wire reg_s, acc_s;
  wire [7:0] val;

  // Instantierea modulului IR
  IR ir_inst (
    .clk(clk),
    .instr(instr),
    .op_code(op_code),
    .reg_s(reg_s),
    .acc_s(acc_s),
    .val(val)
  );

  // Generarea semnalelor de ceas
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Generarea instrucțiunilor și afișarea rezultatelor
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, IR_tb);

    // Test 1
    instr = 16'hA123; // Exemplu de instrucțiune
    #10; // Așteaptă un ciclu de ceas

    // Adăugați mai multe teste aici

    $finish;   // Opriți simularea după ce s-au rulat toate testele
  end

endmodule
