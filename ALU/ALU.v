module ALU(
  input [5:0] op_code,
  input [31:0] val,
  input [31:0] reg0,
  input reset,
  input move,
  input store,
  input clk,
  output reg ALU_ready,
  output reg [3:0] ALU_flags,
  output reg [31:0] rez
);

  always @(posedge reset, negedge clk) begin
    ALU_ready <= 1;
    ALU_flags <= 4'b0000;

    if (reset) begin
      rez <= 32'b0;
    end else if (move) begin
      rez <= val;
    end else if (store) begin
      rez <= reg0;
    end else begin
      case(op_code)
        6'b001010: begin // ADD
          rez <= reg0 + val;
	  ALU_flags[0] <= (rez == 32'b0); // Zero flag
          ALU_flags[1] <= (rez[31] == 1); // Negative flag
          ALU_flags[2] <= ((reg0 & val) != 0); // Carry flag
          ALU_flags[3] <= (reg0[31] == val[31] && rez[31] != reg0[31]); // Overflow flag
        end

        6'b001011: begin // SUB
          rez <= reg0 - val;
	  ALU_flags[0] <= (rez == 32'b0); // Zero flag
          ALU_flags[1] <= (rez[31] == 1); // Negative flag
          ALU_flags[2] <= (reg0 < val); // Carry flag
          ALU_flags[3] <= (reg0[31] != val[31] && rez[31] == reg0[31]); // Overflow flag
        end

        6'b001100: begin // LSR
          rez <= reg0 >> val;
	  ALU_flags[0] <= (rez == 32'b0); // Zero flag
          ALU_flags[1] <= (rez[31] == 1); // Negative flag
          ALU_flags[2] <= 0; // Carry flag
          ALU_flags[3] <= 0; // Overflow flag
        end

        6'b001101: begin // LSL
          rez <= reg0 << val;
	  ALU_flags[0] <= (rez == 32'b0); // Zero flag
          ALU_flags[1] <= (rez[31] == 1); // Negative flag
          ALU_flags[2] <= 0; // Carry flag
          ALU_flags[3] <= 0; // Overflow flag
        end

        6'b001110: begin // RSR
          rez <= (reg0 >> val) | (reg0 << (32 - val));
	  ALU_flags[0] <= (rez == 32'b0); // Zero flag
          ALU_flags[1] <= (rez[31] == 1); // Negative flag
          ALU_flags[2] <= 0; // Carry flag
          ALU_flags[3] <= 0; // Overflow flag
        end

        6'b001111: begin // RSL
          rez <= (reg0 << val) | (reg0 >> (32 - val));
	  ALU_flags[0] <= (rez == 32'b0); // Zero flag
          ALU_flags[1] <= (rez[31] == 1); // Negative flag
          ALU_flags[2] <= 0; // Carry flag
          ALU_flags[3] <= 0; // Overflow flag
        end

        6'b010100: begin // AND
          rez <= reg0 & val;
	  ALU_flags[0] <= (rez == 32'b0); // Zero flag
          ALU_flags[1] <= (rez[31] == 1); // Negative flag
          ALU_flags[2] <= 0; // Carry flag
          ALU_flags[3] <= 0; // Overflow flag
        end

        6'b010101: begin // OR
          rez <= reg0 | val;
	  ALU_flags[0] <= (rez == 32'b0); // Zero flag
          ALU_flags[1] <= (rez[31] == 1); // Negative flag
          ALU_flags[2] <= 0; // Carry flag
          ALU_flags[3] <= 0; // Overflow flag
        end

        6'b010110: begin // XOR
          rez <= reg0 ^ val;
	  ALU_flags[0] <= (rez == 32'b0); // Zero flag
          ALU_flags[1] <= (rez[31] == 1); // Negative flag
          ALU_flags[2] <= 0; // Carry flag
          ALU_flags[3] <= 0; // Overflow flag
        end

        6'b010111: begin // NOT
          rez <= ~reg0;
	  ALU_flags[0] <= (rez == 32'b0); // Zero flag
          ALU_flags[1] <= (rez[31] == 1); // Negative flag
          ALU_flags[2] <= 0; // Carry flag
          ALU_flags[3] <= 0; // Overflow flag
        end

        6'b011000: begin // CMP
	  ALU_flags[0] <= ((reg0 - val) == 32'b0); // Zero flag
          ALU_flags[1] <= ((reg0 - val) == 1); // Negative flag
          ALU_flags[2] <= (reg0 < val); // Carry flag
          ALU_flags[3] <= (reg0[31] != val[31] && rez[31] == reg0[31]); // Overflow flag
        end

        6'b011001: begin // TST
	  ALU_flags[0] <= ((reg0 & val) == 32'b0); // Zero flag
          ALU_flags[1] <= ((reg0 & val) == 1); // Negative flag
          ALU_flags[2] <= 0; // Carry flag
          ALU_flags[3] <= 0; // Overflow flag
        end

        6'b011010: begin // INC
          rez <= reg0 + 32'b1;
  	  ALU_flags[0] <= (rez == 32'b0); // Zero flag
          ALU_flags[1] <= (rez[31] == 1); // Negative flag
          ALU_flags[2] <= 0; // Carry flag
          ALU_flags[3] <= (reg0[31] != val[31] && rez[31] == reg0[31]); // Overflow flag
        end

        6'b011011: begin // DEC
          rez <= reg0 - 32'b1;
	  ALU_flags[0] <= (rez == 32'b0); // Zero flag
          ALU_flags[1] <= (rez[31] == 1); // Negative flag
          ALU_flags[2] <= 0; // Carry flag
          ALU_flags[3] <= (reg0[31] != val[31] && rez[31] == reg0[31]); // Overflow flag
        end

        default: begin
          ALU_ready <= 0;
          ALU_flags <= 4'b0000;
          rez <= 32'b0;
        end
      endcase
    end
  end
endmodule

