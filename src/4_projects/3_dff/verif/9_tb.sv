`include "uvm_macros.svh"
import uvm_pkg::*;

module tb;
    
    dff_intf diff();
    dff u_dff ( .clk(diff.clk),
                .rst(diff.rst),
                .din(diff.din),
                .dout(diff.dout));

     initial diff.clk = 1'b0;
     always #5 diff.clk = ~diff.clk;

    initial begin
        uvm_config_db#(virtual dff_intf)::set(null,"*","vif",diff);
        run_test("test");
    end

    initial begin
        $dumpfile("dff.vcd");
        $dumpvars;
    end

endmodule