module datapath(clk,result);

    input clk;

    output reg [31:0] result;

    reg [7:0] pc =  8'd0;
    reg [2:0] add_pc = 3'b100;
    reg [31:0] instruction,s_extend;
    reg [5:0] opcode;
    reg [32:0] temp_op;
    reg [4:0] pos_read1, pos_read2, pos_write;
    reg overflow, bit;

    reg [7:0] instr_memory [0:3];
    reg [31:0] reg_file [0:3];
    //reg [7:0] data_memory [0:255];

    initial begin
        $readmemb("instruction.txt", instr_memory);
        $readmemh("register.txt", reg_file);
        //$readmemb("data.txt", data_memory);
    end

always @(posedge clk) begin

    instruction = {instr_memory[pc],instr_memory[pc+1],instr_memory[pc+2],instr_memory[pc+3]};

    opcode = {instruction[31:26]}; //45 instruction types

    case(opcode)
    
    6'b000000: begin
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        temp_op = reg_file[pos_read1] + reg_file[pos_read2];
        result = temp_op[31:0];
        overflow = temp_op[32];
    end

    6'b000001: begin
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        temp_op = reg_file[pos_read1] - reg_file[pos_read2];
        result = {temp_op[31:0]};
        overflow = temp_op[32];
    end

    6'b000010: begin
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        result = reg_file[pos_read1] & reg_file[pos_read2];
        overflow = 1'b0;
    end

    6'b000011: begin
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        result = reg_file[pos_read1] ~| reg_file[pos_read2];
        overflow = 1'b0;
    end

    6'b000100: begin
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        result = reg_file[pos_read1] | reg_file[pos_read2];
        overflow = 1'b0;
    end

    6'b000101: begin
        pos_read1 = {instruction[25:21]};
        pos_read2 = {instruction[20:16]};
        pos_write = {instruction[15:11]};
        result = (reg_file[pos_read1] < reg_file[pos_read2]) ? (32'd1) : (32'd0);
        overflow = 1'b0;
    end

    6'b000110: begin
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        bit = instruction[15];
        s_extend = {bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,instruction[15:0]};
        temp_op = reg_file[pos_read1] + s_extend;
        result = {temp_op[31:0]};
        overflow = temp_op[32];
    end

    6'b000111: begin
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        bit = instruction[15];
        s_extend = {bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,instruction[15:0]};
        temp_op = reg_file[pos_read1] - s_extend;
        result = {temp_op[31:0]};
        overflow = temp_op[32];
    end

    6'b001000: begin
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        bit = instruction[15];
        s_extend = {bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,instruction[15:0]};
        result = reg_file[pos_read1] & s_extend;
        overflow = 1'b0;
    end

    6'b001001: begin
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        bit = instruction[15];
        s_extend = {bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,instruction[15:0]};
        result = reg_file[pos_read1] | s_extend;
        overflow = 1'b0;
    end

    6'b001010: begin
        pos_read1 = {instruction[25:21]};
        pos_write = {instruction[20:16]};
        bit = instruction[15];
        s_extend = {bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,bit,instruction[15:0]};
        result = (reg_file[pos_read1] < s_extend) ? (32'd1) : (32'd0);
        overflow = 1'b0;
    end

    6'b001011: begin
        
    end

    6'b001100: begin
        
    end

    6'b001101: begin
        
    end

    6'b001110: begin
        
    end

    6'b001111: begin
        
    end

    6'b010000: begin
        
    end

    6'b010001: begin
        
    end

    6'b010010: begin
        
    end

    6'b010011: begin
        
    end

    6'b010100: begin
        
    end

    6'b010101: begin
        
    end

    6'b010110: begin
        
    end

    6'b010111: begin
        
    end
    
    endcase

    pc = pc + add_pc;

end

always @(negedge clk) begin

    reg_file[pos_write] <= result;

end

endmodule