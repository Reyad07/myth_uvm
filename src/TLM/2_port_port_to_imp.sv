`include "uvm_macros.svh"
import uvm_pkg::*;

class subproducer extends uvm_component;
    `uvm_component_utils(subproducer)

    int data = 21;
    uvm_blocking_put_port#(int) sub_port;  // port to send data to consumer

    function new(string path = "subproducer", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sub_port = new("send",this); // create port(send)
    endfunction

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("SUB-PRODUCER",$sformatf("Data Sent: %0d",data),UVM_NONE)
        sub_port.put(data);
        phase.drop_objection(this);
    endtask

endclass

///////////////////////////////////////////////////////////////////

class producer extends uvm_component;
    `uvm_component_utils(producer)

    uvm_blocking_put_port#(int) port;  // port to send data to consumer
    subproducer s;

    function new(string path = "producer", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        s = subproducer::type_id::create("s", this);
        port = new("send",this); // create port(send)
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        s.sub_port.connect(port); // connect subproducer port to producer port
    endfunction

endclass

///////////////////////////////////////////////////////////////////

class consumer extends uvm_component;
    `uvm_component_utils(consumer)

    uvm_blocking_put_imp #(int, consumer) imp;  // implementation method

    function new(string path = "consumer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this); // create implementation(imp)
    endfunction

    function void put(int datarecv); // implementation of put method called from producer
        `uvm_info("CONSUMER",$sformatf("Data Received: %0d",datarecv),UVM_NONE)
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
        prod.port.connect(cons.imp); // connect port(send) to implementation(imp)
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
