module ALU_tb;
    reg [15:0] A, B;   // Input operand
    reg [2:0] opcode;  // Operation code
    wire [15:0] out; // Output result
    wire Z, N, C, O;  // Flags

    ALU inst0(
        .A(A),
        .B(B),
        .opcode(opcode),
        .out(out),
        .Z(Z),
        .N(N),
        .C(C),
        .O(O)
    );

    initial begin
        A = 10;
        B = 10;
    end

    initial begin 
        opcode = 3'b0;
        #100
        opcode = 3'b1;
        #100
        opcode = 3'b1;
    end
endmodule