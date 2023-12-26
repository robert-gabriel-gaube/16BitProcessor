module ALU_tb;
    reg [15:0] A, B;   // Input operand
    reg [5:0] opcode;  // Operation code
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
        A = 16'hFFFF;
        B = 16'h0001;
        #100
        A = 16'hFFFE;
        B = 16'h0001;
    end

    initial begin 
        // 1. ADD
        opcode = 6'b001010;
        A = 16'hFFFF;
        B = 16'h0001;
        // out = 16'h0000; ZCO

        #100

        // 2. SUB
        opcode = 6'b001011;
        A = 16'hFFFE;
        B = 16'h0001;
        // out = 16'hFFFD; NC

        #100

        // 3. LSR
        opcode = 6'b001100;
        A = 16'h000F;
        B = 16'h0004;
        // out = 16'0000; Z

        #100

        // 4. LSL
        opcode = 6'b001101;
        A = 16'h3000;
        B = 16'h0002;
        // out = 16'hC000; N

        #100

        // 5. RSR
        opcode = 6'b001110;
        A = 16'h000B;
        B = 16'h0002;
        // out = 16'hC002; N

        #100

        // 6. RSL
        opcode = 6'b001111;
        A = 16'hB000;
        B = 16'h0002;
        // out = 16'hC002; N

        #100

        // 7. MOV
        opcode = 6'b010000;
        A = 16'h1234;
        B = 16'h4321;
        // out = 16'h4321;

        #100

        // 8. MUL
        opcode = 6'b010001;
        A = 16'h0002;
        B = 16'h0004;
        // out = 16'h0008;

        #100

        // 8. DIV
        opcode = 6'b010010;
        A = 16'h000A;
        B = 16'h0002;
        // out = 16'h0005;

        #100

        // 9. MOD
        opcode = 6'b010011;
        A = 16'h0009;
        B = 16'h0002;
        // out = 16'h0001;

        #100

        // 10. AND
        opcode = 6'b010100;
        A = 16'hAAAA;
        B = 16'hAA22;
        // out = 16'hAA22; N

        #100

        // 11. OR
        opcode = 6'b010101;
        A = 16'h8888;
        B = 16'h2222;
        // out = 16'hAAAA; N

        #100

        // 12. XOR
        opcode = 6'b010110;
        A = 16'hFFFF;
        B = 16'h8888;
        // out = 16'h7777;

        #100

        // 13. NOT
        opcode = 6'b010111;
        A = 16'hFF22;
        B = 16'h0000;
        // out = 16'h00DD;

        #100

        // 14. CMP
        opcode = 6'b011000;
        A = 16'hFFFE;
        B = 16'h0001;
        // out = 16'hFFFD; NC

        #100

        // 15. TST 
        opcode = 6'b011001;
        A = 16'hAAAA;
        B = 16'hAA22;
        // out = 16'hAA22; N

        #100

        // 16. INC
        opcode = 6'b011010;
        A = 16'h000F;
        B = 16'h0000;
        // out = 16'h0010; C

        #100

        // 17. DEC
        opcode = 6'b011011;
        A = 16'h000A;
        B = 16'h0000;
        // out = 16'h0009; C

        #100
        opcode = 6'b001101;
    end
endmodule