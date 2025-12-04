module adder(
    input logic clk,
    input logic rst_n,
    input logic [3:0] a,
    input logic [3:0] b,
    output logic [4:0] sum
);
    always @(posedge clk) begin
        if(!rst_n)
            sum <= '0;
        else
            sum <= a + b;
    end
endmodule