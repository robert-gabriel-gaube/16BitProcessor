module sign_extend_tb;
reg acc_s;
reg [7:0] val;
reg acc_op;
wire [15:0] out;  

sign_extend inst(
    .acc_s(acc_s),
    .val(val),
    .acc_op(acc_op),
    .out(out)
    );
    
    
initial begin   
    acc_s = 0;
    val = 8'b10001010;
    acc_op = 0;
    #100;
    
    acc_s = 0;
    val = 8'b10001010;
    acc_op = 1;
    #100;
    
    acc_s = 1;
    val = 8'b00001010;
    acc_op = 0;
    #100;
    
    acc_s = 1;
    val = 8'b00001010;
    acc_op = 1;
    #100;     
end
endmodule  