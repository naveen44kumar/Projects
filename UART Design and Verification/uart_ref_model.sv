class uart_rm extends uvm_component;
    `uvm_component_utils(uart_rm);

    uvm_analysis_imp #(uart_txn, uart_rm) mon2rm;
    uvm_analysis_port #(uart_txn) rm2sb;

    virtual uart_if.mon_mp vif;

    uart_txn exp;

    function new(input string name="rm", uvm_component parent=null);
        super.new(name, parent);
        mon2rm=new("mon2rm", this);
        rm2sb=new("rm2sb", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        exp=uart_txn::type_id::create("exp");

    endfunction

    virtual function void write(uart_txn txn);
        bit parity_bit;

        exp = uart_txn::type_id::create("exp");
        exp.tx_start = txn.tx_start;
        exp.rx_start = txn.rx_start;
        exp.tx_data = txn.tx_data;
        exp.baud = txn.baud;
        exp.length = txn.length;
        exp.parity_type = txn.parity_type;
        exp.parity_en = txn.parity_en;
        exp.stop2 = txn.stop2;

        case(txn.length)
            4'd5: parity_bit = txn.parity_type ? ^(txn.tx_data[4:0]) : ~^(txn.tx_data[4:0]);
            4'd6: parity_bit = txn.parity_type ? ^(txn.tx_data[5:0]) : ~^(txn.tx_data[5:0]);
            4'd7: parity_bit = txn.parity_type ? ^(txn.tx_data[6:0]) : ~^(txn.tx_data[6:0]);
            4'd8: parity_bit = txn.parity_type ? ^(txn.tx_data[7:0]) : ~^(txn.tx_data[7:0]);
            default: parity_bit = 1'b0;
        endcase

        case(txn.length)
            4'd5: exp.rx_out = {3'b0, txn.tx_data[4:0]};
            4'd6: exp.rx_out = {2'b0, txn.tx_data[5:0]};
            4'd7: exp.rx_out = {1'b0, txn.tx_data[6:0]};
            4'd8: exp.rx_out = txn.tx_data[7:0];
            default: exp.rx_out = 8'h00;
        endcase

        exp.rx_err = 'b0;
        exp.tx_err = 'b0;

        exp.tx_done = 1'b1;
        exp.rx_done = 1'b1;

        rm2sb.write(exp);
        `uvm_info("uart_rm", $sformatf("Transaction processed: tx_data=%0h, baud=%0d, length=%0d, parity_type=%0b, parity_en=%0b, stop2=%0b, rx_out=%0h, tx_done=%0b, rx_done=%0b, tx_err=%0b, rx_err=%0b", exp.tx_data, exp.baud, exp.length, exp.parity_type, exp.parity_en, exp.stop2, exp.rx_out, exp.tx_done, exp.rx_done, exp.tx_err, exp.rx_err), UVM_LOW)
    endfunction
endclass




