module tb1();

    reg clk;

    wire [31:0] result;

    datapath core_1(clk,result);

    integer i;

    initial
        begin
            clk = 1;
            for (i = 0; i < 1; i = i + 1)
                begin
                    #5 clk =~ clk;
                end
        end

    initial
        begin
            //Pruebas de todas las operaciones
        end

    integer j = 0;

    always @(*) begin
        if (clk == 1) begin
            $monitor("Clock: %b Result: %d",clk,result);
            j = j + 1;
        end

        else
            $monitor("");
    end

endmodule