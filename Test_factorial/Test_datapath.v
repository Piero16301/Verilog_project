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
            for (i = 0; i < 246; i = i + 1)
                begin
                    #5 clk =~ clk;
                end
        end

    integer j = 0;

    always @(*) begin
        if (clk == 1) begin
            $monitor("Clock: %b Result: %d PC: %d Opcode: %b",clk,result,pc,opcode);
            j = j + 1;
        end

        else
            $monitor("");
    end

endmodule