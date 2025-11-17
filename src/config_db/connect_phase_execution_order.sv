`include "uvm_macros.svh"
import uvm_pkg::*;

class drv extends uvm_driver;
    `uvm_component_utils(drv)

    function new(string path = "drv", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("drv","Inside driver connect_phase",UVM_NONE)
    endfunction
endclass

////////////////////////////////////////////////////////////////////////////
class mon extends uvm_monitor;
    `uvm_component_utils(mon)

    function new(string path = "mon", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("mon","Inside monitor connect_phase",UVM_NONE)
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
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("env","Inside environment connect_phase",UVM_NONE)
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
    endfunction
    
    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("test","Inside test connect_phase",UVM_NONE)
    endfunction

endclass

////////////////////////////////////////////////////////////////////////////

module tb;

    initial begin
        run_test("test");
    end

endmodule