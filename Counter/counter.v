module counter (
    input clk, reset, enable, 
    output reg [3:0] counter_out
);
    always @(posedge clk, posedge reset) begin
        if(reset)       counter_out <= 9;
        else if(enable) begin 
            if(counter_out == 9)    counter_out <= 0;
            else                    counter_out <= counter_out + 1;
        end
    end

endmodule