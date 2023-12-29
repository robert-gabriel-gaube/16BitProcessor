module register(
    input reset, clk, acc_op, load,
    input [15:0]acc_val,
    input [15:0]data_val,
    output reg [15:0]out
);

    always@(posedge reset, posedge clk)
    begin
        if(reset) out <= 16'h0000;
        else begin 
            #5;
            if(acc_op) out <= acc_val;
            else if(load) begin 
                #1;
                out <= data_val;
            end 
        end 
    end
endmodule