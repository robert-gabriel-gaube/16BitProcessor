module ALU(
    input store,
    input [15:0] A, B, 
    input [5:0] opcode,  
    output reg [15:0] out,
    output reg [3:0] flags
);
    localparam Z = 0, N = 1, C = 2, O = 3;
    reg [16:0] temp;
    reg [31:0] temp_mul;

    always @* begin
        if(store) out = A;
        else begin 
            case (opcode)
                6'h0A: begin // ADD
                    temp = A + B;
                    out = temp[15:0];
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = ((A & B) != 0);
                    flags[O] = temp[16];
                end

                6'h0B, 6'h18: begin // SUB, CMP
                    temp = A - B;
                    out = temp[15:0];
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = ((~A & B) != 0);
                    flags[O] = temp[16];
                end

                6'h0C: begin // LSR
                    out = A >> B;
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = 0;
                    flags[O] = 0;
                end

                6'h0D: begin // LSL
                    out = A << B;
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = 0;
                    flags[O] = 0;
                end

                6'h0E: begin // RSR
                    out = (A >> B) | (A << (16 - B));
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = 0;
                    flags[O] = 0;
                end

                6'h0F: begin // RSL
                    out = (A << B) | (A >> (16 - B));
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = 0;
                    flags[O] = 0;
                end

                6'h10: begin // MOV
                    out = B;
                    flags = 4'b0;
                end

                6'h11: begin // MUL
                    temp_mul = A * B;
                    out = temp_mul[15:0];
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = 0;
                    flags[O] = ((temp_mul >> 16) != 0);
                end

                6'h12: begin // DIV
                    out = A / B;
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = 0;
                    flags[O] = 0;
                end

                6'h13: begin // MOD
                    out = A % B;
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = 0;
                    flags[O] = 0;
                end

                6'h14, 6'h19: begin // AND, TST
                    out = A & B;
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = 0;
                    flags[O] = 0;
                end

                6'h15: begin // OR
                    out = A | B;
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = 0;
                    flags[O] = 0;
                end

                6'h16: begin // XOR
                    out = A ^ B;
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = 0;
                    flags[O] = 0;
                end

                6'h17: begin // NOT
                    out = ~A;
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = 0;
                    flags[O] = 0;
                end

                6'h1A: begin // INC
                    out = A + 1;
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = A[0];
                    flags[O] = (A == 16'hFFFF);
                end

                6'h1B: begin // DEC
                    out = A - 1;
                    flags[Z] = (out == 0);
                    flags[N] = out[15];
                    flags[C] = ~A[0];
                    flags[O] = (A == 16'h0000);
                end
            endcase
        end
    end

endmodule