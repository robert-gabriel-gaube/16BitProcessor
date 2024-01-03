module processor;
    reg clk, reset, en_write, start;

    reg [15:0] data_in;
    wire [18:0] control_lines;
    wire [9:0] pc_out;
    wire [15:0] instruction;

    wire [15:0] x_out, y_out, acc_out;
    wire [15:0] sp_out, dm_out, alu_out;
    wire [3:0] alu_flags;

    wire [15:0] alu_val_extend_out, alu_reg_mux_out, dm_val_extend_out;
    wire [15:0] dm_mux_out, dm_mux_mux_out, tensor_element_out;
    wire [9:0] pc_mux_out, new_pc_val;
    wire [8:0] dm_address;
    wire [4:0] state;
    wire [3:0] counter_out;

    wire [143:0] a_out, b_out, mxu_out, t_acc_out;
    

    localparam MOVE = 0, STORE = 1, BRANCH = 2;
    localparam POP = 3, PUSH = 4, STALL = 5;
    localparam STR_REZ = 6, LOAD_Y = 7, LOAD_X = 8;
    localparam ACC_OPX = 9, ACC_OPY = 10, JMP = 11;
    localparam RET = 12, LOAD_A = 13, LOAD_B = 14;
    localparam STORE_TENSOR = 15, STR_TENSOR_REZ = 16;
    localparam RESET_CU = 17, DONE = 18;

    incrementer #(10) pc_adder(
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
        .reset(reset | control_lines[RESET_CU]),
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
        .control_lines(control_lines),
        .counter_out(counter_out),
        .alu_out(alu_out),
        .dm_out(dm_out),
        .mxu_out(mxu_out),
        .acc_out(acc_out),
        .x_out(x_out),
        .y_out(y_out),
        .a_out(a_out),
        .b_out(b_out),
        .t_acc_out(t_acc_out),
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
        .tensor_op_done(counter_out == 4'b1001),
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

    mux2to1 #(16) dm_mux_value(
        .data_0(alu_out),
        .data_1(dm_val_extend_out),
        .sel(control_lines[JMP]),
        .data_out(dm_mux_out)
    );

    mux9to1 tensor_element(
        .data_in(t_acc_out),
        .select(counter_out),
        .data_out(tensor_element_out)
    );

    mux2to1 #(16) dm_mux_mux_value(
        .data_0(dm_mux_out),
        .data_1(tensor_element_out),
        .sel(control_lines[STORE_TENSOR]),
        .data_out(dm_mux_mux_out)
    );


    mux2to1 #(9) dm_mux_address(
        .data_0(instruction[8:0]),
        .data_1(counter_out + instruction[8:0]),
        .sel(control_lines[LOAD_A] | control_lines[LOAD_B] | control_lines[STORE_TENSOR]),
        .data_out(dm_address)
    );

    DM data_memory(
        .clk(clk),
        .store(control_lines[STORE] | control_lines[STORE_TENSOR]),
        .push(control_lines[PUSH]),
        .pop(control_lines[POP]),
        .address(dm_address),
        .rez(dm_mux_mux_out),
        .sp(sp_out),
        .data_out(dm_out)
    );

    // Tensor operations
    
    counter tensor_counter(
        .reset(reset),
        .clk(clk),
        .enable(control_lines[STALL]),
        .counter_out(counter_out)
    );

    MXU mxu(
        .A(a_out),
        .B(b_out),
        .mxu_out(mxu_out)
    );

    localparam NUM_INSTRUCTIONS = 25;
    localparam CLOCK_CYCLES = 100, CLOCK_PERIOD = 100;

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
        data_in = 16'b0100000000000001;
        #100
        data_in = 16'b0000100000000001;
        #100
        data_in = 16'b0100000000000010;
        #100
        data_in = 16'b0000100000000010;
        #100
        data_in = 16'b0100000000000011;
        #100
        data_in = 16'b0000100000000011;
        #100
        data_in = 16'b0100000000000100;
        #100
        data_in = 16'b0000100000000100;
        #100
        data_in = 16'b0100000000000101;
        #100
        data_in = 16'b0000100000000101;
        #100
        data_in = 16'b0100000000000110;
        #100
        data_in = 16'b0000100000000110;
        #100
        data_in = 16'b0100000000000111;
        #100
        data_in = 16'b0000100000000111;
        #100
        data_in = 16'b0100000000001000;
        #100
        data_in = 16'b0000100000001000;
        #100
        data_in = 16'b0100000000001001;
        #100
        data_in = 16'b0000100000001001;
        #100
        data_in = 16'h7C01;
        #100
        data_in = 16'h7E01;
        #100
        data_in = 16'h8000;
        #100
        data_in = 16'h7801;
        #100
        data_in = 16'h7C01;
        #100
        data_in = 16'h0000;
    end

endmodule