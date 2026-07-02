class uart_drv extends uvm_driver #(uart_txn);
    `uvm_component_utils(uart_drv);

    virtual uart_if.drv_mp vif;
    uart_txn txn;
    localparam int unsigned DONE_TIMEOUT_CLKS = 1_000_000;

    function new(input string name="uart_drv", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db #(virtual uart_if.drv_mp)::get(this,"","vif",vif))
            `uvm_fatal("DRIVER", $sformatf("Virtual interface must be set for: %s.vif", get_full_name()))
        txn=uart_txn::type_id::create("txn");
    endfunction

    task run_phase(uvm_phase phase);
        uart_txn txn;
        bit tx_seen;
        bit rx_seen;

        vif.drv_cb.baud <= 9600;
        vif.drv_cb.length <= 8;
        vif.drv_cb.parity_type <= 0;
        vif.drv_cb.parity_en <= 0;
        vif.drv_cb.stop2 <= 0;
        vif.drv_cb.tx_start <= 0;
        vif.drv_cb.rx_start <= 0;
        vif.drv_cb.rst <= 1;
        repeat (5) @(posedge vif.clk);
        vif.drv_cb.rst <= 0;
        repeat (2) @(posedge vif.clk);
        forever begin
            seq_item_port.get_next_item(txn);
            vif.drv_cb.tx_data<=txn.tx_data;
            vif.drv_cb.baud<=txn.baud;
            vif.drv_cb.length<=txn.length;
            vif.drv_cb.parity_type<=txn.parity_type;
            vif.drv_cb.parity_en<=txn.parity_en;
            vif.drv_cb.stop2<=txn.stop2;
            vif.drv_cb.tx_start<=txn.tx_start;
            vif.drv_cb.rx_start<=txn.rx_start;
            @(posedge vif.clk);

            tx_seen = 0;
            rx_seen = 0;
            repeat (DONE_TIMEOUT_CLKS) begin
                if (vif.drv_cb.tx_done === 1'b1)
                    tx_seen = 1;
                if (vif.drv_cb.rx_done === 1'b1)
                    rx_seen = 1;

                if (tx_seen && rx_seen)
                    break;

                @(posedge vif.clk);
            end

            if (!tx_seen) begin
                `uvm_error("uart_drv", $sformatf("Timeout waiting for tx_done: tx_data=%0h, baud=%0d, length=%0d, parity_type=%0b, parity_en=%0b, stop2=%0b", txn.tx_data, txn.baud, txn.length, txn.parity_type, txn.parity_en, txn.stop2))
                vif.drv_cb.tx_start <= 0;
                vif.drv_cb.rx_start <= 0;
                seq_item_port.item_done();
                continue;
            end

            vif.drv_cb.tx_start<=0;

            if (!rx_seen) begin
                `uvm_error("uart_drv", $sformatf("Timeout waiting for rx_done: tx_data=%0h, baud=%0d, length=%0d, parity_type=%0b, parity_en=%0b, stop2=%0b", txn.tx_data, txn.baud, txn.length, txn.parity_type, txn.parity_en, txn.stop2))
                vif.drv_cb.rx_start <= 0;
                seq_item_port.item_done();
                continue;
            end

            vif.drv_cb.rx_start<=0;
            @(posedge vif.clk);
            while ((vif.drv_cb.tx_done === 1'b1) || (vif.drv_cb.rx_done === 1'b1)) begin
                @(posedge vif.clk);
            end
            repeat (5) @(posedge vif.clk);
            seq_item_port.item_done();
            `uvm_info("uart_drv", $sformatf("-------------------Transaction sent-------------------\n: tx_data=%0h, baud=%0d, length=%0d, parity_type=%0b, parity_en=%0b, stop2=%0b", txn.tx_data, txn.baud, txn.length, txn.parity_type, txn.parity_en, txn.stop2), UVM_LOW)
        end
    endtask
    
endclass





