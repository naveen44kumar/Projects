class uart_agt extends uvm_agent;
    `uvm_component_utils(uart_agt);

    uart_seqr seqr;
    uart_drv drv;
    uart_mon mon;

    function new(input string name= "uart_agt", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seqr = uart_seqr::type_id::create("seqr", this);
        drv = uart_drv::type_id::create("drv", this);
        mon = uart_mon::type_id::create("mon", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(seqr.seq_item_export);
    endfunction
endclass



