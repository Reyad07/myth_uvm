`include "uvm_macros.svh"
import uvm_pkg::*;

class scoreboard extends uvm_scoreboard;

    `uvm_component_utils(scoreboard)

    function new (string name = "scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    uvm_analysis_imp #(transaction, scoreboard) scbd_imp;
    transaction tr_mon;

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        scbd_imp = new("scbd_imp", this);
        tr_mon = transaction::type_id::create("tr_mon");
    endfunction

    virtual function void write (transaction t);
        tr_mon = t;
        `uvm_info("SCOREBOARD", $sformatf("Scoreboard received data: a: %0d, b: %0d, sum: %0d", tr_mon.a, tr_mon.b, tr_mon.y), UVM_NONE)
        if (tr_mon.y !== (tr_mon.a + tr_mon.b)) 
            `uvm_error("SCOREBOARD", $sformatf("Mismatch detected: a: %0d, b: %0d, expected sum: %0d, received sum: %0d", tr_mon.a, tr_mon.b, (tr_mon.a+tr_mon.b), tr_mon.y))
        else
            `uvm_info("SCOREBOARD","TEST PASSED", UVM_NONE)
    endfunction

endclass