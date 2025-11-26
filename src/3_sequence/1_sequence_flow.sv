`include "uvm_macros.svh"
import uvm_pkg::*;

/////////////////////////////////////////////////////////////////////
// just for example; in real scenario it will be defined seperately//
interface adder_if;

  logic [3:0] a;
  logic [3:0] b;
  logic [4:0] y;

endinterface
//////////////////////////////////////////////////////////////////

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

///////////////////////////////////////////////////////////////////

class sequence1 extends uvm_sequence #(transaction);
    `uvm_object_utils(sequence1)

    function new(string name = "sequence1");
        super.new(name);
    endfunction

    transaction tr;

    virtual task body();
        `uvm_info("SEQUENCE1", "Transaction obj created", UVM_NONE)
        tr = transaction::type_id::create("tr");
        `uvm_info("SEQUENCE1","Waiting for grant from driver", UVM_NONE)
        wait_for_grant();
        `uvm_info("SEQUENCE1","Received grant....Randomizing transaction", UVM_NONE)
        assert(tr.randomize());
        `uvm_info("SEQUENCE1","Randomization done...Sending request to driver", UVM_NONE)
        send_request(tr);
        `uvm_info("SEQUENCE1","Waiting for item done resp from driver", UVM_NONE)
        wait_for_item_done();
        `uvm_info("SEQUENCE1","SEQUENCE1 completed", UVM_NONE)
    endtask

endclass

///////////////////////////////////////////////////////////////////

class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver)

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    transaction tr;
    virtual adder_if aif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr", this);
        if (!uvm_config_db #(virtual adder_if)::get(this, "", "aif", aif))
            `uvm_error("DRIVER", "Could not get adder_if interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            `uvm_info("DRIVER", "Sending grant for sequence", UVM_NONE)
            seq_item_port.get_next_item(tr);
            `uvm_info("DRIVER", "Applying stimulus/sequence to DUT", UVM_NONE)
            // apply stimulus to DUT
            `uvm_info("DRIVER", "Sending item done resp to sequence", UVM_NONE)
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
        s1 = sequence1::type_id::create("s1");
    endfunction

endclass

///////////////////////////////////////////////////////////////////

class test extends uvm_test;
    `uvm_component_utils(test)

    sequence1 seq1;
    env e;

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
        seq1 = sequence1::type_id::create("seq1");
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        seq1.start(e.agt.seqr);
        phase.drop_objection(this);
    endtask

endclass

///////////////////////////////////////////////////////////////////

module tb;
    adder_if aif();

    initial begin
        uvm_config_db #(virtual adder_if)::set(null, "*", "aif", aif);
        run_test("test");
    end

endmodule