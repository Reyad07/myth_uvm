`include "uvm_macros.svh"
import uvm_pkg::*;

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

/////////////////////////////////////////////////////

class sequence1 extends uvm_sequence #(transaction);
    `uvm_object_utils(sequence1)

    function new(string name = "sequence1");
        super.new(name);
    endfunction

    transaction tr;

    virtual task body();
        repeat (3) begin
            `uvm_info("SEQUENCE1","Sequence 1 started", UVM_NONE)
            tr = transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize());
            finish_item(tr);
            `uvm_info("SEQUENCE1","Sequence 1 ended", UVM_NONE)
        end
    endtask
endclass

/////////////////////////////////////////////////////

class sequence2 extends uvm_sequence #(transaction);
    `uvm_object_utils(sequence2)

    function new(string name = "sequence2");
        super.new(name);
    endfunction

    transaction tr;

    virtual task body();
        repeat (3) begin
            `uvm_info("SEQUENCE2","Sequence 2 started", UVM_NONE)
            tr = transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize());
            finish_item(tr);
            `uvm_info("SEQUENCE2","Sequence 2 ended", UVM_NONE)
        end
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
        fork
            s2.start(e.agt.seqr,null,100);
            s1.start(e.agt.seqr, null,200); 
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
