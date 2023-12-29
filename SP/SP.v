module SP(
    input wire pop,
    input wire push,
    input wire reset,
    input wire [15:0] new_val,
    input wire clk,
    output reg [15:0] out
);
    always @(posedge reset, posedge clk) begin 
        #2;
        if(reset) out <= 16'hFFFF;
        else if(push == 1) out <= new_val;
    end

    always @(negedge clk) begin
        if (pop == 1) out <= new_val;
    end

endmodule
