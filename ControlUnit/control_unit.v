module control_unit(
    input reg_s, acc_s, start, reset, clk,
    input tensor_op_done,
    input [5:0] opcode, 
    input [3:0] flags,
    output [18:0] control_lines,
    output reg [4:0] state
);
    localparam MOVE = 0, STORE = 1, BRANCH = 2;
    localparam POP = 3, PUSH = 4, STALL = 5;
    localparam STR_REZ = 6, LOAD_Y = 7, LOAD_X = 8;
    localparam ACC_OPX = 9, ACC_OPY = 10, JMP = 11;
    localparam RET = 12, LOAD_A = 13, LOAD_B = 14;
    localparam STORE_TENSOR = 15, STR_TENSOR_REZ = 16;
    localparam RESET_CU = 17, DONE = 18;

    localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3;
    localparam S4 = 4, S5 = 5, S6 = 6, S7 = 7;
    localparam S8 = 8, S9 = 9, S10 = 10;
    localparam S11 = 11, S12 = 12, S13 = 13;
    localparam S14 = 14, S15 = 15, S16 = 16;
    localparam S17 = 17, S18 = 18, S19 = 19;
    localparam S20 = 20;

    localparam SNOTHING = 21, SRESET = 22;
    reg [4:0] state_next;

    always @(*) begin
        if(state == S0 &&
            !start)                 state_next = S0;
        else if(state == S0)        state_next = SRESET;
        else if(state == S13)       state_next = S0;
        else if(state >= S16 &&
                state <= S18)       state_next = tensor_op_done ? SNOTHING : state;
        else if(opcode == 6'h00)    state_next = S13;
        else if(opcode == 6'h01)    state_next = (reg_s) ? S1 : S2;
        else if(opcode == 6'h02)    state_next = S3;
        else if(opcode >= 6'h03 &&
                opcode <= 6'h06)    state_next = (flags[opcode - 6'h03]) ? S4 : SNOTHING;
        else if(opcode == 6'h07)    state_next = S4;
        else if(opcode == 6'h08)    state_next = S14;
        else if(opcode == 6'h09)    state_next = S15;
        else if(opcode >= 6'h0A &&
                opcode <= 6'h0F)    state_next = S5;
        else if(opcode == 6'h10) begin  
            if(reg_s)               state_next = acc_s ? S7 : S6;
            else                    state_next = acc_s ? S9 : S8;
        end
        else if(opcode >= 6'h11 &&
                opcode <= 6'h17)    state_next = S5;
        else if(opcode == 6'h18 ||
                opcode == 6'h19)    state_next = SNOTHING;
        else if(opcode == 6'h1A ||
                opcode == 6'h1B)    state_next = S5;
        else if(opcode == 6'h1C)    state_next = S10;
        else if(opcode == 6'h1D)    state_next = reg_s ? S11 : S12;
        else if(opcode == 6'h1E)    state_next = S18;
        else if(opcode == 6'h1F)    state_next = reg_s ? S16 : S17;
        else if(opcode == 6'h20)    state_next = S19;
        else                        state_next = SNOTHING;
    end

    always @(posedge clk, posedge reset) begin 
        #1
        if(control_lines[BRANCH])  #2;
        if(reset)   state <= S0;
        else        state <= state_next;
    end

    assign control_lines[MOVE] = (state == S6) || (state == S8);
    assign control_lines[STORE] = (state == S3) || (state == S10);
    assign control_lines[BRANCH] = (state == S4) || (state == S14) || (state == S15);
    assign control_lines[POP] = (state == S11) || (state == S12) || (state == S15);
    assign control_lines[PUSH] = (state == S10) || (state == S14);
    assign control_lines[STALL] = (state == S16) || (state == S17) || (state == S18);
    assign control_lines[STR_REZ] = (state == S5) || (state == S6) || (state == S8);
    assign control_lines[LOAD_Y] = (state == S1) || (state == S11);
    assign control_lines[LOAD_X] = (state == S2) || (state == S12);
    assign control_lines[ACC_OPY] = (state == S6) || (state == S7);
    assign control_lines[ACC_OPX] = (state == S8) || (state == S9);
    assign control_lines[JMP] = (state == S14);
    assign control_lines[RET] = (state == S15);
    assign control_lines[LOAD_B] = (state == S16);
    assign control_lines[LOAD_A] = (state == S17);
    assign control_lines[STORE_TENSOR] = (state == S18);
    assign control_lines[STR_TENSOR_REZ] = (state == S19);
    assign control_lines[RESET_CU] = (state == SRESET);
    assign control_lines[DONE] = (state == S13);

endmodule