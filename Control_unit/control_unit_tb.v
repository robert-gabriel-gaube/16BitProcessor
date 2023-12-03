module control_unit_tb;
    reg [5:0] opcode;
    reg reg_s, acc_s, start, reset, clk, ALU_ready;
    reg [3:0] flags;
    wire move, store, branch, pop, push;
    wire stall, str_rez, load_y, load_x;
    wire acc_opx, acc_opy, done, reset_cu;
    wire [3:0] state;

    control_unit cu (
        .opcode(opcode),
        .reg_s(reg_s),
        .acc_s(acc_s),
        .ALU_ready(ALU_ready),
        .start(start),
        .reset(reset),
        .clk(clk),
        .flags(flags),
        .move(move),
        .store(store),
        .branch(branch),
        .pop(pop),
        .push(push),
        .stall(stall),
        .str_rez(str_rez),
        .load_y(load_y),
        .load_x(load_x),
        .acc_opx(acc_opx),
        .acc_opy(acc_opy),
        .done(done),
        .reset_cu(reset_cu),
        .state(state)
    );

    localparam CLOCK_CYCLES = 65, CLOCK_PERIOD = 100;

    initial begin 
        clk = 0;
        repeat(CLOCK_CYCLES * 2)
            #(CLOCK_PERIOD / 2) clk = ~clk;
    end

    initial begin 
        reset = 1;
        start = 1;
        #25 reset = 0;
        #50 start = 0;
    end

    initial begin
        // 1. LDA into X
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h04;
        flags = 4'h0;
        // state = 2, load_x = 1

        #100

        // 2. LDA into Y
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h06;
        flags = 4'h0;
        // state = 1, load_y = 1

        #100 
        
        // 3. STA from X
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h08;
        flags = 4'h0;
        // state = 3, store = 1

        #100 
        
        // 4. STA from Y
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h0A;
        flags = 4'h0;
        // state = 3, store = 1

        #100 
        
        // 5. BRZ with Z = 0
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h0C;
        flags = 4'h0;
        // state = 14

        #100 
        
        // 6. BRZ with Z = 1
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h0C;
        flags = 4'h1;
        // state = 4, branch = 1

        #100 
        
        // 7. BRN with N = 0
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h10;
        flags = 4'h0;
        // state = 14
        
        #100 
        
        // 8. BRN with N = 1
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h10;
        flags = 4'h2;
        // state = 4, branch = 1

        #100 
        
        // 9. BRC with C = 0
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h14;
        flags = 4'h0;
        // state = 14

        #100 
        
        // 10. BRC with C = 1
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h14;
        flags = 4'h4;
        // state = 4, branch = 1

        #100 
        
        // 11. BRO with O = 0
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h18;
        flags = 4'h0;
        // state = 14

        #100 
        
        // 12. BRO with O = 1
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h10;
        flags = 4'h8;
        // state = 4, branch = 1

        #100 
        
        // 13. BRA
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h1C;
        flags = 4'h0;
        // state = 4, branch = 1

        #100 
        
        // 14. JMP
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h20;
        flags = 4'h0;
        // state = 14

        #100 
        
        // 15. RET
        ALU_ready = 0;
        {opcode, reg_s, acc_s} = 8'h24;
        flags = 4'h0;
        // state = 14

        #100 
        
        // 16. ADD with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h28;
        flags = 4'h0;
        // state = 5

        #100 
        
        // 17. ADD with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h2A;
        flags = 4'h0;
        // state = 5
        
        #100 
        
        // 18. SUB with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h2C;
        flags = 4'h0;
        // state = 5

        #100 
        
        // 19. SUB with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h2E;
        flags = 4'h0;
        // state = 5

        #100 
        
        // 20. LSR with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h30;
        flags = 4'h0;
        // state = 5

        #100 
        
        // 21. LSR with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h32;
        flags = 4'h0;
        // state = 5

        #100

        // 22. LSL with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h34;
        flags = 4'h0;
        // state = 5

        #100

        // 23. LSL with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h36;
        flags = 4'h0;
        // state = 5

        #100

        // 24. RSR with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h38;
        flags = 4'h0;
        // state = 5

        #100

        // 25. RSR with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h3A;
        flags = 4'h0;
        // state = 5

        #100

        // 25. RSL with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h3C;
        flags = 4'h0;
        // state = 5

        #100

        // 26. RSL with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h3E;
        flags = 4'h0;
        // state = 5

        #100

        // 27. MOV immediate into X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h40;
        flags = 4'h0;
        // state = 8, acc_opx = 1, move = 1, str_rez = 1

        #100

        // 28. MOV immediate into Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h42;
        flags = 4'h0;
        // state = 6, acc_opy = 1, move = 1, str_rez = 1

        #100

        // 29. MOV acc into X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h41;
        flags = 4'h0;
        // state = 9, acc_opx = 1

        #100

        // 30. MOV acc into Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h43;
        flags = 4'h0;
        // state = 7, acc_opy = 1

        #100

        // 31. MUL with X
        {opcode, reg_s, acc_s} = 8'h44;
        flags = 4'h0;
        // state = 15, stall = 1

        #100
        // 32. Stall
        ALU_ready = 0;
        // state = 15, stall = 1

        #100
        
        // 33. MUL with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h46;
        flags = 4'h0;
        // state = 15, stall = 1

        #100

        // 34. Stall
        ALU_ready = 0;
        // state = 15, stall = 1

        #100

        // 35. DIV with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h48;
        flags = 4'h0;
        // state = 15, stall = 1

        #100

        // 36. Stall
        ALU_ready = 0;
        // state = 15, stall = 1

        #100
        
        // 37. DIV with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h4A;
        flags = 4'h0;
        // state = 15, stall = 1

        #100

        // 38. Stall
        ALU_ready = 0;
        // state = 15, stall = 1

        #100
        
        // 39. MOD with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h4C;
        flags = 4'h0;
        // state = 15, stall = 1

        #100

        // 40. Stall
        ALU_ready = 0;
        // state = 15, stall = 1

        #100
        
        // 41. MOD with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h4E;
        flags = 4'h0;
        // state = 15, stall = 1

        #100

        // 42. Stall
        ALU_ready = 0;
        // state = 15, stall = 1

        #100
        
        // 43. AND with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h50;
        flags = 4'h0;
        // state = 5, str_rez = 1

        #100
        
        // 44. AND with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h52;
        flags = 4'h0;
        // state = 5, str_rez = 1

        #100
        
        // 45. OR with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h54;
        flags = 4'h0;
        // state = 5, str_rez = 1

        #100
        
        // 46. OR with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h56;
        flags = 4'h0;
        // state = 5, str_rez = 1

        #100
        
        // 47. XOR with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h58;
        flags = 4'h0;
        // state = 5, str_rez = 1

        #100
        
        // 48. XOR with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h5A;
        flags = 4'h0;
        // state = 5, str_rez = 1

        #100
        
        // 49. NOT with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h5C;
        flags = 4'h0;
        // state = 5, str_rez = 1

        #100
        
        // 50. NOT with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h5E;
        flags = 4'h0;
        // state = 5, str_rez = 1

        #100
        
        // 51. CMP with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h60;
        flags = 4'h0;
        // state = 14

        #100
        
        // 52. CMP with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h62;
        flags = 4'h0;
        // state = 14

        #100
        
        // 53. TST with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h64;
        flags = 4'h0;
        // state = 14

        #100
        
        // 54. TST with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h66;
        flags = 4'h0;
        // state = 14

        #100
        
        // 55. INC with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h68;
        flags = 4'h0;
        // state = 5, str_rez = 1

        #100
        
        // 56. INC with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h6A;
        flags = 4'h0;
        // state = 5, str_rez = 1

        #100
        
        // 57. DEC with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h6C;
        flags = 4'h0;
        // state = 5, str_rez = 1

        #100
        
        // 58. DEC with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h6E;
        flags = 4'h0;
        // state = 5, str_rez = 1

        #100
        
        // 59. PSH with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h70;
        flags = 4'h0;
        // state = 10, store = 1, push = 1

        #100
        
        // 60. PSH with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h72;
        flags = 4'h0;
        // state = 10, store = 1, push = 1

        #100
        
        // 61. POP with X
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h74;
        flags = 4'h0;
        // state = 12, load_x = 1, pop = 1

        #100

        // 62. POP with Y
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h76;
        flags = 4'h0;
        // state = 11, load_y = 1, pop = 1

        #100

        // 63. HLT
        ALU_ready = 1;
        {opcode, reg_s, acc_s} = 8'h00;
        flags = 4'h0;
        // state = 13, done = 1

        #100 ALU_ready = 1;
        // state = 0, reset_cu = 1
    end
endmodule
