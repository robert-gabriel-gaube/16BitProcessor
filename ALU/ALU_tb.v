module ALU_tb;
  reg [5:0] op_code;
  reg [31:0] val;
  reg [31:0] reg0;
  reg reset, move, store, clk;
  wire ALU_ready;
  wire [3:0] ALU_flags;
  wire [31:0] rez;

  ALU alu (
    .op_code(op_code),
    .val(val),
    .reg0(reg0),
    .reset(reset),
    .move(move),
    .store(store),
    .clk(clk),
    .ALU_ready(ALU_ready),
    .ALU_flags(ALU_flags),
    .rez(rez)
  );

  always #5 clk = ~clk;

  initial begin
    op_code = 6'b001010;
    val = 32'b0101;
    reg0 = 32'b1100;
    reset = 0; 
    move = 0;
    store = 0;
    clk = 0; 
    reset = 1;
    #10 reset = 0;

    op_code = 6'b001010;  // ADD
    val = 32'b0101;
    reg0 = 32'b1100;
    #10 move = 1;
    #10;
    if(rez !== 32'b0101) begin 
	$fatal("Test failed: ADD operation"); 
    end

    op_code = 6'b001011;  // SUB
    val = 32'b0001;
    reg0 = 32'b0010;
    move = 0;
    #10 move = 1;
    #10;
    if(rez !== 32'b0001) begin 
	$fatal("Test failed: SUB operation");
    end

    op_code = 6'b001100;  // LSR
    val = 5;
    reg0 = 32'b1100;
    move = 0;
    #10 move = 1;
    #10;
    if(rez === 32'b0000) begin 
	$fatal("Test failed: LSR operation");
    end

    op_code = 6'b001101;  // LSL
    val = 2;
    reg0 = 32'b1100;
    move = 0;
    #10 move = 1;
    #10;
    if(rez === 32'b110000) begin 
	$fatal("Test failed: LSL operation");
    end

    op_code = 6'b001110;  // RSR
    val = 2;
    reg0 = 32'b1100;
    move = 0;
    #10 move = 1;
    #10;
    if(rez === 32'b0011) begin 
	$fatal("Test failed: RSR operation");
    end

    op_code = 6'b001111;  // RSL
    val = 2;
    reg0 = 32'b1100;
    move = 0;
    #10 move = 1;
    #10;
    if(rez === 32'b0011) begin 
	$fatal("Test failed: RSL operation");
    end

    op_code = 6'b010100;  // AND
    val = 32'b1100;
    reg0 = 32'b1010;
    move = 0;
    #10 move = 1;
    #10;
    if(rez === 32'b1000) begin
	$fatal("Test failed: AND operation");
    end

    op_code = 6'b010101;  // OR
    val = 32'b0011;
    reg0 = 32'b1100;
    move = 0;
    #10 move = 1;
    #10;
    if(rez === 32'b1111) begin
	$fatal("Test failed: OR operation");
    end

    op_code = 6'b010110;  // XOR
    val = 32'b1010;
    reg0 = 32'b1100;
    move = 0;
    #10 move = 1;
    #10;
    if(rez === 32'b0110) begin
	$fatal("Test failed: XOR operation");
    end

    op_code = 6'b010111;  // NOT
    val = 0;
    reg0 = 32'b1100;
    move = 0;
    #10 move = 1;
    #10;
    if(rez === 32'b0011) begin
	$fatal("Test failed: NOT operation");
    end

    op_code = 6'b011000;  // CMP
    val = 32'b0100;
    reg0 = 32'b1100;
    move = 0;
    #10 move = 1;
    #10;
    if(ALU_flags[0] && !ALU_flags[1] && ALU_flags[2] && !ALU_flags[3]) begin
	$fatal("Test failed: CMP operation");
    end

    op_code = 6'b011001;  // TST
    val = 32'b1100;
    reg0 = 32'b1010;
    move = 0;
    #10 move = 1;
    #10;
    if(ALU_flags[0] && !ALU_flags[1] && !ALU_flags[2] && !ALU_flags[3]) begin
	$fatal("Test failed: TST operation");
    end

    op_code = 6'b011010;  // INC
    val = 0;
    reg0 = 32'b1100;
    move = 0;
    #10 move = 1;
    #10;
    if(rez === 32'b1101) begin
	$fatal("Test failed: INC operation");
    end

    op_code = 6'b011011;  // DEC
    val = 0;
    reg0 = 32'b1100;
    move = 0;
    #10 move = 1; 
    #10;
    if(rez === 32'b1011) begin 
	$fatal("Test failed: DEC operation");
    end
    $finish;
  end
endmodule
