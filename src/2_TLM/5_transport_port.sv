`include "uvm_macros.svh"
import uvm_pkg::*;

// transport port is used for bidirectional communication between components

class producer extends uvm_component;
    `uvm_component_utils(producer)

    int datasend = 12;
    int datarecv = 0;
    uvm_blocking_transport_port #(int, int) port;  // port to send and get data from consumer

    function new(string path = "producer", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        port = new("port",this); // create port(send/get)
    endfunction

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        port.transport(datasend, datarecv);
        `uvm_info("PRODUCER",$sformatf("Data Sent: %0d, Data Received: %0d",datasend, datarecv),UVM_NONE)
        phase.drop_objection(this);
    endtask

endclass

///////////////////////////////////////////////////////////////////

class consumer extends uvm_component;
    `uvm_component_utils(consumer)

    int datasend = 19;
    int datarecv = 0;
    uvm_blocking_transport_imp #(int, int, consumer) imp;  // implementation method

    function new(string path = "consumer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this); // create implementation(imp)
    endfunction

    virtual task transport ( int datarecv, output int datasend); // implementation of transport method called from producer
        datasend = this.datasend;
        `uvm_info("CONSUMER", $sformatf("Data Sent: %0d, Data Received: %0d",datasend, datarecv), UVM_NONE)
    endtask

endclass

/////////////////////////////////////////////////////////////////

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
        prod.port.connect(cons.imp); // connect port and implementation
    endfunction

endclass

////////////////////////////////////////////////////////////////////

class test extends uvm_test;
    `uvm_component_utils(test)

    env my_env;

    function new(string name = "test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        my_env = env::type_id::create("my_env", this);
    endfunction

endclass

/////////////////////////////////////////////////////////////////

module tb;

    initial begin
        run_test("test");
    end

endmodule