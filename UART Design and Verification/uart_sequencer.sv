class uart_seqr extends uvm_sequencer #(uart_txn);
    `uvm_component_utils(uart_seqr);

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
    endfunction
endclass
