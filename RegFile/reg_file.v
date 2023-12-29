module reg_file (
    input clk, reset, str_rez,
    input load_x, load_y, acc_opx, acc_opy,
    input pop, push,
    input [15:0] alu_out, dm_out,
    output [15:0] acc_out, x_out, y_out, sp_out
);
    wire [15:0] new_sp_val;

    accumulator acc(
        .clk(clk),
        .reset(reset),
        .str_rez(str_rez),
        .alu_out(alu_out),
        .out(acc_out)
    );

    register reg_x(
        .clk(clk),
        .reset(reset),
        .load(load_x),
        .acc_op(acc_opx),
        .acc_val(acc_out),
        .data_val(dm_out),
        .out(x_out)
    );

    register reg_y(
        .clk(clk),
        .reset(reset),
        .load(load_y),
        .acc_op(acc_opy),
        .acc_val(acc_out),
        .data_val(dm_out),
        .out(y_out)
    );

    INC_DEC_SP INC_DEC_SP_inst(
        .pop(pop),
        .sp(sp_out),
        .val(new_sp_val)
    );

    SP stack_pointer(
        .clk(clk),
        .reset(reset),
        .pop(pop),
        .push(push),
        .new_sp_val(new_sp_val),
        .out(sp_out)
    );

endmodule 