module processor;
    reg clk, reset, en_write, start;
    reg [15:0] data_in;
    wire [14:0] control_lines;
    wire [9:0] pc_out;
    wire [15:0] instruction;

    wire [15:0] x_out, y_out, acc_out;
    wire [15:0] sp_out, dm_out, alu_out;
    wire [3:0] alu_flags;

    wire [15:0] alu_val_extend_out, alu_reg_mux_out, dm_val_extend_out, dm_mux_out;
    wire [9:0] pc_mux_out ,new_pc_val;
    wire [4:0] state;
    

    localparam MOVE = 0, STORE = 1, BRANCH = 2;
    localparam POP = 3, PUSH = 4, STALL = 5;
    localparam STR_REZ = 6, LOAD_Y = 7, LOAD_X = 8;
    localparam ACC_OPX = 9, ACC_OPY = 10, JMP = 11;
    localparam RET = 12, RESET_CU = 13, DONE = 14;

    PC_adder pc_adder(
        .in(pc_out),
        .out(new_pc_val)
    );

    mux2to1 #(10) pc_mux (
        .data_0(instruction[9:0]),
        .data_1(dm_out[9:0]),
        .sel(control_lines[RET]),
        .data_out(pc_mux_out)
    );
    
    PC pc(
        .clk(clk),
        .reset(reset),
        .branch(control_lines[BRANCH]),
        .stall(control_lines[STALL]),
        .branch_address(pc_mux_out),
        .new_pc_val(new_pc_val),
        .pc_out(pc_out)
    );

    IM im(
        .clk(clk),
        .en_write(en_write),
        .address(pc_out),
        .data_in(data_in),
        .data_out(instruction)
    );

    reg_file register_file(
        .clk(clk),
        .reset(reset),
        .str_rez(control_lines[STR_REZ]),
        .load_x(control_lines[LOAD_X]),
        .load_y(control_lines[LOAD_Y]),
        .acc_opx(control_lines[ACC_OPX]),
        .acc_opy(control_lines[ACC_OPY]),
        .pop(control_lines[POP]),
        .push(control_lines[PUSH]),
        .alu_out(alu_out),
        .dm_out(dm_out),
        .acc_out(acc_out),
        .x_out(x_out),
        .y_out(y_out),
        .sp_out(sp_out)
    );

    mux2to1 #(16) alu_reg_mux(
        .data_0(x_out),
        .data_1(y_out),
        .sel(instruction[9]),
        .data_out(alu_reg_mux_out)
    );

    sign_extend #(9, 16) alu_val_extend(
        .data_in(instruction[8:0]),
        .data_out(alu_val_extend_out)
    );

    ALU alu(
        .store(control_lines[STORE]),
        .A(alu_reg_mux_out),
        .B(alu_val_extend_out),
        .opcode(instruction[15:10]),
        .flags(alu_flags),
        .out(alu_out)
    );

    control_unit cu (
        .clk(clk),
        .reset(reset),
        .start(start),
        .opcode(instruction[15:10]),
        .reg_s(instruction[9]),
        .acc_s(instruction[8]),
        .flags(alu_flags),
        .control_lines(control_lines),
        .state(state)
    );

    sign_extend #(10, 16) dm_val_extend(
        .data_in(new_pc_val),
        .data_out(dm_val_extend_out)
    );

    mux2to1 #(16) dm_mux(
        .data_0(alu_out),
        .data_1(dm_val_extend_out),
        .sel(control_lines[JMP]),
        .data_out(dm_mux_out)
    );

    DM data_memory(
        .clk(clk),
        .load(control_lines[LOAD_X] | control_lines[LOAD_Y]),
        .store(control_lines[STORE]),
        .push(control_lines[PUSH]),
        .pop(control_lines[POP]),
        .address(instruction[8:0]),
        .rez(dm_mux_out),
        .sp(sp_out),
        .data_out(dm_out)
    );

    
    localparam NUM_INSTRUCTIONS = 15;
    localparam CLOCK_CYCLES = NUM_INSTRUCTIONS * 2, CLOCK_PERIOD = 100;

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
        data_in = 16'b0100000000000010;
        #100
        data_in = 16'b0010000000000111;
        #100
        data_in = 16'b0111010000000000;
        #100
        data_in = 16'b0000000000000000;
        #100
        data_in = 16'b0111011000000000;
        #100
        data_in = 16'b0111010000000000;
        #100
        data_in = 16'b0010100000000110;
        #100
        data_in = 16'b0100000100000000;
        #100
        data_in = 16'b0111000000000000;
        #100
        data_in = 16'b0100000000000100;
        #100
        data_in = 16'b0111001000000000;
        #100
        data_in = 16'b0010010000000000;
    end

endmodule