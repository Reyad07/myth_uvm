`include "uvm_macros.svh"
import uvm_pkg::*;

module adder_tb;

    adder_if dut_if();
    adder dut(
        .a(dut_if.a),
        .b(dut_if.b),
        .sum(dut_if.sum)
    );

    initial begin
        $dumpfile("adder_tb.vcd");
        $dumpvars;
    end

    initial begin
        uvm_config_db #(virtual adder_if)::set(null, "*", "aif", dut_if);
        run_test("test");
    end

endmodule : adder_tb