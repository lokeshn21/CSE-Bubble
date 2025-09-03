//Made by Jaya Siva Shankar (210707) & Mourya (210662) 

module add_ver(a,b,c);

input [31:0] a,b;
output [31:0] c;

assign c = a + b;

endmodule

module sub_ver(a,b,c);

input [31:0] a,b;
output [31:0] c;

assign c = a - b;

endmodule


module and_ver(a,b,c);

input [31:0] a;
input [31:0] b;
output [31:0] c;

assign c = a & b;


endmodule

module or_ver(a,b,c);

input [31:0] a,b;
output [31:0] c;

assign c = a | b;

endmodule

module sll_ver(a,b,c);

input [31:0] a;
output [31:0]c;
input [15:0] b;

assign c = a << b;

endmodule

module srl_ver(a,b,c);

input [31:0] a;
output [31:0]c;
input [15:0] b;

assign c = a >> b;

endmodule

module Decode_Instruction(clk);
input clk;
reg [9:0] pc;
// reg clk;
reg [5:0] Opcode;
reg [5:0] Funct;

reg [4:0] rs;
reg [4:0] rd;
reg [4:0] rt;

reg [15:0] addr_const;
reg [15:0] Shamt;

reg [25:0] jump_inst;

integer i;

reg [31:0] Curr_Instruction;

reg [31:0] Risc_bubble [31:0];

reg [31:0] veda_mem [1023:0];

wire [31:0] c_sum;
wire [31:0] c_sub;
wire [31:0] c_and;
wire [31:0] c_or;
wire [31:0] c_sll;
wire [31:0] c_srl;
reg [15:0] r;

initial begin
    // r = -14;
    // Data mem
    veda_mem[512] = 32'd34;
    veda_mem[513] = 32'd10;
    veda_mem[514] = 32'd12;
    veda_mem[515] = 32'd9;
    veda_mem[516] = 32'd55;
    veda_mem[517] = 32'd56;
    veda_mem[518] = 32'd99;
    veda_mem[519] = 32'd101;
    veda_mem[520] = 32'd1;
    veda_mem[521] = 32'd59;


    veda_mem[0] = {6'd5,5'd10,5'd11,16'd512};  // addi 0 + 512                              // load adress of array in s7;
    veda_mem[1] = {6'd5,5'd0,5'd11,16'd0};  // addi 0 + 0  loop counter
    veda_mem[2] = {6'd5,5'd9,5'd11,16'd9};   // loading n-1 number index
    veda_mem[3] = {6'd5,5'd1,5'd11,16'd0};  // loop counter 2
    veda_mem[4] = {6'd5,5'd5,5'd11,16'd0};  // counter for printing
    veda_mem[5] = {6'd5,5'd6,5'd11,16'd10};  // 5 elements

    // loop 

    veda_mem[6] = {6'd11,5'd12,5'd1,16'd0}; // sll by 1 units
    veda_mem[7] = {6'd1,5'd12,5'd10,5'd12,5'd0,6'd0}; // add t7 = s7+t7
    veda_mem[8] = {6'd13,5'd2,5'd12,16'd0}; // load j
    veda_mem[9] = {6'd13,5'd3,5'd12,16'd1}; // load j+1
    veda_mem[10] = {6'd24,5'd4,5'd2,5'd3,5'd0,6'd0}; // slt
    veda_mem[11] = {6'd16,5'd4,5'd11,16'd2};  // bne
    veda_mem[12] = {6'd14,5'd3,5'd12,16'd0}; // sw
    veda_mem[13] = {6'd14,5'd2,5'd12,16'd1}; // sw      
    veda_mem[14] = {6'd5,5'd1,5'd1,16'd1};  // addi
    veda_mem[15] = {6'd2,5'd9,5'd0,5'd7,5'd0,6'd0}; //sub
    veda_mem[16] = {6'd16,5'd1,5'd7,16'b1111111111110101}; // bne
    veda_mem[17] = {6'd5,5'd0,5'd0,16'd1}; //addi
    veda_mem[18] = {6'd5,5'd1,5'd11,16'd0}; // addi
    veda_mem[19] = {6'd16,5'd0,5'd9,16'b1111111111110010}; // bne
   

end

always @(posedge clk)
begin

    if(pc>=20)begin
        $display("The sorted Numbers are: ");
        for(i=512;i<=521;i = i + 1)begin
            $display(veda_mem[i]);
        end
        $finish;
    end
end

initial 
begin

    pc = 0;
    Risc_bubble[11] = 32'd0;


end

output reg [31:0] out;
wire [31:0] temp;
assign temp = Risc_bubble[rd];

add_ver uut1(Risc_bubble[rs],Risc_bubble[rt],c_sum);
sub_ver uut2(Risc_bubble[rs],Risc_bubble[rt],c_sub);
and_ver uut3(Risc_bubble[rs],Risc_bubble[rt],c_and);
or_ver uut4(Risc_bubble[rs],Risc_bubble[rt],c_or);
sll_ver uut5(Risc_bubble[rt],Shamt,c_sll);
srl_ver uut6(Risc_bubble[rt],Shamt,c_srl);

always @(posedge clk)
begin
    // $monitor($time," this is the value in rd ",temp);

    Curr_Instruction = veda_mem[pc];
    Opcode =  Curr_Instruction[31:26];
    Funct = Curr_Instruction[5:0];

    rs = Curr_Instruction[25:21];
    rt = Curr_Instruction[20:16];
    rd = Curr_Instruction[15:11];

    addr_const =  Curr_Instruction[15:0];
    Shamt = Curr_Instruction[15:0];

    jump_inst = Curr_Instruction[25:0];
    
    case(Opcode)
    
        6'd1: begin      // addition
            $display("Addition");                    
            Risc_bubble[rd] = c_sum;
            // out = c_sum;
            $display(Risc_bubble[rd]);
            pc = pc + 1;
            

        end

        6'd2: begin       // subraction
                $display("Subraction");   
                Risc_bubble[rd] = c_sub;
                // out = c_sub;
                $display(Risc_bubble[rd]);
                pc = pc + 1;
                // $display(pc);
       end

        6'd3: begin    /// unsigned sum
                $display("Unsigned Addition");                
                Risc_bubble[rd] = c_sum;
                $display(Risc_bubble[rd]);
                pc = pc + 1;
        end

        6'd4: begin     // usigned subraction
                $display("Unsigned Sub");               
                Risc_bubble[rd] = c_sub;
                $display(Risc_bubble[rd]);
                pc = pc + 1;

        end

        6'd5 : begin     // add imme
                $display("Add Immediate");
                Risc_bubble[rs] = Risc_bubble[rt] + addr_const[15:0];
                $display(Risc_bubble[rs]);
                pc = pc + 1;
        end

        6'd6 :  begin     // Add imme Unsigned
                        $display("Add Immediate Unssigned"); 
                        Risc_bubble[rs] = Risc_bubble[rt] + addr_const[15:0];
                        $display(Risc_bubble[rs]);
                        pc = pc + 1;
        end

        6'd7: begin      // and 

            $display("AND Called");  
            // $display(Risc_bubble[rd]);              
            Risc_bubble[rd] = Risc_bubble[rs] & Risc_bubble[rt];
            $display(Risc_bubble[rd]);
            pc = pc + 1;
            
        end

        6'd8: begin         // or

             $display("OR Called");
            //  $display(Risc_bubble[rd]);                  
             Risc_bubble[rd] = Risc_bubble[rs] | Risc_bubble[rt];
             $display(Risc_bubble[rd]); 
             pc = pc + 1;

        end

        6'd9 :  begin     // And Immediate

            $display("And Immediate "); 
            // $display(Risc_bubble[rs]);  
            Risc_bubble[rs] = Risc_bubble[rt] & addr_const[15:0];
            $display(Risc_bubble[rs]);  
            pc = pc + 1;

        end

        6'd10 : begin    // Or Immediate

            $display("Or Immediate ");
            // $display(Risc_bubble[rs]);
            Risc_bubble[rs] = Risc_bubble[rt] | addr_const[15:0];
            $display(Risc_bubble[rs]); 
            pc = pc + 1;

        end

        6'd11: begin   // Sll 
               $display("sll called");   
               $display(Risc_bubble[rt]);    
               Risc_bubble[rs] = c_sll;
               $display(Risc_bubble[rs]);
               pc = pc + 1;
        end

        6'd12: begin    // Srl

            $display("srl called");        
            $display(Risc_bubble[rt]);   
            Risc_bubble[rs] = c_srl;
            $display(Risc_bubble[rs]);
            pc = pc + 1;

        end

        6'd13 : begin    // Load word
            $display("Data transfer - load word");
            // $display(Risc_bubble[rs]);
            Risc_bubble[rs] = veda_mem[Risc_bubble[rt] +  addr_const];
            $display(Risc_bubble[rs]);
            pc = pc + 1;

        end

        6'd14 : begin   // store word

            $display("Data transfer - store word");
            veda_mem[Risc_bubble[rt] +  addr_const] = Risc_bubble[rs];
            $display(veda_mem[Risc_bubble[rt] +  addr_const]);
            pc = pc + 1;

        end

        6'd15 : begin    // beq
                $display("Branch Equal Called");
                if(Risc_bubble[rt] == Risc_bubble[rs]) 
                begin
                        // $display(pc);
                        pc = pc + 1 + addr_const[5:0]; 
                        // pc = pc + 1;
                        $display("The jumping address= ",pc);
                end
                else pc = pc + 1;

        end

        6'd16 : begin 
                    $display("Branch Not Equal Called");
                    if(Risc_bubble[rs] != Risc_bubble[rt]) pc = pc + 1 + addr_const[9:0]; // bne
                    else pc = pc + 1;
                    $display("The jumping address= ",pc);
                end

        6'd17 : begin 
                    $display("Branch Greater than Called");
                    if(Risc_bubble[rs] > Risc_bubble[rt]) pc = pc + 1 + addr_const[9:0]; // bgt
                    else pc = pc + 1;
                    $display("The jumping address= ",pc);
                end

        6'd18 : begin 
                    $display("Branch Greater than equal to Called");
                    if(Risc_bubble[rs] >= Risc_bubble[rt]) pc = pc + 1 + addr_const[9:0];   //bgte
                    else pc = pc + 1;
                    $display("The jumping address= ",pc);
                end

        6'd19 : begin  
                    $display("Branch Less than Called");
                    if(Risc_bubble[rs] < Risc_bubble[rt]) pc = pc + 1 + addr_const[9:0];   // ble
                    else pc = pc + 1;
                    $display("The jumping address= ",pc);
                end

        6'd20 : begin
                    $display("Branch Less than equal to Called");
                    if(Risc_bubble[rs] <= Risc_bubble[rt]) pc = pc + 1 + addr_const[9:0];   // bleq
                    else pc = pc + 1;
                    $display("The jumping address= ",pc);
                end


        6'd21 : begin
                    $display("Jump Instruction called");
                    pc = jump_inst[9:0];   // j
                    $display("The jumping address= ",pc);
                end

        6'd22:  begin    
                    $display("Jump To Register called");
                    pc = Risc_bubble[rs];  // jr
                    $display("The jumping address= ",pc);
                end

        6'd23 : begin                     // jal
                    $display("Jump and link "); 
                    Risc_bubble[5'b11111] = pc + 1;
                    pc = jump_inst[9:0];
                    $display("The jumping address= ",pc);
                end

        6'd24: begin      //slt 
                    $display("Set on less than called");
                    if(Risc_bubble[rt] < Risc_bubble[rd]) Risc_bubble[rs] = 1;
                    else Risc_bubble[rs] = 0;
                    $display(Risc_bubble[rs]);
                    pc = pc + 1; 

                end

        6'd25 : begin   // slti

                    $display("Set on less than immediate");
                    if(Risc_bubble[rt] < addr_const[15:0]) Risc_bubble[rs] = 1;
                    else Risc_bubble[rs] = 0;
                    $display(Risc_bubble[rs]);
                    pc = pc + 1;

                end


    endcase

end



endmodule


// module tb;

// reg clk;
// // wire [31:0] out;

// Decode_Instruction uut (clk);

// initial begin
// clk = 0;
// forever #5 clk = ~clk;
// end

// initial begin
// // $monitor(out);
// #10000 $finish;

// end

// endmodule


