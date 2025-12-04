`include "uvm_macros.svh"
import uvm_pkg::*;

module adder_tb;

    seq_adder_if dut_if();
    adder dut(
        .clk(dut_if.clk),
        .rst_n(dut_if.rst_n),
        .a(dut_if.a),
        .b(dut_if.b),
        .sum(dut_if.sum)
    );

    initial begin
        dut_if.clk = 0;
        dut_if.rst_n = 1;
    end

    always #5 dut_if.clk = ~dut_if.clk;

    initial begin
        $dumpfile("adder_tb.vcd");
        $dumpvars;
    end

    initial begin
        uvm_config_db #(virtual seq_adder_if)::set(null, "*", "aif", dut_if);
        run_test("test");
    end

endmodule : adder_tb