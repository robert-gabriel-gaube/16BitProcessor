module INC_DEC_SP(
    input pop,
    input [15:0] sp,
    output [15:0] val
);
    assign val = (pop == 1) ? (sp + 1) : (sp - 1);

endmodule

module SP(
    input pop, push, reset, clk,
    input wire [15:0] new_val,
    output reg [15:0] out
);
    always @(posedge reset, posedge clk) begin 
        #4;
        if(reset)           out <= 16'hFFFF;
        else if(push == 1)  out <= new_val;
    end

    always @(negedge clk) begin
        if (pop == 1)       out <= new_val;
    end

endmodule
