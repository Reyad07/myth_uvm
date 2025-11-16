`include "uvm_macros.svh"
import uvm_pkg::*;

class drv extends uvm_driver;

    `uvm_component_utils(drv)

    function new(string path = "drv", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual adder_if aif;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(virtual adder_if)::get(this,"","aif",aif))
            `uvm_error("DRV", "Unable to access the interface")

    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        for (int i=0; i<10; i++)
        begin
            aif.a = $urandom;
            aif.b = $urandom;
            aif.cin = $urandom;
            #10;
        end
        phase.drop_objection(this);
    endtask
endclass

/////////////////////////////////////////////////////////////////////////////

class agent extends uvm_agent;
    `uvm_component_utils(agent)

    drv d;
 
    function new(string path = "agent", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        d = drv::type_id::create("d",this);
    endfunction

endclass

/////////////////////////////////////////////////////////////////////////////

class env extends uvm_agent;
    `uvm_component_utils(env)

    agent a;
 
    function new(string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a = agent::type_id::create("a",this);
    endfunction

endclass

/////////////////////////////////////////////////////////////////////////////

class test extends uvm_agent;
    `uvm_component_utils(test)

    env e;
 
    function new(string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e",this);
    endfunction

endclass

/////////////////////////////////////////////////////////////////////////////

module tb;

    adder_if aif();

    adder (.a(aif.a),
            .b(aif.b),
            .cin(aif.cin),
            .add(aif.dout)
            );
    
    initial begin
        uvm_config_db#(virtual adder_if)::set(null,"uvm_test_top.e.a.d","aif",aif);
        run_test("test");
    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
    end

endmodule
