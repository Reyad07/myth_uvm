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

////

    virtual task main_phase(uvm_phase phase);
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

/////

class mon extends uvm_monitor;
    `uvm_component_utils(mon)

    function new(string path = "mon", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction

    virtual task reset_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("MON","Reset phase started",UVM_NONE)
        #10;
        `uvm_info("MON","Reset phase ended",UVM_NONE)
        phase.drop_objection(this);
    endtask

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("MON","Main phase started",UVM_NONE)
        #50;
        `uvm_info("MON","Main phase ended",UVM_NONE)
        phase.drop_objection(this);
    endtask

    virtual task post_main_phase(uvm_phase phase);
        `uvm_info("MON","Inside post_main_phase",UVM_NONE)
    endtask

endclass

////

class env extends uvm_env;
    `uvm_component_utils(env)

    function new(string path = "mon", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    drv d;
    mon m;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        d = drv::type_id::create("d",this);
        m = mon::type_id::create("m",this);
        `uvm_info("ENV",$sformatf("CREATED COMPONENTS: %s  %s", d.get_full_name(), m.get_full_name()), UVM_LOW)

    endfunction

endclass

////

class test extends uvm_test;
    `uvm_component_utils(test);

    function new(string path = "test", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    env e;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e",this);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        uvm_phase main_phase;
        super.end_of_elaboration_phase(phase);
        main_phase = phase.find_by_name("main",0); // Get main phase handle
        main_phase.phase_done.set_drain_time(this,20ns); // Set drain time for main phase
    endfunction
endclass

//////////////////////////////////////////////////////////////////

module tb;
    initial begin
        uvm_top.set_timeout(200ns,0); // Set global timeout to 100ns and override to 0
        run_test("test");
    end
endmodule