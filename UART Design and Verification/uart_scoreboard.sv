class uart_sb extends uvm_scoreboard;
    `uvm_component_utils(uart_sb);

    uvm_tlm_analysis_fifo #(uart_txn) mon2sb;
    uvm_tlm_analysis_fifo #(uart_txn) rm2sb;
    function new(input string name="uart_sb",uvm_component parent=null);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon2sb=new("mon2sb",this);
        rm2sb=new("rm2sb",this);
    endfunction

    task run_phase(uvm_phase phase);
        uart_txn exp_rm, act_mon;
        forever begin
            mon2sb.get(act_mon);
            rm2sb.get(exp_rm);
            $display("-------------------Scoreboard  ---------------------------");
            if(act_mon.rx_out !== exp_rm.rx_out || act_mon.rx_done !== exp_rm.rx_done || act_mon.rx_err !== exp_rm.rx_err) begin
                `uvm_error("uart_sb", $sformatf("Mismatch detected: Expected rx_out=%0h, rx_done=%0b, rx_err=%0b; Actual rx_out=%0h, rx_done=%0b, rx_err=%0b", exp_rm.rx_out, exp_rm.rx_done, exp_rm.rx_err, act_mon.rx_out, act_mon.rx_done, act_mon.rx_err))
            end else begin
                `uvm_info("uart_sb", $sformatf("Match detected: rx_out=%0h, rx_done=%0b, rx_err=%0b", act_mon.rx_out, act_mon.rx_done, act_mon.rx_err), UVM_LOW)
            end
        end
    endtask
endclass



    