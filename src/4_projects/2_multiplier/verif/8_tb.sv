`include "uvm_macros.svh"
import uvm_pkg::*;

module mult_tb;
    
    mult_if mif();
    mult u_dut(.a(mif.a),
               .b(mif.b),
               .product(mif.product));
    
    initial begin
        uvm_config_db #(virtual mult_if)::set(null,"*","vif",mif);
        run_test("test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule