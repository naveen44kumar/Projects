class uart_test extends uvm_test;
    `uvm_component_utils(uart_test);

    uart_env env;
    uart_seq seq;

    function new(input string name="uart_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = uart_env::type_id::create("env", this);
        seq = uart_seq::type_id::create("seq", this);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        seq.start(env.agt.seqr);
        #1000000;
        phase.drop_objection(this);
    endtask
endclass

class uart_test_50 extends uart_test;
    `uvm_component_utils(uart_test_50);

    function new(input string name="uart_test_50", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    task run_phase(uvm_phase phase);
        seq.no_of_txn = 24;
        seq.directed_baud_en = 1;
        seq.directed_tx_data_en = 1;
        super.run_phase(phase);
    endtask
endclass