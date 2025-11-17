`include "uvm_macros.svh"
import uvm_pkg::*;

class drv extends uvm_driver;
    `uvm_component_utils(drv)

    function new(string path = "drv", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("drv","Inside driver build_phase",UVM_NONE)
    endfunction
endclass

////////////////////////////////////////////////////////////////////////////
class mon extends uvm_monitor;
    `uvm_component_utils(mon)

    function new(string path = "mon", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("monitor","Inside monitor build_phase",UVM_NONE)
    endfunction
endclass

////////////////////////////////////////////////////////////////////////////
class env extends uvm_env;
    `uvm_component_utils(env)

    drv d;
    mon m;

    function new(string path = "env", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        d = drv::type_id::create("d",this);
        m = mon::type_id::create("m",this);
        `uvm_info("environment","Inside environment build_phase",UVM_NONE)
    endfunction
endclass

////////////////////////////////////////////////////////////////////////////

class test extends uvm_env;
    `uvm_component_utils(test)

    env e;

    function new(string path = "env", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e",this);
        `uvm_info("test","Inside test build_phase",UVM_NONE)
    endfunction
endclass

////////////////////////////////////////////////////////////////////////////

module tb;

    initial begin
        run_test("test");
    end

endmodule