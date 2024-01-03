module tensor_accumulator (
    input [143:0] mxu_out,
    input str_rez, clk, reset,
    output reg [143:0] acc_out
);

    always @(posedge clk, posedge reset) begin 
        if(reset)           acc_out <= 144'b0;
        else if(str_rez)    acc_out <= mxu_out;
    end

endmodule