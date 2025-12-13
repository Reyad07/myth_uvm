module dff (
    input logic clk,
    input logic rst,
    input logic din,
    output logic dout
);

    always_ff @( posedge clk ) begin
        if (rst)
            dout <= 1'b0;
        else
            dout <= din;
    end

endmodule