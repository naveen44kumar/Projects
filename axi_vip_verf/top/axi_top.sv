module top;
  import uvm_pkg::*;
  import axi_pkg::*;

  bit clock;

  always #5 clock = ~clock;

  axi in0(clock);

  initial
    begin
      uvm_config_db #(virtual axi) :: set(null,"*","axi",in0);
      uvm_top.enable_print_topology = 1;
      run_test();
    end

endmodule
