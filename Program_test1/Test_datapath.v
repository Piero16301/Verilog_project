module tb1();

    reg clk;

    wire [31:0] result;
    wire [7:0] pc;

    datapath core_1(clk,result,pc);

    integer i;

    initial
        begin
            clk = 0;
            for (i = 0; i < 22; i = i + 1)
                begin
                    #5 clk =~ clk;
                end
        end

    integer j = 0;

    always @(*) begin
        if (clk == 1) begin
            $monitor("Clock: %b Result: %b PC: %b",clk,result,pc);
            j = j + 1;
        end

        else
            $monitor("");
    end

endmodule