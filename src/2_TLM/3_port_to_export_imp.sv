`include "uvm_macros.svh"
import uvm_pkg::*;

class producer extends uvm_component;
    `uvm_component_utils(producer)

    int data = 21;
    uvm_blocking_put_port#(int) port;  // port to send data to consumer

    function new(string path = "producer", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        port = new("port",this); // create port(send)
    endfunction

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("PRODUCER",$sformatf("Data Sent: %0d",data),UVM_NONE)
        port.put(data);
        phase.drop_objection(this);
    endtask

endclass

///////////////////////////////////////////////////////////////////

class sub_consumer extends uvm_component;
    `uvm_component_utils(sub_consumer)

    uvm_blocking_put_imp #(int, sub_consumer) imp;  // implementation method

    function new(string path = "sub_consumer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this); // create implementation(imp)
    endfunction

    function void put(int datarecv); // implementation of put method called from producer
        `uvm_info("SUB-CONSUMER",$sformatf("Data Received: %0d",datarecv),UVM_NONE)
    endfunction
endclass

/////////////////////////////////////////////////////////////////

class consumer extends uvm_component;
    `uvm_component_utils(consumer)

    sub_consumer sc;
    uvm_blocking_put_export#(int) exp;

    function new(string path = "consumer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        exp = new("exp", this);
        sc = sub_consumer::type_id::create("sc", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        exp.connect(sc.imp); // connect export to subconsumer implementation
    endfunction

endclass

///////////////////////////////////////////////////////////////////

class env extends uvm_env;
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
        prod.port.connect(cons.exp); // connect port(send) to consumer export(exp)
    endfunction
    
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        uvm_top.print_topology();
    endfunction

endclass

/////////////////////////////////////////////////////////////////

class test extends uvm_test;
    `uvm_component_utils(test)

    env e;
    
    function new(string path = "test", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        e = env::type_id::create("e", this);
    endfunction

endclass

////////////////////////////////////////////////////////////////

module tb;
    initial begin
        run_test("test");
    end
endmodule
