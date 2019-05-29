module datapath(clk,result,pc);

    input clk;

    output reg [31:0] result;
    output reg [7:0] pc =  8'd0;

    reg [7:0] i_content;
    reg [31:0] instruction,s_extend,reg_temp,sl_branch;
    reg [5:0] opcode;
    reg [32:0] temp_op;
    reg [15:0] extend_16 = 16'd0;
    reg [23:0] extend_24 = 24'd0;
    reg [4:0] pos_read1, pos_read2, pos_write;
    reg [1:0] left = 2'b00;
    reg [25:0] j_initial,j_offset;
    reg overflow,alu_exit;

    reg [7:0] instr_memory [0:43]; //solo 11 instrucciones (2 primeras filas)
    reg [31:0] reg_file [0:31];

    initial begin
        $readmemb("instruction.txt", instr_memory);
        $readmemh("register.txt", reg_file);
    end

always @(posedge clk) begin

    instruction = {instr_memory[pc],instr_memory[pc+1],instr_memory[pc+2],instr_memory[pc+3]};

    opcode = {instruction[31:26]}; //45 instruction types

    pc = pc + 4; //Program counter increasing

    case(opcode)
    
    6'b000000: begin //add
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        temp_op = reg_file[pos_read1] + reg_file[pos_read2];
        result = temp_op[31:0];
        overflow = temp_op[32];
    end

    6'b000001: begin //sub
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        temp_op = reg_file[pos_read1] - reg_file[pos_read2];
        result = {temp_op[31:0]};
        overflow = temp_op[32];
    end

    6'b000010: begin //and
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        result = reg_file[pos_read1] & reg_file[pos_read2];
        overflow = 1'b0;
    end

    6'b000011: begin //nor
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        result = reg_file[pos_read1] ~| reg_file[pos_read2];
        overflow = 1'b0;
    end

    6'b000100: begin //or
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        result = reg_file[pos_read1] | reg_file[pos_read2];
        overflow = 1'b0;
    end

    6'b000101: begin //slt
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        result = (reg_file[pos_read1] < reg_file[pos_read2]) ? (32'd1) : (32'd0);
        overflow = 1'b0;
    end

    6'b000110: begin //addi
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        s_extend = {extend_16,instruction[15:0]};
        temp_op = reg_file[pos_read1] + s_extend;
        result = {temp_op[31:0]};
        overflow = temp_op[32];
    end

    6'b000111: begin //subi
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        s_extend = {extend_16,instruction[15:0]};
        temp_op = reg_file[pos_read1] - s_extend;
        result = {temp_op[31:0]};
        overflow = temp_op[32];
    end

    6'b001000: begin //andi
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        s_extend = {extend_16,instruction[15:0]};
        result = reg_file[pos_read1] & s_extend;
        overflow = 1'b0;
    end

    6'b001001: begin //ori
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        s_extend = {extend_16,instruction[15:0]};
        result = reg_file[pos_read1] | s_extend;
        overflow = 1'b0;
    end

    6'b001010: begin //slti
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        s_extend = {extend_16,instruction[15:0]};
        result = (reg_file[pos_read1] < s_extend) ? (32'd1) : (32'd0);
        overflow = 1'b0;
    end
    
    endcase

end

always @(negedge clk) begin

    reg_file[pos_write] <= result; //Arithmetic operations

end

endmodule