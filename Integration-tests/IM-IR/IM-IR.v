module IMxIR;
    reg clk, en_write;
    reg [15:0] data_in;
    reg [9:0] instr_address;
    wire [15:0] data_out;
    wire [5:0] op_code;
    wire [7:0] val;
    wire reg_s, acc_s;

    localparam CLOCK_CYCLES = 10, CLOCK_PERIOD = 100;

    IM inst2(
        .clk(clk),
        .en_write(en_write),
        .address(instr_address),
        .data_in(data_in),
        .data_out(data_out)
    );

    IR inst3(
        .clk(clk),
        .instr(data_out),
        .op_code(op_code),
        .reg_s(reg_s),
        .acc_s(acc_s),
        .val(val)
    );

    initial begin 
        clk = 0;
        repeat(CLOCK_CYCLES * 2)
            #(CLOCK_PERIOD / 2) clk = ~clk;
    end

    initial begin 
        en_write = 1;
        #400 en_write = 0;
    end

    initial begin
        instr_address = 0;
        data_in = 16'b0000010000001101;
        #100
        instr_address = 1;
        data_in = 16'b0010100000001100;
        #100
        instr_address = 2;
        data_in = 16'b0010110000010100;
        #100
        instr_address = 3;
        data_in = 16'b0000100000001101;
        #100 
        instr_address = 0;
        #100
        instr_address = 1;
        #100
        instr_address = 2;
        #100
        instr_address = 3;
        
        
    end

endmodule