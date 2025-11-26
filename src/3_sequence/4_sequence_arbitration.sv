`include "uvm_macros.svh"
import uvm_pkg::*;

// possible arbitration methods:
// SEQ_ARB_FIFO - default method (no priority)
// SEQ_ARB_WEIGHTED - weight is use for priority
// SEQ_ARB_RANDOM       - strictly random (no priority)
// SEQ_ARB_STRICT_FIFO  - support priority - FIFO will only come into play with same weight for multiple sequence
// SEQ_ARB_STRICT_RANDOM - support priority
// SEQ_ARB_USER - user defined

class transaction extends uvm_sequence_item;
    
    rand bit [3:0] a;
    rand bit [3:0] b;
         bit [4:0] y;

    function new(string name = "transaction");
        super.new(name);
    endfunction

    `uvm_object_utils_begin(transaction)
        `uvm_field_int(a, UVM_DEFAULT)
        `uvm_field_int(b, UVM_DEFAULT)
        `uvm_field_int(y, UVM_DEFAULT)
    `uvm_object_utils_end

endclass

///////////////////////////////////////////////////

class sequence1 extends uvm_sequence #(transaction);
    `uvm_object_utils(sequence1)

    function new(string name = "sequence1");
        super.new(name);
    endfunction

    transaction tr;

    virtual task body();
        tr = transaction::type_id::create("tr");
        `uvm_info("SEQUENCE1","Sequence 1 ended", UVM_NONE)
        start_item(tr);
        assert(tr.randomize());
        finish_item(tr);
        `uvm_info("SEQUENCE1","Sequence 1 ended", UVM_NONE)
    endtask

endclass

///////////////////////////////////////////////////

class sequence2 extends uvm_sequence #(transaction);
    `uvm_object_utils(sequence2)

    function new(string name = "sequence2");
        super.new(name);
    endfunction

    transaction tr;

    virtual task body();
        tr = transaction::type_id::create("tr");
        `uvm_info("SEQUENCE2","Sequence 2 ended", UVM_NONE)
        start_item(tr);
        assert(tr.randomize());
        finish_item(tr);
        `uvm_info("SEQUENCE2","Sequence 2 ended", UVM_NONE)
    endtask

endclass

///////////////////////////////////////////////////////////////////////

class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver)

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    transaction tr;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(tr);
            seq_item_port.item_done();
        end
    endtask

endclass

/////////////////////////////////////////////////////////////////////

class agent extends uvm_agent;
    `uvm_component_utils(agent)

    driver drv;
    uvm_sequencer #(transaction) seqr;

    function new(string name = "agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        drv = driver::type_id::create("drv", this);
        seqr = uvm_sequencer #(transaction)::type_id::create("seqr", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
    
endclass

/////////////////////////////////////////////////////////////////// 

class env extends uvm_env;
    `uvm_component_utils(env)

    agent agt;

    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = agent::type_id::create("agt", this);
    endfunction

endclass

///////////////////////////////////////////////////////////////////

class test extends uvm_test;
    `uvm_component_utils(test)

    env e;
    sequence1 s1;
    sequence2 s2;

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
        s1 = sequence1::type_id::create("s1");
        s2 = sequence2::type_id::create("s2");
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        // arbitration methods usage example:
        // e.agt.seqr.set_arbitration(UVM_SEQ_ARB_STRICT_FIFO);
        // e.agt.seqr.set_arbitration(UVM_SEQ_ARB_STRICT_RANDOM);
        // e.agt.seqr.set_arbitration(UVM_SEQ_ARB_RANDOM);
        e.agt.seqr.set_arbitration(UVM_SEQ_ARB_WEIGHTED);
        fork
            // s2 has lower priority than s1
            repeat(5) s2.start(e.agt.seqr,null,100); // (sequencer location, parent sequence, priority, call_pre_post)
            repeat(5) s1.start(e.agt.seqr, null,200); // 
        join 
        phase.drop_objection(this);
    endtask

endclass

///////////////////////////////////////////////////////////////////

module tb;

    initial begin
        run_test("test");
    end

endmodule
