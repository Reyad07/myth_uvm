module adder(input logic [2:0] a,
    input logic [2:0] b,
    input logic cin,
    output logic [3:0]add);

    assign add = a + b + cin;

endmodule