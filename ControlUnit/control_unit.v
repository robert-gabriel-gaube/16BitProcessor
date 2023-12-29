module control_unit(
    input reg_s, acc_s, start, reset, clk,
    input [5:0] opcode, 
    input [3:0] flags,
    output [14:0] control_lines,
    output reg [4:0] state
);
    localparam MOVE = 0, STORE = 1, BRANCH = 2;
    localparam POP = 3, PUSH = 4, STALL = 5;
    localparam STR_REZ = 6, LOAD_Y = 7, LOAD_X = 8;
    localparam ACC_OPX = 9, ACC_OPY = 10, JMP = 11;
    localparam RET = 12, RESET_CU = 13, DONE = 14;

    localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3;
    localparam S4 = 4, S5 = 5, S6 = 6, S7 = 7;
    localparam S8 = 8, S9 = 9, S10 = 10;
    localparam S11 = 11, S12 = 12, S13 = 13;
    localparam S14 = 14, S15 = 15;

    localparam SNOTHING = 16, SSTALL = 17;
    reg [4:0] state_next;

    always @(*) begin
        if(state == S0 &&
            !start)             state_next = S0;
        else if(state == S13)   state_next = S0;
        else if(state <= SSTALL) begin 
            if(opcode == 6'h00)         state_next = S13;
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
                if(reg_s) begin
                    if(acc_s)   state_next = S7;
                    else        state_next = S6;
                end 
                else begin  
                    if(acc_s)   state_next = S9;
                    else        state_next = S8;
                end
            end
            else if(opcode >= 6'h11 &&
                    opcode <= 6'h17)    state_next = S5;
            else if(opcode == 6'h18 ||
                    opcode == 6'h19)    state_next = SNOTHING;
            else if(opcode == 6'h1A ||
                    opcode == 6'h1B)    state_next = S5;
            else if(opcode == 6'h1C)    state_next = S10;
            else if(opcode == 6'hFF)    state_next = SNOTHING;
            else
                if(reg_s)   state_next = S11;
                else        state_next = S12;
        end
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
    assign control_lines[STALL] = (state == SSTALL);
    assign control_lines[STR_REZ] = (state == S5) || (state == S6) || (state == S8);
    assign control_lines[LOAD_Y] = (state == S1) || (state == S11);
    assign control_lines[LOAD_X] = (state == S2) || (state == S12);
    assign control_lines[ACC_OPY] = (state == S6) || (state == S7);
    assign control_lines[ACC_OPX] = (state == S8) || (state == S9);
    assign control_lines[JMP] = (state == S14);
    assign control_lines[RET] = (state == S15);
    assign control_lines[RESET_CU] = (state == S0);
    assign control_lines[DONE] = (state == S13);

endmodule