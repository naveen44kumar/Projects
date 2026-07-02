class uart_cov extends uvm_subscriber #(uart_txn);
    `uvm_component_utils(uart_cov);
    
    uart_txn txn;

    covergroup uart_txn_cg;
        tx_data_cg: coverpoint txn.tx_data {
            bins tx_data_bins_small  = {[0:83]};
            bins tx_data_bins_medium = {[84:167]};
            bins tx_data_bins_large  = {[168:255]};
        }
        baud_cg: coverpoint txn.baud{
            bins b4800 = {4800};
            bins b9600 = {9600};
            bins b14400 = {14400};
            bins b19200 = {19200};
            bins b38400 = {38400};
            bins b57600 = {57600};
            bins b115200 = {115200};
            bins b128000 = {128000};
        }
        length_cg: coverpoint txn.length {
            bins l5 = {5};
            bins l6 = {6};
            bins l7 = {7};
            bins l8 = {8};
        }
        parity_type_cg: coverpoint txn.parity_type {
            bins even = {0};
            bins odd = {1};
        }
        parity_en_cg: coverpoint txn.parity_en {
            bins disabled = {0};
            bins enabled = {1};
        }
        stop2_cg: coverpoint txn.stop2 {
            bins one_stop_bit = {0};
            bins two_stop_bits = {1};
        }
    endgroup

    function new(string name, uvm_component parent=null);
        super.new(name, parent);
        txn = uart_txn::type_id::create("txn");
        uart_txn_cg = new;
    endfunction

    virtual function void write(uart_txn t);
        this.txn = t;
        uart_txn_cg.sample();
    endfunction
    
endclass