`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver #(transaction);
    `uvm_component_utils(driver)

    function new(string path = "driver", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    transaction tr;
    virtual dff_intf vif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        if(!uvm_config_db #(virtual dff_intf)::get(this,"","vif", vif))
            `uvm_error("DRV","Failed to get interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            seq_item_port.get_next_item(tr);
            vif.rst <= tr.rst;
            vif.din <= tr.din;
            `uvm_info("DRV",$sformatf("RST: %0d, DIN: %0d, DOUT: %0d",tr.rst, tr.din, tr.dout), UVM_NONE)
            seq_item_port.item_done(tr);
            repeat(2) @(posedge vif.clk);
        end
    endtask

endclass