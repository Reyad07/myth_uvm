`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver)

    function new(string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual mult_if vif;
    transaction tr; // data container for the data that we receive from the sequencer

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        if(!uvm_config_db #(virtual mult_if)::get(this,"","vif",vif))
            `uvm_error("DRV","Could not get mult interface")
    endfunction

    virtual task run_phase (uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(tr);
            vif.a <= tr.a;
            vif.b <= tr.b;
            `uvm_info("DRV",$sformatf("a: %0d, b: %0d, product: %0d", tr.a,tr.b, tr.product), UVM_NONE)
            seq_item_port.item_done();  // notify/acknowledge the sequencer that we are done
            #10;
        end
    endtask

endclass
