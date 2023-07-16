`timescale 1ns/1ps
`include "pds4.v"

module cse_bubble_tb();

reg clk;
initial begin
    clk = 0;
    forever #320 clk = ~clk;
end

pds4 uut(.clk(clk));

endmodule