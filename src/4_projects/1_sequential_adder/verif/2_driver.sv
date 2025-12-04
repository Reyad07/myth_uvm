`include "uvm_macros.svh"
import uvm_pkg::*;

class driver extends uvm_driver #(transaction);

    `uvm_component_utils(driver)

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    transaction tr;
    virtual seq_adder_if aif;

    task reset_dut();
        `uvm_info("DRIVER","Initiating DUT Reset........", UVM_NONE)
        aif.rst_n <= 1'b0;
        aif.a <= 1'b0;
        aif.b <= 1'b0;
        repeat(5) @(posedge aif.clk);
        aif.rst_n <= 1'b1;
        `uvm_info("DRIVER","DUT Reset Done", UVM_NONE)
    endtask

    virtual function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        tr = transaction::type_id::create("tr");
        if(!uvm_config_db #(virtual seq_adder_if)::get(this,"","aif",aif))
            `uvm_error("DRIVER","Unable to access interface")
    endfunction

    virtual task run_phase (uvm_phase phase);
    reset_dut();
        forever begin
            seq_item_port.get_next_item(tr);
            aif.a <= tr.a;
            aif.b <= tr.b;
            `uvm_info("DRIVER", $sformatf("Driving signals: a: %0d, b: %0d", tr.a, tr.b), UVM_NONE)
            seq_item_port.item_done();
            repeat (2) @(posedge aif.clk); // each new stimulus applied after 2 clock cycles
        end
    endtask

endclass
