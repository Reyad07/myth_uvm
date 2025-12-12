`include "uvm_macros.svh"
import uvm_pkg::*;

class test extends uvm_test;
    `uvm_component_utils(test)

    function new (string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    env e;
    generator gen;

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("env", this);
        gen = generator::type_id::create("gen", this);
    endfunction

    virtual task run_phase (uvm_phase phase);
        phase.raise_objection(this);
        gen.start(e.agnt.seqr);
        #30;
        phase.drop_objection(this);
    endtask

endclass