module reg_file (
    input clk, reset,
    input [18:0] control_lines,
    input [3:0] counter_out,
    input [143:0] mxu_out,
    input [15:0] alu_out, dm_out,
    output [15:0] acc_out, x_out, y_out, sp_out,
    output [143:0] a_out, b_out, t_acc_out
);
    wire [15:0] new_sp_val;

    localparam MOVE = 0, STORE = 1, BRANCH = 2;
    localparam POP = 3, PUSH = 4, STALL = 5;
    localparam STR_REZ = 6, LOAD_Y = 7, LOAD_X = 8;
    localparam ACC_OPX = 9, ACC_OPY = 10, JMP = 11;
    localparam RET = 12, LOAD_A = 13, LOAD_B = 14;
    localparam STORE_TENSOR = 15, STR_TENSOR_REZ = 16;
    localparam RESET_CU = 17, DONE = 18;

    accumulator acc(
        .clk(clk),
        .reset(reset),
        .str_rez(control_lines[STR_REZ]),
        .alu_out(alu_out),
        .out(acc_out)
    );

    register reg_x(
        .clk(clk),
        .reset(reset),
        .load(control_lines[LOAD_X]),
        .acc_op(control_lines[ACC_OPX]),
        .acc_val(acc_out),
        .data_val(dm_out),
        .out(x_out)
    );

    register reg_y(
        .clk(clk),
        .reset(reset),
        .load(control_lines[LOAD_Y]),
        .acc_op(control_lines[ACC_OPY]),
        .acc_val(acc_out),
        .data_val(dm_out),
        .out(y_out)
    );

    INC_DEC_SP INC_DEC_SP_inst(
        .pop(control_lines[POP]),
        .sp(sp_out),
        .val(new_sp_val)
    );

    SP stack_pointer(
        .clk(clk),
        .reset(reset),
        .pop(control_lines[POP]),
        .push(control_lines[PUSH]),
        .new_sp_val(new_sp_val),
        .out(sp_out)
    );

    // Tensor operations

    tensor_accumulator t_acc(
        .clk(clk),
        .reset(reset),
        .str_rez(control_lines[STR_TENSOR_REZ]),
        .mxu_out(mxu_out),
        .acc_out(t_acc_out)
    );

    tensor_register A(
        .clk(clk),
        .reset(reset),
        .element(dm_out),
        .idx(counter_out),
        .load(control_lines[LOAD_A]),
        .tensor_out(a_out)
    );

    tensor_register B(
        .clk(clk),
        .reset(reset),
        .element(dm_out),
        .idx(counter_out),
        .load(control_lines[LOAD_B]),
        .tensor_out(b_out)
    );

endmodule 