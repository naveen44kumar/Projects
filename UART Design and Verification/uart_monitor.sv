class uart_mon extends uvm_monitor;
    `uvm_component_utils(uart_mon);
    uvm_analysis_port #(uart_txn) mon2sb;
    virtual uart_if.mon_mp vif;
    uart_txn txn;
    bit prev_rx_done;

    function new(string name="uart_mon", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual uart_if.mon_mp)::get(this,"","vif",vif))
            `uvm_fatal("MONITOR", $sformatf("Virtual interface must be set for: %s.vif", get_full_name()))
        txn=uart_txn::type_id::create("txn");
        mon2sb=new("mon2sb",this);
    endfunction

    task run_phase(uvm_phase phase);
        forever begin
            @(posedge vif.clk);
            if(vif.mon_cb.rx_done && !prev_rx_done) begin
                txn = uart_txn::type_id::create("txn");
                txn.tx_start = vif.mon_cb.tx_start;
                txn.rx_start = vif.mon_cb.rx_start;
                txn.tx_data = vif.mon_cb.tx_data;
                txn.baud = vif.mon_cb.baud;
                txn.length = vif.mon_cb.length;
                txn.parity_type = vif.mon_cb.parity_type;
                txn.parity_en = vif.mon_cb.parity_en;
                txn.stop2 = vif.mon_cb.stop2;
                txn.tx_done = vif.mon_cb.tx_done;
                txn.tx_err = vif.mon_cb.tx_err;
                txn.rx_out = vif.mon_cb.rx_out;
                txn.rx_done = vif.mon_cb.rx_done;
                txn.rx_err = vif.mon_cb.rx_err;
                mon2sb.write(txn);
                `uvm_info("uart_mon", $sformatf("-------------------Transaction received-------------------\n: rx_out=%0h, rx_done=%0b, rx_err=%0b", txn.rx_out, txn.rx_done, txn.rx_err), UVM_LOW)
            end
            prev_rx_done = vif.mon_cb.rx_done;
        end
    endtask
endclass