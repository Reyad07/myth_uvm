interface seq_adder_if;
    logic clk;
    logic rst_n;
    logic [3:0] a;
    logic [3:0] b;
    logic [4:0] sum;
endinterface : seq_adder_if