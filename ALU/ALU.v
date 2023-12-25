module ALU(input [15:0] A, B,   // Input operands
           input [2:0] opcode,  // Operation code
           output reg [15:0] out,// Output result
           output reg Z, N, C, O // Flags
);

always @(A, B, opcode) begin
    case (opcode)
        3'b000: begin // Addition
            out = A + B;
            Z = (out == 0);
            N = (out < 0);
            C = (out < A || out < B);
            O = (A[15] == B[15] && A[15] != out[15]);
        end

        3'b001: begin // Subtraction
            out = A - B;
            Z = (out == 0);
            N = (out < 0);
            C = (A < B);
            O = (A[15] != B[15] && A[15] != out[15]);
        end

        // Add cases for multiplication and division

        default: begin
            // Handle unsupported opcode
            // You may choose to set flags accordingly
        end
    endcase
end

endmodule