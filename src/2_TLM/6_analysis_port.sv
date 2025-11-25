`include "uvm_macros.svh"
import uvm_pkg::*;

// send data from one component to multiple components using analysis port

class producer extends uvm_component;
    `uvm_component_utils(producer)

    int datasend = 24;
    uvm_analysis_port#(int) port;  // port to send data to consumer

    function new(string path = "producer", uvm_component parent = null);
        super.new(path,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        port = new("port",this); // create port(send)
    endfunction

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        port.write(datasend);
        `uvm_info("PRODUCER",$sformatf("Data Sent: %0d",datasend),UVM_NONE)
        phase.drop_objection(this);
    endtask

endclass

///////////////////////////////////////////////////////////////////

class consumer1 extends uvm_component;
    `uvm_component_utils(consumer1)

    uvm_analysis_imp #(int,consumer1) imp;

    function new(string path = "consumer1", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this); // create implementation(imp)
    endfunction

    virtual function void write(int datarecv); // implementation of write method called from producer
        `uvm_info("CONSUMER1",$sformatf("Data Received: %0d",datarecv),UVM_NONE)
    endfunction
endclass

/////////////////////////////////////////////////////////////////
class consumer2 extends uvm_component;
    `uvm_component_utils(consumer2)

    uvm_analysis_imp #(int,consumer2) imp;

    function new(string path = "consumer2", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this); // create implementation(imp)
    endfunction

    virtual function void write(int datarecv); // implementation of write method called from producer
        `uvm_info("CONSUMER2",$sformatf("Data Received: %0d",datarecv),UVM_NONE)
    endfunction
endclass

/////////////////////////////////////////////////////////////////

class env extends uvm_env;
    `uvm_component_utils(env)

    producer p;
    consumer1 c1;
    consumer2 c2;

    function new(string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        p = producer::type_id::create("p", this);
        c1 = consumer1::type_id::create("c1", this);
        c2 = consumer2::type_id::create("c2", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        p.port.connect(c1.imp); // connect port and implementation
        p.port.connect(c2.imp); // connect port and implementation
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

//////////////////////////////////////////////////////////////////

module tb;

    initial begin
        run_test("test");
    end

endmodule
