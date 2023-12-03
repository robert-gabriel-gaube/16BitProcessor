module PCxIMxIR;
    reg clk, reset, branch, stall, en_write;
    reg [9:0] br_address;
    reg [15:0] data_in;
    wire [9:0] instr_address, adder_input;
    wire [15:0] data_out;
    wire [5:0] op_code;
    wire [7:0] val;
    wire reg_s, acc_s;

    localparam CLOCK_CYCLES = 100, CLOCK_PERIOD = 100;

    IR inst3(
        .clk(clk),
        .instr(data_out),
        .op_code(op_code),
        .reg_s(reg_s),
        .acc_s(acc_s),
        .val(val)
    );

    PC_adder inst0(
        .in(instr_address),
        .out(adder_input)
    );
    
    PC inst1(
        .clk(clk),
        .reset(reset),
        .branch(branch),
        .stall(stall),
        .br_address(br_address),
        .adder_input(adder_input),
        .instr_address(instr_address)
    );

    IM inst2(
        .clk(clk),
        .en_write(en_write),
        .address(instr_address),
        .data_in(data_in),
        .data_out(data_out)
    );

    


    initial begin 
        clk = 0;
        repeat(CLOCK_CYCLES * 2)
            #(CLOCK_PERIOD / 2) clk = ~clk;
    end

    initial begin 
        reset = 1;
        en_write = 1;
        #25 reset = 0;
        #3275 reset = 1;
        en_write = 0;
        #25 reset = 0;
    end

    initial begin 
        stall = 0;
        branch = 0;
        br_address = 10'b0;
    end

    initial begin
        data_in = 16'b0000010000001101;
        #100
        data_in = 16'b0010100000001100;
        #100
        data_in = 16'b0010110000010100;
        #100
        data_in = 16'b0000100000001101;
        #100
        data_in = 16'b0000010000001101;
        #100
        data_in = 16'b0010100000001100;
        #100
        data_in = 16'b0010110000010100;
        #100
        data_in = 16'b0000100000001101;
        #100
        data_in = 16'b0000010000001101;
        #100
        data_in = 16'b0010100000001100;
        #100
        data_in = 16'b0010110000010100;
        #100
        data_in = 16'b0000100000001101;
        #100
        data_in = 16'b0000010000001101;
        #100
        data_in = 16'b0010100000001100;
        #100
        data_in = 16'b0010110000010100;
        #100
        data_in = 16'b0000100000001101;
        #100
        data_in = 16'b0000010000001101;
        #100
        data_in = 16'b0010100000001100;
        #100
        data_in = 16'b0010110000010100;
        #100
        data_in = 16'b0000100000001101;
        #100
        data_in = 16'b0000010000001101;
        #100
        data_in = 16'b0010100000001100;
        #100
        data_in = 16'b0010110000010100;
        #100
        data_in = 16'b0000100000001101;
        #100
        data_in = 16'b0000010000001101;
        #100
        data_in = 16'b0010100000001100;
        #100
        data_in = 16'b0010110000010100;
        #100
        data_in = 16'b0000100000001101;
        #100
        data_in = 16'b0000010000001101;
        #100
        data_in = 16'b0010100000001100;
        #100
        data_in = 16'b0010110000010100;
        #100
        data_in = 16'b0000100000001101;
        #100
        data_in = 16'b0000000000000000;
    end

endmodule