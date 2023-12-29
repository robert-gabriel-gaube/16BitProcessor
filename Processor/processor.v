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

    wire [15:0] register_x, register_y, register_acc, alu_out, dm_out;
    wire [15:0] val, sp_out;
    wire [3:0] alu_flags;
    wire [8:0] address_reg;

    ALU alu(
        .A(instruction[9] ? register_y : register_x),
        .B({{7{instruction[8]}} ,instruction[8:0]}),
        .opcode(instruction[15:10]),
        .out(alu_out),
        .store(store),
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
        .data_val(dm_out),
        .out(register_x)
    );

    register reg_y(
        .reset(reset),
        .clk(clk),
        .acc_op(acc_opy),
        .load(load_y),
        .acc_val(register_acc),
        .data_val(dm_out),
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

    SP stack_pointer(
        .pop(pop),
        .push(push),
        .reset(reset),
        .new_val(val),
        .clk(clk),
        .out(sp_out)
    );

    INC_DEC_SP INC_DEC_SP_inst(
        .pop(pop),
        .sp(sp_out),
        .val(val)
    );

    DM data_memory(
        .clk(clk),
        .rez(alu_out),
        .load(load_x | load_y),
        .store(store),
        .push(push),
        .pop(pop),
        .sp(sp_out),
        .address(instruction[8:0]),
        .data_out(dm_out),
        .address_reg(address_reg)
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
    localparam NUM_INSTRUCTIONS = 9;

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
        data_in = 16'b0100000000000100;
        #100
        data_in = 16'b0111000000000000;
        #100
        data_in = 16'b0110100000000000;
        #100
        data_in = 16'b0100000100000000;
        #100
        data_in = 16'b0111000000000000;
        #100
        data_in = 16'b0111011000000000;
        #100
        data_in = 16'b0111011000000000;
        #100
        data_in = 16'b0000000000000000;
    end

endmodule