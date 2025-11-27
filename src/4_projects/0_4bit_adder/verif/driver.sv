`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver #(transaction);

    `uvm_component_utils(driver)

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    transaction tr;
    virtual adder_if aif;

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        if(!uvm_config_db #(virtual adder_if)::get(this,"","aif",aif))
            `uvm_error("DRIVER","Unable to access interface")
    endfunction

    virtual task run_phase (uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(tr);
            aif.a <= tr.a;
            aif.b <= tr.b;
            `uvm_info("DRIVER", $sformatf("Driving signals: a: %0d, b: %0d", tr.a, tr.b), UVM_NONE)
            seq_item_port.item_done();
            #5; // each new stimulus applied after 5 time units
        end
    endtask

endclass
