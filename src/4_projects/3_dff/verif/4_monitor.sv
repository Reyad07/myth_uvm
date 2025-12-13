`include "uvm_macros.svh"
import uvm_pkg::*;

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    function new(string path = "monitor", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    transaction tr;
    virtual dff_intf vif;
    uvm_analysis_port #(transaction) send;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        send = new("send",this);
        if(!uvm_config_db#(virtual dff_intf)::get(this,"","vif",vif))
            `uvm_error("MON","could not get the interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            repeat (2) @(posedge vif.clk);
            tr.rst = vif.rst;
            tr.din = vif.din;
            tr.dout = vif.dout;
            `uvm_info("MON",$sformatf("RST: %0d, DIN: %0d, DOUT: %0d",tr.rst, tr.din, tr.dout), UVM_NONE)
            send.write(tr);
        end
    endtask

endclass