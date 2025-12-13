`include "uvm_macros.svh"
import uvm_pkg::*;

class transaction extends uvm_sequence_item;
    `uvm_object_utils(transaction)

    function new (string path = "transaction");
        super.new(path);
    endfunction

    rand bit rst;
    rand bit din;
        bit dout;

endclass