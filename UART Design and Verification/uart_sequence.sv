class uart_seq extends uvm_sequence #(uart_txn);
    `uvm_object_utils(uart_seq);

    uart_txn txn;
    int no_of_txn=5;
    bit directed_baud_en = 1;
    bit directed_tx_data_en = 1;

    function new(input string name="uart_seq");
        super.new(name);
    endfunction

    task body();
        bit [16:0] baud_list[8] = '{4800, 9600, 14400, 19200, 38400, 57600, 115200, 128000};
        bit [7:0] tx_data_list[3] = '{8'h15, 8'h80, 8'hd5};
        bit [16:0] selected_baud;
        bit [7:0] selected_tx_data;

        for (int i = 0; i < no_of_txn; i++) begin
            txn= uart_txn::type_id::create("txn");
            start_item(txn);

            selected_baud = baud_list[i % 8];
            selected_tx_data = tx_data_list[i % 3];
            if (directed_baud_en && directed_tx_data_en) begin
                assert(txn.randomize() with {
                    baud == selected_baud;
                    tx_data == selected_tx_data;
                }) else `uvm_fatal("uart_seqs", $sformatf("Randomization failed for selected_baud=%0d selected_tx_data=0x%0h", selected_baud, selected_tx_data))
            end
            else if (directed_baud_en) begin
                assert(txn.randomize() with {
                    baud == selected_baud;
                }) else `uvm_fatal("uart_seqs", $sformatf("Randomization failed for selected_baud=%0d", selected_baud))
            end
            else if (directed_tx_data_en) begin
                assert(txn.randomize() with {
                    tx_data == selected_tx_data;
                }) else `uvm_fatal("uart_seqs", $sformatf("Randomization failed for selected_tx_data=0x%0h", selected_tx_data))
            end
            else begin
                assert(txn.randomize())
                    else `uvm_fatal("uart_seqs", "Randomization failed")
            end

            `uvm_info("uart_seqs", $sformatf("-------------------Randomized transaction-------------------\n: tx_data=%0h, baud=%0d, length=%0d, parity_type=%0b, parity_en=%0b, stop2=%0b", txn.tx_data, txn.baud, txn.length, txn.parity_type, txn.parity_en, txn.stop2), UVM_LOW)    
            finish_item(txn);
        end
    endtask
endclass
