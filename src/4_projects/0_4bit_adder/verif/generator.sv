`include "uvm_macros.svh"
import uvm_pkg::*;

class generator extends uvm_sequence #(transaction);
    `uvm_object_utils(generator)

    function new (string name = "generator");
        super.new(name);
    endfunction

    transaction tr;

    virtual task body();
        tr = transaction::type_id::create("tr");

        repeat(5) begin
            start_item(tr);
            assert(tr.randomize());
            `uvm_info("GENERATOR",$sformatf("Data send to driver: a: %0d, b: %0d", tr.a,tr.b), UVM_NONE)
            finish_item(tr);
        end
    endtask

endclass : generator