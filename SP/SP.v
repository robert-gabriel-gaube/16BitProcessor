module SP(
    input wire pop,
    input wire push,
    input wire reset,
    input wire [15:0] new_val,
    input wire clk,
    output reg [15:0] out
);

    always @(posedge clk) begin
        if (reset) begin
            out <= 16'hFFFF;
        end else begin
            if (pop == 1) begin
                out <= new_val;
            end else if (push == 1) begin
                out <= new_val;
            end
        end
    end

endmodule
