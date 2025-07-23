`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.04.2025 10:30:09
// Design Name: 
// Module Name: th5_tb
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


module TinyProcessor_tb;

    reg clk;
    reg reset;

    // Instantiate the processor
    TinyProcessor uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation
    always #5 clk = ~clk; // 10ns clock period

    initial begin
        clk = 0; reset = 1;
        #1;
        // Preload values directly
        uut.rf.regs[0]  = 8'd10;
        uut.rf.regs[1]  = 8'd5;    // R1
        uut.rf.regs[2]  = 8'd20;
        uut.rf.regs[3]  = 8'd30;
        uut.rf.regs[4]  = 8'd40;
        uut.rf.regs[5]  = 8'd13;    // R5
        uut.rf.regs[6]  = 8'd9;    // R6
        uut.rf.regs[7]  = 8'd0;    // R7
        uut.rf.regs[8]  = 8'd80;
        uut.rf.regs[9]  = 8'd90;
        uut.rf.regs[10] = 8'd100;
        uut.rf.regs[11] = 8'd110;
        uut.rf.regs[12] = 8'd120;
        uut.rf.regs[13] = 8'd130;
        uut.rf.regs[14] = 8'd140;
        uut.rf.regs[15] = 8'd150;
        
        #15; reset = 0;
        
        #200; $finish();
    end
    
endmodule

