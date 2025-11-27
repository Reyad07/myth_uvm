`include "uvm_macros.svh"
import uvm_pkg::*;

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    function new (string path = "monitor", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    uvm_analysis_port #(transaction) mon_port;
    virtual adder_if aif;
    transaction tr;

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        mon_port = new("mon_port", this);
        tr = transaction::type_id::create("tr");
        if(!uvm_config_db #(virtual adder_if)::get(this,"","aif",aif))
            `uvm_error("MONITOR","Unable to access interface")
    endfunction

    virtual task run_phase (uvm_phase phase);
        forever begin
            #5; // sample signals every 5 time units since driver applies new stimulus every 5 time units
            tr.a = aif.a;
            tr.b = aif.b;
            tr.y = aif.sum;
            `uvm_info("MONITOR", $sformatf("Monitoring signals(Data send to scoreboard): a: %0d, b: %0d, sum: %0d", tr.a, tr.b, tr.y), UVM_NONE)
            mon_port.write(tr);
        end
    endtask

endclass