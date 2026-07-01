class uart_env extends uvm_env;
    `uvm_component_utils(uart_env);

    uart_agt agt;
    uart_sb sb;
    uart_cov cv;
    uart_rm rm;

    function new(input string name="uart_env", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agt = uart_agt::type_id::create("agt", this);
        sb = uart_sb::type_id::create("sb", this);
        cv = uart_cov::type_id::create("cv", this);
        rm = uart_rm::type_id::create("rm", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        agt.mon.mon2sb.connect(sb.mon2sb.analysis_export);
        agt.mon.mon2sb.connect(rm.mon2rm);
        agt.mon.mon2sb.connect(cv.analysis_export);
        rm.rm2sb.connect(sb.rm2sb.analysis_export);
    endfunction
endclass