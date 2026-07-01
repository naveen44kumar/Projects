
import uvm_pkg::*;
`include "uvm_macros.svh"
import uart_pkg::*;

`include "../uart_if.sv"
`include "../uart_top.sv"

module uart_uvm_top;


    logic clk;
    initial  clk = 0;
    always #10 clk = ~clk;

    uart_if vif(.clk(clk));

    uart_top dut(.vif(vif));

    initial begin
        uvm_config_db #(virtual uart_if.drv_mp)::set(null, "*", "vif", vif.drv_mp);
        uvm_config_db #(virtual uart_if.mon_mp)::set(null, "*", "vif", vif.mon_mp);
        run_test("uart_test_50");
    end

endmodule
