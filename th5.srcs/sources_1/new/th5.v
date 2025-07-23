`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2025 10:26:47
// Design Name: 
// Module Name: th5
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// Tiny Processor Full Implementation with All Operations

module Instruction_ROM (
    input [3:0] PC,
    output reg [7:0] instruction
);
    reg [7:0] ROM [0:15];

    initial begin
        // Sample program
        ROM[0]  = 8'b1001_0001; // MOV ACC, R1
        ROM[1]  = 8'b0110_0001; // XRA R1 (clears ACC)
        ROM[2]  = 8'b0001_0101; // ADD R5
        ROM[3]  = 8'b0010_0110; // SUB R6
        ROM[4]  = 8'b0011_0010; // MUL R2
        ROM[5]  = 8'b0101_0011; // AND R3
        ROM[6]  = 8'b0111_0100; // CMP R4
        ROM[7]  = 8'b0000_0001; // LSL
        ROM[8]  = 8'b0000_0010; // LSR
        ROM[9]  = 8'b0000_0011; // CIR
        ROM[10] = 8'b0000_0100; // CIL
        ROM[11] = 8'b0000_0101; // ASR
        ROM[12] = 8'b0000_0110; // INC
        ROM[13] = 8'b0000_0111; // DEC
        ROM[14] = 8'b1010_0111; // MOV R7, ACC
        ROM[15] = 8'b1111_1111; // HLT
    end

    always @(*) begin
        instruction = ROM[PC];
    end
endmodule

module Control_Unit (
    input [7:0] instruction,
    output reg [3:0] opcode,
    output reg [3:0] reg_addr
);
    always @(*) begin
        opcode    = instruction[7:4];
        reg_addr  = instruction[3:0];
    end
endmodule

module Register_File (
    input clk,
    input we,
    input [3:0] read_addr,
    input [3:0] write_addr,
    input [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] regs [0:15];

    always @(posedge clk) begin
        if (we)
            regs[write_addr] <= data_in;
    end

    always @(*) begin
        data_out = regs[read_addr];
    end
endmodule

module ALU (
    input [3:0] opcode,
    input [7:0] ACC,
    input [7:0] RegIn,
    output reg [7:0] result,
    output reg C_B,
    output reg [7:0] EXT
);
    always @(*) begin
        C_B = 0;
        EXT = 0;
        case (opcode)
            4'b0001: {C_B, result} = ACC + RegIn; // ADD
            4'b0010: {C_B, result} = ACC - RegIn; // SUB
            4'b0011: {EXT, result} = ACC * RegIn; // MUL
            4'b0101: result = ACC & RegIn; // AND
            4'b0110: result = ACC ^ RegIn; // XRA
            4'b0111: begin // CMP
                C_B = (ACC < RegIn) ? 1 : 0;
            end
            default: result = ACC;
        endcase
    end
endmodule

module TinyProcessor (
    input clk,
    input reset
);
    reg [3:0] PC;
    reg [7:0] ACC, EXT;
    reg C_B;

    wire [7:0] instruction;
    wire [3:0] opcode, reg_addr;
    wire [7:0] reg_data;
    wire [7:0] alu_out, ext_out;
    wire alu_CB;

    reg write_enable;
    reg [3:0] write_reg;

    Instruction_ROM rom(PC, instruction);
    Control_Unit cu(instruction, opcode, reg_addr);
    Register_File rf(clk, write_enable, reg_addr, write_reg, ACC, reg_data);
    ALU alu(opcode, ACC, reg_data, alu_out, alu_CB, ext_out);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            PC <= 0;
            ACC <= 0;
            EXT <= 0;
            C_B <= 0;
        end else begin
            write_enable <= 0;
            case (opcode)
                4'b0000: begin
                    case (instruction[3:0])
                        4'b0000: ; // NOP
                        4'b0001: ACC <= ACC << 1; // LSL
                        4'b0010: ACC <= ACC >> 1; // LSR
                        4'b0011: ACC <= {ACC[0], ACC[7:1]}; // CIR
                        4'b0100: ACC <= {ACC[6:0], ACC[7]}; // CIL
                        4'b0101: ACC <= {1'b1, ACC[7:1]}; // ASR
                        4'b0110: begin
                            ACC <= ACC + 1;
                            C_B <= (ACC == 8'hFF);
                        end
                        4'b0111: begin
                            ACC <= ACC - 1;
                            C_B <= (ACC == 8'h00);
                        end
                    endcase
                end
                4'b0001, 4'b0010, 4'b0101, 4'b0110, 4'b0011, 4'b0111: begin
                    ACC <= alu_out;
                    EXT <= ext_out;
                    C_B <= alu_CB;
                end
                4'b1001: ACC <= reg_data; // MOV ACC, Ri
                4'b1010: begin
                    write_enable <= 1;
                    write_reg <= reg_addr;
                end
                4'b1000: if (C_B == 1) PC <= reg_addr; // BR addr
                4'b1011: PC <= reg_addr; // RET addr
                4'b1111: PC <= PC; // HLT
            endcase
            if (opcode != 4'b1111 && !(opcode == 4'b1000 && C_B == 1) && opcode != 4'b1011)
                PC <= PC + 1;
        end
    end
endmodule