`include "uvm_macros.svh"
import uvm_pkg::*;

class din_sequence_generator extends uvm_sequence #(transaction);

    `uvm_object_utils(din_sequence_generator)

    function new (string path = "din_sequence_generator");
        super.new(path);
    endfunction

    transaction tr;

    virtual task body();
        repeat (5) begin
            tr = transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize());
            tr.rst = 1'b0;
            `uvm_info("SEQ0",$sformatf("RST: %0d, DIN: %0d, DOUT: %0d",tr.rst, tr.din, tr.dout),UVM_NONE)
            finish_item(tr);
        end
    endtask

endclass