`include "uvm_macros.svh"
import uvm_pkg::*;

class test_top extends uvm_test;
    `uvm_component_utils(test_top)

    function new(string path = "test_top", uvm_component parent = null);
        super.new(path, parent);
    endfunction

    // construction phases
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("test_top","Inside build_phase",UVM_NONE);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("test_top","Inside connect_phase",UVM_NONE);
    endfunction

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        super.end_of_elaboration_phase(phase);
        `uvm_info("test_top","Inside end_of_elaboration_phase",UVM_NONE);
    endfunction

    virtual function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        `uvm_info("test_top","Inside start_of_simulation_phase",UVM_NONE);
    endfunction

    // Main phase
    virtual task run_phase(uvm_phase phase);
        `uvm_info("test_top","Inside run_phase",UVM_NONE);
    endtask

    // cleanup phases
    virtual function void extract_phase(uvm_phase phase);
        super.extract_phase(phase);
        `uvm_info("test_top","Inside extract_phase",UVM_NONE);
    endfunction

    virtual function void check_phase(uvm_phase phase);
        super.check_phase(phase);
        `uvm_info("test_top","Inside check_phase",UVM_NONE);
    endfunction

    virtual function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("test_top","Inside report_phase",UVM_NONE);
    endfunction

    virtual function void final_phase(uvm_phase phase);
        super.final_phase(phase);
        `uvm_info("test_top","Inside final_phase",UVM_NONE);
    endfunction

endclass

/////////////////////////////////////////////////////////////////////////////

module tb;

    initial begin
        run_test("test_top");
    end
endmodule