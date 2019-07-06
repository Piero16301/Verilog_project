module tb1();

    reg clk;

    wire [31:0] result;
    wire [7:0] pc;
    wire [5:0] opcode;

    datapath core_1(clk,result,pc,opcode);

    integer i;

    initial
        begin
            clk = 0;
            for (i = 0; i < 270; i = i + 1)
                begin
                    #5 clk =~ clk;
                end
        end

    always @(*) begin
        if (clk == 1) begin

            case(opcode)

            6'b000000: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: R-ADD",clk,result,pc,opcode);
            end

            6'b000001: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: R-SUB",clk,result,pc,opcode);
            end

            6'b000010: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: R-AND",clk,result,pc,opcode);
            end

            6'b000011: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: R-NOR",clk,result,pc,opcode);
            end

            6'b000100: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: R-OR",clk,result,pc,opcode);
            end

            6'b000101: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: R-SLT",clk,result,pc,opcode);
            end

            6'b000110: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-ADDI",clk,result,pc,opcode);
            end

            6'b000111: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-SUBI",clk,result,pc,opcode);
            end

            6'b001000: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-ANDI",clk,result,pc,opcode);
            end

            6'b001001: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-ORI",clk,result,pc,opcode);
            end

            6'b001010: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-SLTI",clk,result,pc,opcode);
            end

            6'b001011: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-LB",clk,result,pc,opcode);
            end

            6'b001100: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-LH",clk,result,pc,opcode);
            end

            6'b001101: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-LW",clk,result,pc,opcode);
            end

            6'b001110: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-LUI",clk,result,pc,opcode);
            end

            6'b001111: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: R-MUL",clk,result,pc,opcode);
            end

            6'b010000: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-SB",clk,result,pc,opcode);
            end

            6'b010001: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-SH",clk,result,pc,opcode);
            end

            6'b010010: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-SW",clk,result,pc,opcode);
            end

            6'b010011: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-BEQ",clk,result,pc,opcode);
            end

            6'b010100: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-BNEQ",clk,result,pc,opcode);
            end

            6'b010101: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: I-BGEZ",clk,result,pc,opcode);
            end

            6'b010110: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: J-J",clk,result,pc,opcode);
            end

            6'b010111: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: J-JAL",clk,result,pc,opcode);
            end

            6'b011000: begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b Type: R-JR",clk,result,pc,opcode);
            end

            endcase

        end

        else
            $monitor("");
    end

endmodule