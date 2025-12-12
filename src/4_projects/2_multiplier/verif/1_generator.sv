`include "uvm_macros.svh"
import uvm_pkg::*;

class generator extends uvm_sequence #(transaction);

    `uvm_object_utils(generator)

    function new(string path = "generator");
        super.new(path);
    endfunction

    transaction tr;

    virtual task body();
        repeat (20) begin
            tr = transaction::type_id::create("tr");
            start_item(tr);
            assert(tr.randomize());
            `uvm_info("GEN",$sformatf("Generated a: %0d, b: %0d, product: %0d", tr.a,tr.b, tr.product), UVM_NONE)
            finish_item(tr);
        end
    endtask

endclass