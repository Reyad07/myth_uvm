`include "uvm_macros.svh"
import uvm_pkg::*;

class env extends uvm_env;
    `uvm_component_utils(env)

    function new (string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    agent agt;
    scoreboard scbd;

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        agt = agent::type_id::create("agt", this);
        scbd = scoreboard::type_id::create("scbd", this);
    endfunction

    virtual function void connect_phase (uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.mon_port.connect(scbd.scbd_imp);
    endfunction

endclass