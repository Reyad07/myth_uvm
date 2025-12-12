`include "uvm_macros.svh"
import uvm_pkg::*;

class env extends uvm_env;
    `uvm_component_utils(env)

    function new (string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    agent agnt;
    scoreboard scbd;

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        agnt = agent::type_id::create("agnt", this);
        scbd = scoreboard::type_id::create("scbd", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agnt.mon.send.connect(scbd.recv);
    endfunction

endclass