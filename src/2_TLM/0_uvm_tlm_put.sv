`include "uvm_macros.svh"
import uvm_pkg::*;

// uvm_blocking_put_port #(parameter)
// uvm_blocking_put_export #(parameter)
// uvm_blocking_put_imp #(parameter, implementer_class)
// connection must end with uvm_blocking_put_imp
// for tlm connection between driver and monitor, the connection 
// must be in connect_phase of agent
// for tlm connection between scoreboard and monitor/driver, the connection
// must be in connect_phase of env

class producer extends uvm_component;
    `uvm_component_utils(producer)

    int data = 9;
    uvm_blocking_put_port #(int) send;  // port to send data to consumer

    function new(string path = "producer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        send = new("send", this);
    endfunction

    virtual task main_phase(uvm_phase phase);
        phase.raise_objection(this);
        send.put(data); // Call put method on connected consumer and send data
        `uvm_info("PRODUCER", $sformatf("Sent data: %0d", data), UVM_NONE)
        phase.drop_objection(this);
    endtask

endclass

///////////////////////////////////////////////////////////////////

class consumer extends uvm_component;
    `uvm_component_utils(consumer)

    uvm_blocking_put_export #(int) recv;    // export to receive data from producer
    uvm_blocking_put_imp #(int, consumer) imp;  // implementation method

    function new(string path = "consumer", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase (phase);
        recv = new("recv", this);   //  create export(recv)
        imp = new("imp", this);   // create implementation(imp)
    endfunction

    task put(int datarecv); // implementation of put method called from producer
        `uvm_info("CONSUMER", $sformatf("Received data: %0d", datarecv), UVM_NONE)
    endtask

endclass

///////////////////////////////////////////////////////////////////

class env extends uvm_env;
    `uvm_component_utils(env)

    producer p;
    consumer c;

    function new(string path = "env", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        p = producer::type_id::create("p", this);   
        c = consumer::type_id::create("c", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        p.send.connect(c.recv); // connect port(send) to export(recv)  
        c.recv.connect(c.imp);  // connect export(recv) to implementation(imp)
    endfunction

endclass

///////////////////////////////////////////////////////////////////

class test extends uvm_test;
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

///////////////////////////////////////////////////////////////////

module tb;
    initial begin
        run_test("test");
    end
endmodule
