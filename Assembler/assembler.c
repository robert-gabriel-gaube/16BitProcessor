#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include <stdlib.h>

// instructions
typedef enum instructions
{
    HLT = 0,
    LDA,
    STA,
    BRZ,
    BRN,
    BRC,
    BRO,
    BRA,
    JMP,
    RET,
    ADD,
    SUB,
    LRS,
    LSL,
    RSR,
    RSL,
    MOV,
    MUL,
    DIV,
    MOD,
    AND,
    OR,
    XOR,
    NOT,
    CMP,
    TST,
    INC,
    DEC,
    PSH,
    POP,
    UNKNOWN
} instructions;
// Function to convert string to enum
instructions str2enum(char *str)
{
    if (strcmp(str, "HLT") == 0)
        return HLT;
    if (strcmp(str, "LDA") == 0)
        return LDA;
    if (strcmp(str, "STA") == 0)
        return STA;
    if (strcmp(str, "BRZ") == 0)
        return BRZ;
    if (strcmp(str, "BRN") == 0)
        return BRN;
    if (strcmp(str, "BRC") == 0)
        return BRC;
    if (strcmp(str, "BRO") == 0)
        return BRO;
    if (strcmp(str, "BRA") == 0)
        return BRA;
    if (strcmp(str, "JMP") == 0)
        return JMP;
    if (strcmp(str, "RET") == 0)
        return RET;
    if (strcmp(str, "ADD") == 0)
        return ADD;
    if (strcmp(str, "SUB") == 0)
        return SUB;
    if (strcmp(str, "LRS") == 0)
        return LRS;
    if (strcmp(str, "LSL") == 0)
        return LSL;
    if (strcmp(str, "RSR") == 0)
        return RSR;
    if (strcmp(str, "RSL") == 0)
        return RSL;
    if (strcmp(str, "MOV") == 0)
        return MOV;
    if (strcmp(str, "MUL") == 0)
        return MUL;
    if (strcmp(str, "DIV") == 0)
        return DIV;
    if (strcmp(str, "MOD") == 0)
        return MOD;
    if (strcmp(str, "AND") == 0)
        return AND;
    if (strcmp(str, "OR") == 0)
        return OR;
    if (strcmp(str, "XOR") == 0)
        return XOR;
    if (strcmp(str, "NOT") == 0)
        return NOT;
    if (strcmp(str, "CMP") == 0)
        return CMP;
    if (strcmp(str, "TST") == 0)
        return TST;
    if (strcmp(str, "INC") == 0)
        return INC;
    if (strcmp(str, "DEC") == 0)
        return DEC;
    if (strcmp(str, "PSH") == 0)
        return PSH;
    if (strcmp(str, "POP") == 0)
        return POP;

    return UNKNOWN;
}

// logical values of X and Y for LDA, STA instructions

// print binary function
void printBinary(unsigned int num, FILE *out)
{
    for (int i = 15; i >= 0; --i)
    {
        fprintf(out, "%d", (num >> i) & 1);
    }
    fprintf(out, "\n");
}

int lda_or_alu_instruction(instructions i, int reg, int addr_or_imediate)
{

    return (i << 10) | (reg << 9) | (addr_or_imediate);
}

int br_instruction(instructions i, int reg)
{
    return i << 10 | reg;
}

int mov_instruction(instructions i, int reg, int acc, int address)
{
    return i << 10 | reg << 9 | acc << 8 | address;
}

void assembler(char *line, FILE *out)
{
    char temp[50];
    char arg[20];
    char str_reg[5];
    int reg = 0, addr_or_imediate = 0, i;
    instructions instruction;

    sscanf(line, "%s ", temp);
    // litere mari
    for (i = 0; temp[i]; i++)
    {
        temp[i] = toupper(temp[i]);
    }
    temp[i] = '\0';
    //  instruction from strig to instruction type
    instruction = str2enum(temp);
    if (instruction == HLT) // HLT instruction
        printBinary(HLT, out);
    else if ((instruction > HLT && instruction < BRZ) || (instruction > RET && instruction != MOV)) // LDA or ALU instruction
    {
        if (instruction == NOT || instruction >= INC)
        {
            addr_or_imediate = 0;
            sscanf(line, "%*s %s,", str_reg);
            str_reg[1] = '\0';
        }
        else
        {
            sscanf(line, "%*s %s, ", str_reg);
            str_reg[1] = '\0';
            i = strlen(temp) + strlen(str_reg) + 3;
            line += i;
            addr_or_imediate = atoi(line);
        }
        if (strcmp(str_reg, "X") == 0)
            reg = 0;
        else if (strcmp(str_reg, "Y") == 0)
            reg = 1;

        printBinary(lda_or_alu_instruction(instruction, reg, addr_or_imediate), out);
    }
    else if (instruction == MOV) // MOV instruction
    {
        sscanf(line, "%*s %s, ", str_reg);
        str_reg[1] = '\0';
        i = strlen(temp) + strlen(str_reg) + 3;

        line += i;
        strcpy(arg, line);
        if (strcmp(str_reg, "X") == 0)
            reg = 0;
        else if (strcmp(str_reg, "Y") == 0)
            reg = 1;

        // Check if the source is "A" to set the accumulator
        if (strcmp(arg, "A") == 0)
        {
            printBinary(mov_instruction(instruction, reg, 1, 0), out);
        }
        else
        {
            sscanf(arg, "%d", &addr_or_imediate);
            printBinary(mov_instruction(instruction, reg, 0, addr_or_imediate), out);
        }
    }
    else // BR instruction
    {

        if (instruction == RET)
            printBinary(br_instruction(instruction, 0), out);
        else
        {
            sscanf(line, "%*s %s", arg);
            addr_or_imediate = atoi(arg);
            printBinary(br_instruction(instruction, addr_or_imediate), out);
        }
    }
}

int main(int argc, char *argv[])
{
    if (argc != 2)
    {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }
    FILE *file = fopen(argv[1], "r");
    FILE *out = fopen("out.txt", "w");
    if (file == NULL)
    {
        fprintf(stderr, "Error opening file.\n");
        return 1;
    }
    if (out == NULL)
    {
        fprintf(stderr, "Error opening file.\n");
        return 1;
    }

    char line[50];

    while (fgets(line, sizeof(line), file) != NULL)
    {
        // Remove newline character at the end of the line
        size_t len = strlen(line);
        if (len > 0 && line[len - 1] == '\n')
        {
            line[len - 1] = '\0';
        }
        assembler(line, out);
    }

    fclose(file);
    fclose(out);
    return 0;
}
