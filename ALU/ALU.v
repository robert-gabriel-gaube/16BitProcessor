module ALU(input [15:0] A, B, 
           input [5:0] opcode,  
           output reg [15:0] out,
           output reg Z, N, C, O 
);

reg [16:0] temp;
reg [31:0] temp_mul;

always @(*) begin
    case (opcode)
        6'h0A: begin // ADD
            temp = A + B;
            out = temp[15:0];
            Z = (out == 0);
            N = out[15];
            C = ((A & B) != 0);
            O = temp[16];
        end

        6'h0B, 6'h18: begin // SUB, CMP
            temp = A - B;
            out = temp[15:0];
            Z = (out == 0);
            N = out[15];
            C = ((~A & B) != 0);
            O = temp[16];
        end

        6'h0C: begin // LSR
            out = A >> B;
            Z = (out == 0);
            N = out[15];
            C = 0;
            O = 0;
        end

        6'h0D: begin // LSL
            out = A << B;
            Z = (out == 0);
            N = out[15];
            C = 0;
            O = 0;
        end

        6'h0E: begin // RSR
            out = (A >> B) | (A << (16 - B));
            Z = (out == 0);
            N = out[15];
            C = 0;
            O = 0;
        end

        6'h0F: begin // RSL
            out = (A << B) | (A >> (16 - B));
            Z = (out == 0);
            N = out[15];
            C = 0;
            O = 0;
        end

        6'h10: begin // MOV
            out = B;
            {Z, N, C, O} = 4'b0;
        end

        6'h11: begin // MUL
            temp_mul = A * B;
            out = temp_mul[15:0];
            Z = (out == 0);
            N = out[15];
            C = 0;
            O = ((temp_mul >> 16) != 0);
        end

        6'h12: begin // DIV
            out = A / B;
            Z = (out == 0);
            N = out[15];
            C = 0;
            O = 0;
        end

        6'h13: begin // MOD
            out = A % B;
            Z = (out == 0);
            N = out[15];
            C = 0;
            O = 0;
        end

        6'h14, 6'h19: begin // AND, TST
            out = A & B;
            Z = (out == 0);
            N = out[15];
            C = 0;
            O = 0;
        end

        6'h15: begin // OR
            out = A | B;
            Z = (out == 0);
            N = out[15];
            C = 0;
            O = 0;
        end

        6'h16: begin // XOR
            out = A ^ B;
            Z = (out == 0);
            N = out[15];
            C = 0;
            O = 0;
        end

        6'h17: begin // NOT
            out = ~A;
            Z = (out == 0);
            N = out[15];
            C = 0;
            O = 0;
        end

        6'h1A: begin // INC
            out = A + 1;
            Z = (out == 0);
            N = out[15];
            C = A[0];
            O = (A == 16'hFFFF);
        end

        6'h1B: begin // DEC
            out = A - 1;
            Z = (out == 0);
            N = out[15];
            C = ~A[0];
            O = (A == 16'h0000);
        end

        default: begin
            // Handle unsupported opcode
            // You may choose to set flags accordingly
        end
    endcase
end

endmodule