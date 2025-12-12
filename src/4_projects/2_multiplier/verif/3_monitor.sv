`include "uvm_macros.svh"
import uvm_pkg::*;

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    function new(string path = "monitor", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    uvm_analysis_port #(transaction) send;
    virtual mult_if vif;
    transaction tr;

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        send = new("send",this);
        if(!uvm_config_db #(virtual mult_if)::get(this,"","vif", vif))
            `uvm_error("MON","could not get mult interface")
    endfunction

    virtual task run_phase (uvm_phase phase);
        forever begin
            #10;
            tr.a = vif.a;
            tr.b = vif.b;
            tr.product = vif.product;
            `uvm_info("MON", $sformatf("a: %0d, b: %0d, product: %0d", tr.a,tr.b, tr.product), UVM_NONE)
            send.write(tr); // send transaction to scoreboard
        end
    endtask
    
endclass