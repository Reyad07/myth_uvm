`include "uvm_macros.svh"
import uvm_pkg::*;

class scoreboard extends uvm_scoreboard;

    `uvm_component_utils(scoreboard)

    function new(string path = "scoreboard", uvm_component parent = null);
        super.new(path, parent);
    endfunction
    
    uvm_analysis_imp #(transaction, scoreboard) recv;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        recv = new("recv",this);
    endfunction

    virtual function void write(transaction tr);
        $display("===================================");
        if(tr.rst == 1'b1)
            `uvm_info("SCOREBOARD","DFF RST",UVM_NONE)
        else if (tr.rst == 1'b0 && tr.din == tr.dout)
            `uvm_info("SCOREBOARD", "TEST PASSED",UVM_NONE)
        else
            `uvm_error("SCOREBOARD", "TEST FAILED")
        $display("===================================");
    endfunction

endclass
