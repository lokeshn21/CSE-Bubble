//Made by Jaya Siva Shankar (210707) & Mourya (210662) 
// Testbench

`include "lab8_1.v"

module tb;

reg clk;
// wire [31:0] out;

Decode_Instruction uut (clk);

initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin
// $monitor(out);
#10000 $finish;

end

endmodule