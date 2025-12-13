`include "uvm_macros.svh"
import uvm_pkg::*;

class config_dff extends uvm_object;
    `uvm_object_utils(config_dff)

    uvm_active_passive_enum agent_type = UVM_ACTIVE;    // Driver + monitor -> active, only monitor -> passive

    function new (string path = "config_dff");
        super.new(path);
    endfunction

endclass