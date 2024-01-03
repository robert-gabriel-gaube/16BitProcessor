module tensor_register (
    input clk, reset, load,
    input [15:0] element,
    input [3:0] idx,
    output reg [143:0] tensor_out
);
    always @(posedge clk, posedge reset) begin 
        if(reset) begin 
            tensor_out = 144'b0;
        end
        else if(load) begin 
            #6;
            case (idx) 
                4'h0:   tensor_out[15:0] <= element;
                4'h1:   tensor_out[31:16] <= element;
                4'h2:   tensor_out[47:32] <= element;
                4'h3:   tensor_out[63:48] <= element;
                4'h4:   tensor_out[79:64] <= element;
                4'h5:   tensor_out[95:80] <= element;
                4'h6:   tensor_out[111:96] <= element;
                4'h7:   tensor_out[127:112] <= element;
                4'h8:   tensor_out[143:128] <= element;
            endcase
        end
    end

endmodule