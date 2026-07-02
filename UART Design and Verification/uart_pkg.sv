package uart_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "uart_txn.sv"
    `include "uart_sequence.sv"
    `include "uart_sequencer.sv"
    `include "uart_driver.sv"
    `include "uart_monitor.sv"
    `include "uart_ref_model.sv"
    `include "uart_coverage.sv"
    `include "uart_scoreboard.sv"
    `include "uart_agent.sv"
    `include "uart_env.sv"
    `include "uart_test.sv"
endpackage