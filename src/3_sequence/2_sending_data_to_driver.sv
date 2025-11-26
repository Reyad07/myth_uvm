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

/////////////////////////////////////////////////////////////////

class sequence1 extends uvm_sequence #(transaction);
    `uvm_object_utils(sequence1)

    function new(string name = "sequence1");
        super.new(name);
    endfunction

    transaction tr;

    // there are few methods to send data to driver. two of them are:

    // Method 1:
    virtual task body();
        repeat (5) begin
            `uvm_do(tr)
            `uvm_info("SEQUENCE1",$sformatf("a: %0d, b: %0d",tr.a, tr.b), UVM_NONE)
        end
    endtask

    // Method 2:
    // virtual task body();
    //     repeat (5) begin
    //         tr = transaction::type_id::create("tr");
    //         start_item(tr);
    //         assert(tr.randomize());
    //         finish_item(tr);
    //         `uvm_info("SEQUENCE1",$sformatf("a: %0d, b: %0d",tr.a, tr.b), UVM_NONE)
    //     end
    // endtask

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
            `uvm_info("DRIVER",$sformatf("a: %0d, b: %0d",tr.a, tr.b), UVM_NONE)
            seq_item_port.item_done();
        end
    endtask

endclass

///////////////////////////////////////////////////////////////////

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
    sequence1 s1;

    function new(string name = "env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = agent::type_id::create("agt", this);
        s1 = sequence1::type_id::create("s1",this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        s1.start(agt.seqr);
        phase.drop_objection(this);
    endtask

endclass

///////////////////////////////////////////////////////////////////

class test extends uvm_test;
    `uvm_component_utils(test)

    env e;

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
    endfunction

endclass

///////////////////////////////////////////////////////////////////

module tb;

    initial begin
        run_test("test");
    end

endmodule