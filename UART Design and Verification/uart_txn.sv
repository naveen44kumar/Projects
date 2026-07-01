class uart_txn extends uvm_sequence_item;
    rand bit tx_start;
    rand bit rx_start;
    rand bit [7:0] tx_data;
    rand bit [16:0] baud;
    rand bit [3:0] length;
    rand bit parity_type;
    rand bit parity_en;
    rand bit stop2;
    bit [7:0] rx_out;
    bit tx_done;
    bit rx_done;
    bit tx_err;
    bit rx_err;  



    `uvm_object_utils(uart_txn)

    constraint valid_cfg_c {
        baud inside {4800, 9600, 14400, 19200, 38400, 57600, 115200, 128000};
        length inside {5, 6, 7, 8};
        tx_start == 1;
        rx_start == 1;
    }

    function new(string name = "uart_txn");
        super.new(name);
    endfunction

endclass


