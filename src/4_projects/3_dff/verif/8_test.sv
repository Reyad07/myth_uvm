`include "uvm_macros.svh"
import uvm_pkg::*;

class test extends uvm_scoreboard;
    `uvm_component_utils(test)

    function new(string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    env e;
    din_sequence_generator din_seq;
    rst_sequence_generator rst_seq;
    random_sequence_generator random_seq;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e",this);
        din_seq = din_sequence_generator::type_id::create("din_seq",this);
        rst_seq = rst_sequence_generator::type_id::create("rst_seq",this);
        random_seq = random_sequence_generator::type_id::create("random_seq",this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        din_seq.start(e.agnt.seqr);
        #20;
        rst_seq.start(e.agnt.seqr);
        #20;
        random_seq.start(e.agnt.seqr);
        #20;
        phase.drop_objection(this);
    endtask

endclass
