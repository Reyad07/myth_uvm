`include "uvm_macros.svh"
import uvm_pkg::*;

class agent extends uvm_scoreboard;
    `uvm_component_utils(agent)

    function new(string path = "agent", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    driver drv;
    monitor mon;
    uvm_sequencer #(transaction) seqr;
    config_dff cfg;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = monitor::type_id::create("mon",this);

        cfg = config_dff::type_id::create("cfg",this);

        if(!uvm_config_db #(config_dff)::get(this,"","cfg",cfg))
            `uvm_error("AGENT","could not access config_dff")

        if(cfg.agent_type == UVM_ACTIVE) begin
            drv = driver::type_id::create("drv",this);
            seqr= uvm_sequencer #(transaction)::type_id::create("seqr",this);
        end
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction

endclass