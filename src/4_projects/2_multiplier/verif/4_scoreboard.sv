`include "uvm_macros.svh"
import uvm_pkg::*;

class scoreboard extends uvm_scoreboard;
    `uvm_component_utils (scoreboard)

    function new(string path = "scoreboard", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    uvm_analysis_imp #(transaction, scoreboard) recv;

    virtual function void build_phase (uvm_phase phase);
        super.build_phase (phase);
        recv = new("recv", this);
    endfunction

    virtual function void write (transaction tr);
        logic [7:0] mult;
        mult = tr.a * tr.b;
        $display("=====================================");
        if (tr.product !== mult)
            `uvm_error ("SCBD", $sformatf("Multiplication Error: a: %0d, b: %0d, product: %0d, expected: %0d", tr.a, tr.b, tr.product, mult))
        else
            `uvm_info ("SCBD", $sformatf("Multiplication OKAY: a: %0d, b: %0d, product: %0d, expected: %0d", tr.a, tr.b, tr.product, mult),UVM_NONE)
        $display("=====================================");
    endfunction

endclass