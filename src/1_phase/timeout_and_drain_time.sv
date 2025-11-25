`include "uvm_macros.svh"
import uvm_pkg::*;

class drv extends uvm_driver;
    `uvm_component_utils(drv)

    function new(string path = "drv", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("DRV","Reset phase started",UVM_NONE)
        #10;
        `uvm_info("DRV","Reset phase ended",UVM_NONE)
        phase.drop_objection(this);
    endtask

    virtual task main_phase(uvm_phase phase);
        phase.phase_done.set_drain_time(this,20ns); // Set drain time for main phase
        phase.raise_objection(this);
        `uvm_info("DRV","Main phase started",UVM_NONE)
        #50;
        `uvm_info("DRV","Main phase ended",UVM_NONE)
        phase.drop_objection(this);
    endtask

    virtual task post_main_phase(uvm_phase phase);
        `uvm_info("DRV","Inside post_main_phase",UVM_NONE)
    endtask

endclass

//////////////////////////////////////////////////////////////////

module tb;
    initial begin
        uvm_top.set_timeout(200ns,0); // Set global timeout to 100ns and override to 0
        run_test("drv");
    end
endmodule