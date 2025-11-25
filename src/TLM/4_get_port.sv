`include "uvm_macros.svh"
import uvm_pkg::*;

class producer extends uvm_component;
    `uvm_component_utils (producer)

    int data = 0;
    uvm_blocking_get_port#(int) port;  // port to get data from consumer

    function new(string path = "producer", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        port = new("port",this); // create port(get)
    endfunction

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        port.get(data);
        `uvm_info("PRODUCER",$sformatf("Data Received: %0d",data),UVM_NONE)
        phase.drop_objection(this);
    endtask
endclass

///////////////////////////////////////////////////////////////////

class consumer extends uvm_component;
    `uvm_component_utils(consumer)

    int data = 23;
    uvm_blocking_get_imp #(int, consumer) imp;  // implementation method

    function new(string path = "consumer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this); // create implementation(imp)
    endfunction

    virtual task get(output int datarecv); // implementation of get method called from producer
        `uvm_info("CONSUMER",$sformatf("Data sent: %0d",data), UVM_NONE)
        datarecv = data;
    endtask

endclass

/////////////////////////////////////////////////////////////////

class env extends uvm_component;
    `uvm_component_utils(env)

    producer prod;
    consumer cons;

    function new(string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        prod = producer::type_id::create("prod", this);
        cons = consumer::type_id::create("cons", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        //cons.imp.connect(prod.port); // UVM_ERROR: connect implementation to port
        prod.port.connect(cons.imp); // CORRECT METHOD: connect port to implementation
    endfunction

endclass

///////////////////////////////////////////////////////////////////

class test extends uvm_test;
    `uvm_component_utils(test)

    env e;

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
    endfunction

endclass

////////////////////////////////////////////////////////////////////

module tb;
    
    initial begin
        run_test("test");
    end

endmodule
