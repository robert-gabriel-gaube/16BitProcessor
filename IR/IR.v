module IR (
    input wire clk,
    input wire [15:0] instr,
    output reg [5:0] op_code,
    output reg reg_s,
    output reg acc_s,
    output reg [7:0] val
);

always @(posedge clk) begin
    op_code <= instr[15:10]; // Extrage codul operației din instrucțiune
    reg_s <= instr[9]; // Extrage bitul de selectare a registrului
    acc_s <= instr[8]; // Extrage bitul de selectare a acumulatorului
    val <= instr[7:0]; // Extrage valoarea din instrucțiune
end

endmodule
