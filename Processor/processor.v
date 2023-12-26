module processor;
    reg clk, reset, en_write;
    reg [15:0] data_in;
    wire [9:0] instr_address, adder_input;
    wire [15:0] instruction;

    reg start;
    wire move, store, branch, pop, push;
    wire stall, str_rez, load_y, load_x;
    wire acc_opx, acc_opy, done, reset_cu;
    wire [3:0] state;

    wire [15:0] register_x, register_y, register_acc, alu_out;
    wire [3:0] alu_flags;

    ALU alu(
        .A(instruction[9] ? register_y : register_x),
        .B({{7{instruction[8]}} ,instruction[8:0]}),
        .opcode(instruction[15:10]),
        .out(alu_out),
        .Z(alu_flags[0]),
        .N(alu_flags[1]),
        .C(alu_flags[2]),
        .O(alu_flags[3])
    );

    accumulator acc(
        .ALU_rez(alu_out),
        .reset(reset),
        .clk(clk),
        .str_rez(str_rez),
        .out(register_acc)
    );

    register reg_x(
        .reset(reset),
        .clk(clk),
        .acc_op(acc_opx),
        .load(load_x),
        .acc_val(register_acc),
        .data_val(alu_out),
        .out(register_x)
    );

    register reg_y(
        .reset(reset),
        .clk(clk),
        .acc_op(acc_opy),
        .load(load_y),
        .acc_val(register_acc),
        .data_val(alu_out),
        .out(register_y)
    );

    PC_adder inst0(
        .in(instr_address),
        .out(adder_input)
    );
    
    PC inst1(
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .stall(stall),
        .br_address(instruction[9:0]),
        .adder_input(adder_input),
        .instr_address(instr_address)
    );

    IM inst2(
        .clk(clk),
        .en_write(en_write),
        .address(instr_address),
        .data_in(data_in),
        .data_out(instruction)
    );

    control_unit cu (
        .opcode(instruction[15:10]),
        .reg_s(instruction[9]),
        .acc_s(instruction[8]),
        .start(start),
        .reset(reset),
        .clk(clk),
        .flags(alu_flags),
        .move(move),
        .store(store),
        .branch(branch),
        .pop(pop),
        .push(push),
        .stall(stall),
        .str_rez(str_rez),
        .load_y(load_y),
        .load_x(load_x),
        .acc_opx(acc_opx),
        .acc_opy(acc_opy),
        .done(done),
        .reset_cu(reset_cu),
        .state(state)
    );

    localparam CLOCK_CYCLES = 30, CLOCK_PERIOD = 100;
    localparam NUM_INSTRUCTIONS = 12;

    initial begin 
        clk = 0;
        repeat(CLOCK_CYCLES * 2)
            #(CLOCK_PERIOD / 2) clk = ~clk;
    end

    initial begin 
        start = 1'b0;
        reset = 1'b1;
        #50 reset = 1'b0;
        #(100 * NUM_INSTRUCTIONS) reset = 1'b1;
        start = 1'b1;
        #50 reset = 1'b0;
    end

    initial begin 
        en_write = 1'b1;
        #(100 * NUM_INSTRUCTIONS) en_write = 1'b0;
    end

    initial begin 
        data_in = 16'hFFFF;
        #100
        data_in = 16'b0100001000000011;
        #100
        data_in = 16'b0100000000000001;
        #100
        data_in = 16'b0110100000000000;
        #100
        data_in = 16'b0100000100000000;
        #100
        data_in = 16'b0110111000000000;
        #100
        data_in = 16'b0100001100000000;
        #100
        data_in = 16'b0110111000000000;
        #100
        data_in = 16'b0000110000001010;
        #100
        data_in = 16'b0001110000000011;
        #100
        data_in = 16'b0100001000001010;
        #100
        data_in = 16'b0000000000000000;
    end

endmodule