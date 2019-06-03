module datapath(clk,result,pc,opcode);

    input clk;

    output reg [31:0] result;
    output reg [7:0] pc =  8'd0;
    output reg [5:0] opcode;

    reg [7:0] i_content;
    reg [31:0] instruction,s_extend,reg_temp,sl_branch,write_store;
    reg [32:0] temp_op;
    reg [15:0] extend_16 = 16'd0;
    reg [23:0] extend_24 = 24'd0;
    reg [4:0] pos_read1, pos_read2, pos_write;
    reg [1:0] left = 2'b00;
    reg [25:0] j_initial,j_offset;
    reg overflow,alu_exit;

    reg [7:0] instr_memory [0:27];
    reg [31:0] reg_file [0:31];
    reg [7:0] data_memory [0:255];

    initial begin
        $readmemb("instruction.txt", instr_memory);
        $readmemh("register.txt", reg_file);
        $readmemb("data.txt", data_memory);
    end

always @(posedge clk) begin

    instruction = {instr_memory[pc],instr_memory[pc+1],instr_memory[pc+2],instr_memory[pc+3]};

    opcode = {instruction[31:26]}; //25 instruction types

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

    6'b001011: begin //lb
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        s_extend = {extend_16,instruction[15:0]};
        result = {extend_24,data_memory[reg_file[pos_read1] + s_extend]};
        overflow = 1'b0;
    end

    6'b001100: begin //lh
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        s_extend = {extend_16,instruction[15:0]};
        result = {extend_16,data_memory[reg_file[pos_read1] + s_extend + 1],data_memory[reg_file[pos_read1] + s_extend]};
        overflow = 1'b0;
    end

    6'b001101: begin //lw
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        s_extend = {extend_16,instruction[15:0]};
        result = {data_memory[reg_file[pos_read1] + s_extend + 3],data_memory[reg_file[pos_read1] + s_extend + 2],data_memory[reg_file[pos_read1] + s_extend + 1],data_memory[reg_file[pos_read1] + s_extend]};
        overflow = 1'b0;
    end

    6'b001110: begin //lui
        pos_write = {instruction[20:16]};
        result = {instruction[15:0],extend_16};
        overflow = 1'b0;
    end

    6'b001111: begin //mul
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        temp_op = reg_file[pos_read1] * reg_file[pos_read2];
        result = {temp_op[31:0]};
        overflow = temp_op[32];
    end

    6'b010000: begin //sb
        pos_write = {instruction[25:21]};
        pos_read1 = {instruction[20:16]};
        s_extend = {extend_16,instruction[15:0]};
        reg_temp = reg_file[pos_read1];
        overflow = 1'b0;
    end

    6'b010001: begin //sh
        pos_write = {instruction[25:21]};
        pos_read1 = {instruction[20:16]};
        s_extend = {extend_16,instruction[15:0]};
        reg_temp = reg_file[pos_read1];
        overflow = 1'b0;
    end

    6'b010010: begin //sw
        pos_write = {instruction[25:21]};
        pos_read1 = {instruction[20:16]};
        write_store = reg_file[pos_write];
        s_extend = {extend_16,instruction[15:0]};
        reg_temp = reg_file[pos_read1];
        overflow = 1'b0;
    end

    6'b010011: begin //beq
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        s_extend = {extend_16,instruction[15:0]};
        sl_branch = {s_extend[29:0],left};
        alu_exit = (reg_file[pos_read1] == reg_file[pos_read2]) ? (1'b1) : (1'b0);
        pc = (alu_exit == 1'b1) ? (pc + sl_branch) : (pc + 0);
        overflow = 1'b0;
    end

    6'b010100: begin //bneq
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        s_extend = {extend_16,instruction[15:0]};
        sl_branch = {s_extend[29:0],left};
        alu_exit = (reg_file[pos_read1] != reg_file[pos_read2]) ? (1'b1) : (1'b0);
        pc = (alu_exit == 1'b1) ? (pc + sl_branch) : (pc + 0);
        overflow = 1'b0;
    end

    6'b010101: begin //bgez
        pos_read1 = {instruction[25:21]};
        s_extend = {extend_16,instruction[15:0]};
        sl_branch = {s_extend[29:0],left};
        alu_exit = (reg_file[pos_read1] >= 0) ? (1'b1) : (1'b0);
        pc = (alu_exit == 1'b1) ? (pc + sl_branch) : (pc + 0);
        overflow = 1'b0;
    end

    6'b010110: begin //j
        j_initial = {instruction[25:0]};
        j_offset = {j_initial[23:0],left};
        pc = {j_offset[7:0]};
        overflow = 1'b0;
    end

    6'b010111: begin //jal
        j_initial = {instruction[25:0]};
        j_offset = {j_initial[23:0],left};
        result = {extend_24,pc};
        pc = {j_offset[7:0]};
        overflow = 1'b0;
    end

    6'b011000: begin //jr
        pos_read1 = {instruction[25:21]};
        i_content = reg_file[pos_read1];
        pc = {i_content[7:0]};
        overflow = 1'b0;
    end
    
    endcase

end

always @(negedge clk) begin

    if (opcode < 16)
        reg_file[pos_write] <= result; //Arithmetic operations

    else if (opcode == 16)
        data_memory[pos_write + s_extend] <= reg_temp[7:0]; //Store byte

    else if (opcode == 17) begin
        data_memory[pos_write + s_extend] <= reg_temp[7:0]; //Store halfword
        data_memory[pos_write + s_extend + 1] <= reg_temp[15:8];
    end

    else if (opcode == 18) begin
        data_memory[write_store + s_extend] <= reg_temp[7:0]; //Store word
        data_memory[write_store + s_extend + 1] <= reg_temp[15:8];
        data_memory[write_store + s_extend + 2] <= reg_temp[23:16];
        data_memory[write_store + s_extend + 3] <= reg_temp[31:24];
    end

    else if (opcode == 23) begin
        reg_file[31] <= result;
    end

end

endmodule