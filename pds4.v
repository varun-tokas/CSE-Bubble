`timescale 1ns/1ps

module veda(mode,data_out,data_in,clk,reset,address,write_enable);
input mode,write_enable,clk,reset;
input[7:0] address;
input[31:0] data_in;
output[31:0] data_out;
reg [31:0] outing;
reg [31:0] temp;
reg [31:0] memory [255:0];
integer i;
assign data_out = temp;
always@(posedge clk)
begin
    //temp = outing;   // check with non blocking also
    if(reset)    
    begin 
        for(i=0;i<255;i=i+1) memory[i] = 0; 
        outing = 0;
    end
    else 
    begin
        if(mode)
        begin
            outing = memory[address];
        end  
        else 
        begin
            if(write_enable)begin
                memory[address] = data_in;
                // $display("memory[%d] = %d", address, memory[address]);
            end
            else  
                memory[address] = memory[address];   
            outing = memory[address];
        end
    end
    temp = outing;
end   
initial begin
    for(i=0;i<255;i=i+1) memory[i] = 0;
    outing = 0;
end     
endmodule

module alu(alu_result, op_a, op_b, alu_op);
    input [31:0] op_a,op_b;
    input [4:0] alu_op;
    output reg [31:0] alu_result;
    // output zero;
    reg [31:0] result;
    // reg zero_flag;

    always @ (*) begin
        // $display("alu_op = %d op_a = %d op_b = %d", alu_op, op_a, op_b);
        case(alu_op) 
            5'd0: begin//add
                result = op_a + op_b;
            end
            5'd1: begin//addu
                result = op_a + op_b;
            end
            5'd2: begin//sub
                result = op_a - op_b;
            end
            5'd3: begin//subu
                result = op_a - op_b;
            end
            5'd4: begin//and
                result = op_a & op_b;
            end
            5'd5: begin//or
                result = op_a | op_b;
            end
            5'd6: begin//slt
                result = op_a < op_b;
            end
            5'd7: begin//sll
                result = op_a << op_b;
            end
            5'd8: begin//srl
                result = op_a >> op_b;
            end
            5'd9: begin//jr
                result = op_a;
            end
            5'd10: begin//addi
                result = op_a + op_b;
            end
            5'd11: begin//addiu
                result = op_a + op_b;
            end
            5'd12: begin//andi
                result = op_a & op_b;
            end
            5'd13: begin//ori
                result = op_a | op_b;
            end
            5'd14: begin//lw
                // $display("Load word instruction\n");
            end
            5'd15: begin//sw
                // $display("Store word instruction\n");
            end
            5'd16: begin//beq
                // $display("Branch on equal instruction\n");
            end
            5'd17: begin//bne
                // $display("Branch on not equal instruction\n");
            end
            5'd18: begin//bgt
                // $display("Branch on greater than instruction\n");
            end
            5'd19: begin//blt
                // $display("Branch on less than instruction\n");
            end
            5'd20: begin//slti
                result = op_a < op_b;
            end
            5'd21: begin//jal
                // $display("Jump and link instruction\n");
            end
            5'd22: begin//j
                // $display("Jump instruction\n");
            end
            5'd23: begin//bleq
                // $display("Branch on less than or equal instruction\n");
            end
            5'd24: begin//bgte
                // $display("Branch on greater than or equal instruction\n");
            end
            default: begin
                // $display("Invalid instruction\n");
            end
        endcase
        alu_result = result;
        // if(result == 0) begin
        //     zero_flag = 1;
        // end
        // else begin
        //     zero_flag = 0;
        // end
    end
endmodule

module pds4(clk);
    input wire clk;

    reg clk2;
    reg clk3;

    // initial begin
    //     clk = 0;
    //     forever #320 clk = ~clk;
    // end

    // initial begin
    //     clk2 = 0;
    //     forever #10 clk2 = ~clk2;
    // end
    wire [31:0] instruction;
    reg mode, reset, write_enable;
    reg [31:0] data_in;
    reg [7:0] program_counter;

    reg [7:0] address_mem;
    wire [31:0] data_out_mem;
    reg [31:0] data_in_mem;
    reg reset_mem, mode_mem, write_enable_mem;

    reg a;

    reg [31:0] registers[31:0];

    veda v1(mode, instruction, data_in, clk2, reset, program_counter, write_enable);
    veda memory(mode_mem, data_out_mem, data_in_mem, clk3, reset_mem, address_mem, write_enable_mem);

    reg [31:0] op_a, op_b;
    reg [4:0] alu_op;
    wire [31:0] alu_result;
    
    alu alu1(alu_result, op_a, op_b, alu_op);
    integer i = 0;

    initial begin
        //Initialize registers array to 0
        for(i=0;i<32;i=i+1) registers[i] = 0;
        registers[1]=0;
        clk2=0;
        clk3=0;
        //Store array in data memory
        //Array initially is 5, 2, 7, 1, 4
        $display("Initial contents: ");
        reset_mem = 0;
        mode_mem = 0;
        write_enable_mem = 1;
        data_in_mem = 32'd5;
        address_mem = 8'd0;
        $display("Memory contents[%d]: %d", address_mem, data_in_mem);
        clk3=0;
        #5
        clk3=1;
        #5

        reset_mem = 0;
        mode_mem = 0;
        write_enable_mem = 1;
        data_in_mem = 32'd2;
        address_mem = 8'd1;
        $display("Memory contents[%d]: %d", address_mem, data_in_mem);
        clk3=0;
        #5
        clk3=1;
        #5

        reset_mem = 0;
        mode_mem = 0;
        write_enable_mem = 1;
        data_in_mem = 32'd7;
        address_mem = 8'd2;
        $display("Memory contents[%d]: %d", address_mem, data_in_mem);
        clk3=0;
        #5
        clk3=1;
        #5

        reset_mem = 0;
        mode_mem = 0;
        write_enable_mem = 1;
        data_in_mem = 32'd1;
        address_mem = 8'd3;
        $display("Memory contents[%d]: %d", address_mem, data_in_mem);
        clk3=0;
        #5
        clk3=1;
        #5

        reset_mem = 0;
        mode_mem = 0;
        write_enable_mem = 1;
        data_in_mem = 32'd4;
        address_mem = 8'd4;
        $display("Memory contents[%d]: %d", address_mem, data_in_mem);
        clk3=0;
        #5
        clk3=1;
        #5


        address_mem = 8'd5;

        reset = 0;
        mode = 0;
        write_enable = 1;
        data_in = {6'd8,5'd0,5'd0,16'd0}; //addi $s0, $0, 0
        program_counter = 0;
        clk2 = 0;
        #5
        clk2 = 1;
        #5
        
        data_in = {6'd8,5'd1,5'd1,16'd4}; //addi $s1, $s1, 5
        program_counter = 1;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        data_in = {6'd8,5'd2,5'd2,16'd2}; //addi $t1, $t1, 0
        program_counter = 2;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        //loop1
        data_in = {6'd7,5'd2,5'd1,16'd13}; //bgt $t1, $s1, end1
        program_counter = 3;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        data_in = {6'd8,5'd16,5'd3,16'd0}; //addi $t2, $zero, 0
        program_counter = 4;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        //loop2
        data_in = {6'd1,5'd3,5'd1,16'd9}; //bge $t2, $s1, end2
        program_counter = 5;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        data_in = {6'd0,5'd3,5'd0,5'd4,5'd0,6'd0}; //sll $t3, $t2, 0
        program_counter = 6;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        data_in = {6'd0,5'd4,5'd0,5'd5,5'd0,6'd32}; //add $t4, $s0, $t3
        program_counter = 7;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        data_in = {6'd35,5'd5,5'd6,16'd0}; //lw $t5, 0($t4)
        program_counter = 8;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        data_in = {6'd35,5'd5,5'd7,16'd1}; //lw $t6, 1($t4)
        program_counter = 9;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        data_in = {6'd15,5'd6,5'd7,16'd2}; //ble $t5, $t6, ifend
        program_counter = 10;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        data_in = {6'd43,5'd5,5'd6,16'd1}; //sw $t5, 1($t4)
        program_counter = 11;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        data_in = {6'd43,5'd5,5'd7,16'd0}; //sw $t6, 0($t4)
        program_counter = 12;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        //ifend
        data_in = {6'd8,5'd3,5'd3,16'd1}; //addi $t2, $t2, 1
        program_counter = 13;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        data_in = {6'd2,5'd3,5'd3,16'd5}; //j loop2
        program_counter = 14;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        //end2
        data_in = {6'd8,5'd2,5'd2,16'd1}; //addi $t1, $t1, 1
        program_counter = 15;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        data_in = {6'd2,5'd2,5'd2,16'd3}; //j loop1
        program_counter = 16;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        //end1
        data_in = {6'd8,5'd8,5'd8,16'd0}; //addi $t0, $t0, 0
        program_counter = 17;
        clk2 = 0;
        #5
        clk2 = 1;
        #5

        program_counter = 0;
        mode = 1;

        while (program_counter < 18) begin
            #310
            a = 1;
        end

        $display("Final contents :");
        address_mem = 0;
        write_enable_mem = 0;
        clk3=0;
        #5
        clk3=1;
        #5
        $display("Memory contents[%d]: %d", address_mem, data_out_mem);

        address_mem = 1;
        write_enable_mem = 0;
        clk3=0;
        #5
        clk3=1;
        #5
        $display("Memory contents[%d]: %d", address_mem, data_out_mem);

        address_mem = 2;
        write_enable_mem = 0;
        clk3=0;
        #5
        clk3=1;
        #5
        $display("Memory contents[%d]: %d", address_mem, data_out_mem);

        address_mem = 3;
        write_enable_mem = 0;
        clk3=0;
        #5
        clk3=1;
        #5
        $display("Memory contents[%d]: %d", address_mem, data_out_mem);

        address_mem = 4;
        write_enable_mem = 0;
        clk3=0;
        #5
        clk3=1;
        #5
        $display("Memory contents[%d]: %d", address_mem, data_out_mem);
        
        $finish; 
    end

    always @ (posedge clk) begin
        clk2=0;
        #5
        clk2=1;
        #5
        case(instruction[31:26])
            6'd0: begin
                // $display("[Program Counter %d] R-type instruction", program_counter);
                // $display("[Program Counter %d] Funct instruction: %d", program_counter, instruction[5:0]);
                case(instruction[5:0])
                    6'd32: begin
                        // $display("[Program Counter %d] Add instruction %d", program_counter, instruction[5:0]);
                        op_a=registers[instruction[25:21]];
                        op_b=registers[instruction[20:16]];
                        // $display("op_a = %d op_b = %d", op_a, op_b);
                        #5
                        alu_op=0;
                       // $display("op_a = %d\n", op_a);
                        // $display("done");
                        registers[instruction[15:11]] = alu_result;
                       // $display("alu_result = %d\n", alu_result);
                    end
                    6'd33: begin
                        // $display("[Program Counter %d] Add unsigned instruction", program_counter);
                        op_a=registers[instruction[25:21]];
                        op_b=registers[instruction[20:16]];
                        #5
                        alu_op=1;
                        registers[instruction[15:11]] = alu_result;
                    end
                    6'd34: begin
                        // $display("[Program Counter %d] Subtract instruction", program_counter);
                        op_a=registers[instruction[25:21]];
                        op_b=registers[instruction[20:16]];
                        #5
                        alu_op=2;
                        registers[instruction[15:11]] = alu_result;
                    end
                    6'd35: begin
                        // $display("[Program Counter %d] Subtract unsigned instruction", program_counter);
                        op_a=registers[instruction[25:21]];
                        op_b=registers[instruction[20:16]];
                        #5
                        alu_op=3;
                        registers[instruction[15:11]] = alu_result;
                    end
                    6'd36: begin
                        // $display("[Program Counter %d] And instruction", program_counter);
                        op_a=registers[instruction[25:21]];
                        op_b=registers[instruction[20:16]];
                        #5
                        alu_op=4;
                        registers[instruction[15:11]] = alu_result;
                    end
                    6'd37: begin
                        // $display("[Program Counter %d] Or instruction", program_counter);
                        op_a=registers[instruction[25:21]];
                        op_b=registers[instruction[20:16]];
                        #5
                        alu_op=5;
                        registers[instruction[15:11]] = alu_result;
                    end
                    6'd42: begin
                        // $display("[Program Counter %d] Set on less than instruction", program_counter);
                        op_a=registers[instruction[25:21]];
                        op_b=registers[instruction[20:16]];
                        #5
                        alu_op=6;
                        registers[instruction[15:11]] = alu_result;
                    end
                    6'd0: begin
                        // $display("[Program Counter %d] Shift left logical instruction", program_counter);
                        op_a=registers[instruction[25:21]];
                        op_b=instruction[10:6];
                        #5
                        alu_op=7;
                        registers[instruction[15:11]] = alu_result;
                    end
                    6'd2: begin
                        // $display("[Program Counter %d] Shift right logical instruction", program_counter);
                        op_a=registers[instruction[25:21]];
                        op_b=instruction[10:6];
                        #5
                        alu_op=8;
                        registers[instruction[15:11]] = alu_result;
                    end
                    6'd8: begin
                        // $display("[Program Counter %d] Jump register instruction", program_counter);
                        program_counter=registers[instruction[25:21]];
                    end
                    default: begin
                        // $display("[Program Counter %d] Invalid instruction", program_counter);
                    end
                endcase
            end
            6'd8: begin
                // $display("[Program Counter %d] Add immediate instruction", program_counter);
                op_a = registers[instruction[25:21]];
                op_b = instruction[15:0];
                // $display("op_a = %d op_b = %d", op_a, op_b);
                alu_op = 10;
                #5
                registers[instruction[20:16]] = alu_result;
                // $display("register value = %d\n", registers[instruction[20:16]]);
            end
            6'd9: begin
                // $display("[Program Counter %d] Add immediate unsigned instruction", program_counter);
                op_a = registers[instruction[25:21]];
                op_b = instruction[15:0];
                alu_op = 11;
                #5
                registers[instruction[20:16]] = alu_result;
            end
            6'd12: begin
                // $display("[Program Counter %d] And immediate instruction", program_counter);
                op_a = registers[instruction[25:21]];
                op_b = instruction[15:0];
                alu_op = 12;
                #5
                registers[instruction[20:16]] = alu_result;
            end
            6'd13: begin
                // $display("[Program Counter %d] Or immediate instruction", program_counter);
                op_a = registers[instruction[25:21]];
                op_b = instruction[15:0];
                alu_op = 13;
                #5
                registers[instruction[20:16]] = alu_result;
            end
            6'd35: begin
                // $display("[Program Counter %d] Load word instruction", program_counter);
                mode_mem=1;
                address_mem = registers[instruction[25:21]] + instruction[15:0];
                write_enable_mem = 0;
                clk3=0;
                #5
                clk3=1;
                #5
                mode_mem=0;
                registers[instruction[20:16]] = data_out_mem;
            end
            6'd43: begin
                // $display("[Program Counter %d] Store word instruction", program_counter);
                address_mem = registers[instruction[25:21]] + instruction[15:0];
                write_enable_mem = 1;
                data_in_mem = registers[instruction[20:16]];
                clk3=0;
                #5
                clk3=1;
                #5
                write_enable_mem = 0;
            end
            6'd4: begin
                // $display("[Program Counter %d] Branch on equal instruction", program_counter);
                op_a=registers[instruction[25:21]];
                op_b=registers[instruction[20:16]];
                if(op_a == op_b) begin
                    program_counter = program_counter + instruction[15:0];
                end
            end
            6'd5: begin
                // $display("[Program Counter %d] Branch on not equal instruction", program_counter);
                op_a=registers[instruction[25:21]];
                op_b=registers[instruction[20:16]];
                if(op_a != op_b) begin
                    program_counter = program_counter + instruction[15:0];
                end
            end
            6'd7: begin
                // $display("[Program Counter %d] Branch on greater than instruction", program_counter);
                op_a=registers[instruction[25:21]];
                op_b=registers[instruction[20:16]];
                if(op_a > op_b) begin
                    program_counter = program_counter + instruction[15:0];
                end
            end
            6'd1: begin
                // $display("[Program Counter %d] Branch on greater than equal to instruction", program_counter);
                op_a=registers[instruction[25:21]];
                op_b=registers[instruction[20:16]];
                if(op_a >= op_b) begin
                    program_counter = program_counter + instruction[15:0];
                end
            end
            6'd6: begin
                // $display("[Program Counter %d] Branch on less than instruction", program_counter);
                op_a=registers[instruction[25:21]];
                op_b=registers[instruction[20:16]];
                if(op_a < op_b) begin
                    program_counter = program_counter + instruction[15:0];
                end
            end
            6'd15: begin
                // $display("[Program Counter %d] Branch on less than equal to instruction", program_counter);
                op_a=registers[instruction[25:21]];
                op_b=registers[instruction[20:16]];
                if(op_a <= op_b) begin
                    program_counter = program_counter + instruction[15:0];
                end
            end
            6'd10: begin
                // $display("[Program Counter %d] Set on less than immediate instruction", program_counter);
                op_a = registers[instruction[25:21]];
                op_b = instruction[15:0];
                #5
                alu_op = 20;
                registers[instruction[20:16]] = alu_result;
            end
            6'd3: begin
                // $display("[Program Counter %d] Jump and link instruction", program_counter);
                program_counter = instruction[25:0]-1;
                registers[11] = program_counter+1;
            end
            6'd2: begin
                // $display("[Program Counter %d] Jump instruction", program_counter);
                program_counter = instruction[25:0]-1;
            end
            default: begin
                // $display("[Program Counter %d] Invalid instruction", program_counter);
            end
        endcase
        #10
        // $display("[Program Counter %d] final alu_result = %d\n", program_counter, alu_result);
        program_counter = program_counter + 1;
    end
endmodule