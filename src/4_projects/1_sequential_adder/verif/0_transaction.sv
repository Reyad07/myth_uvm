`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;

    rand logic [3:0] a;
    rand logic [3:0] b;
         logic [4:0] y;
    
    function new (string path = "transaction");
        super.new(path);
    endfunction

    `uvm_object_utils_begin(transaction)
        `uvm_field_int(a, UVM_DEFAULT)
        `uvm_field_int(b, UVM_DEFAULT)
        `uvm_field_int(y, UVM_DEFAULT)
    `uvm_object_utils_end

endclass