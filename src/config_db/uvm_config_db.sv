`include "uvm_macros.svh"
import uvm_pkg::*;

class comp1 extends uvm_component;
  
    `uvm_component_utils(comp1)
  
    function new(string path="comp1", uvm_component parent = null);
        super.new(path,parent);
    endfunction
  
    int a;
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        
        // null: concatenation starts from uvm_test_top.data
        // this: concatenation starts from top: uvm_test_top.env.agent.comp1.data
        if(!uvm_config_db#(int)::get(this,"uvm_test_top","data",a)) // uvm_test_top.env.agent.comp1.data
            `uvm_error("COMP1", "Unable to access interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("COMP1", $sformatf("value of a is %0d",a),UVM_NONE)
        phase.drop_objection(this);
    endtask

endclass

////////////////////////////////////////////////////////////////////////

class comp2 extends uvm_component;
  
    `uvm_component_utils(comp2)
  
    function new(string path="comp2", uvm_component parent = null);
        super.new(path,parent);
    endfunction
  
    int b;
  
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // null: concatenation starts from uvm_test_top.data
        // this: concatenation starts from top: uvm_test_top.env.agent.comp2.data
        if(!uvm_config_db#(int)::get(this,"","data",b)) // uvm_test_top.env.agent.comp2.data
            `uvm_error("COMP2", "Unable to access interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("COMP2", $sformatf("value of b is %0d",b),UVM_NONE)
        phase.drop_objection(this);
    endtask

endclass

////////////////////////////////////////////////////////////////////////

class agent extends uvm_agent;

    `uvm_component_utils(agent)

    function new(string path ="agent",uvm_component parent=null);
        super.new(path,parent);
    endfunction

    comp1 c1;
    comp2 c2;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        c1=comp1::type_id::create("c1",this);
        c2=comp2::type_id::create("c2",this);
    endfunction

endclass

////////////////////////////////////////////////////////////////////////

class env extends uvm_env;
    
    `uvm_component_utils(env)

    function new(string path = "env", uvm_component parent);
        super.new(path,parent);
    endfunction

    agent a;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a=agent::type_id::create("a",this);
    endfunction

endclass

////////////////////////////////////////////////////////////////////////

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
        uvm_top.print_topology();
    endfunction

endclass

////////////////////////////////////////////////////////////////////////

module tb;

    int rest = 20;

    initial begin
        uvm_config_db#(int)::set(null,"uvm_test_top.e.*","data",rest);  // concatenates: uvm_test_top.data
        run_test("test");   //name of the test to run::class name
    end

endmodule