

module top;
  `include "uvm_macros.svh"
  import uvm_pkg::*; 
  import router_pkg::*;
  
  bit clock;
  
  
   always #5 clock =~clock;

  
  router_if in(clock);
  router_if in0(clock);
  router_if in1(clock);
  router_if in2(clock);
  
  router_1x3 DUV(.clock(clock),
                 .resetn(in.rst),
                 .pkt_valid(in.pkt_valid),
                 .data_in(in.data_in),
                 .read_enb_0(in0.read_enb),
                 .read_enb_1(in1.read_enb),
                 .read_enb_2(in2.read_enb),
                 .data_out_0(in0.data_out),
                 .data_out_1(in1.data_out),
                 .data_out_2(in2.data_out),
                 .valid_out_0(in0.vld_out),
                 .valid_out_1(in1.vld_out),
                 .valid_out_2(in2.vld_out),
                 .busy(in.busy),
                 .err(in.error)
                );
  initial
    begin
      
      uvm_config_db#(virtual router_if)::set(null,"*","vif",in);
      uvm_config_db#(virtual router_if)::set(null,"*","vif_0",in0);
      uvm_config_db#(virtual router_if)::set(null,"*","vif_1",in1);
      uvm_config_db#(virtual router_if)::set(null,"*","vif_2",in2);

      run_test("router_rndm_pkt_test");
      
    end
  
  property pkt_vld;
  
    @(posedge clock)
    $rose(in.pkt_valid) |=> in.busy;
    
  endproperty
  
  
  
  property stable;
  
    @(posedge clock)
    in.busy |=> $stable(in.data_in);
    
  endproperty
  
  
  property read1;
  
   @(posedge clock)
   $rose(in1.vld_out) |=> ##[0:29] in1.read_enb;
   
  endproperty
  
  
  property read2;
  
    @(posedge clock)
    $rose(in2.vld_out) |=> ##[0:29] in2.read_enb;
    
  endproperty
  
  property read0;
  
    @(posedge clock)
    $rose(in0.vld_out) |=> ##[0:29] in0.read_enb;
    
  endproperty
  
  property pkt_valid1;
  
    bit[1:0]addr;
    @(posedge clock)
    ($rose(in.pkt_valid),addr=in.data_in[1:0]) ##3(addr==0) |->in0.vld_out;
    
  endproperty
  
     
  property pkt_valid2;
  
    bit[1:0]addr;
    @(posedge clock)
    ($rose(in.pkt_valid),addr=in.data_in[1:0]) ##3(addr==0) |->in1.vld_out;
    
  endproperty
     
  property pkt_valid3;
  
    bit[1:0]addr;
    @(posedge clock)
    ($rose(in.pkt_valid),addr=in.data_in[1:0]) ##3(addr==0) |->in2.vld_out;
    
  endproperty
     
  property pkt_valid;
  
    @(posedge clock)
    $rose(in.pkt_valid) |-> ##3 in0.vld_out | in2.vld_out |in1.vld_out;
    
  endproperty
     

       
   property read_enb_1;
   
     bit[1:0]addr;
     @(posedge clock)
     (in1.vld_out) ##1 !in1.vld_out |=>$fell(in1.read_enb);
     
   endproperty
       
  property read_enb_2;
  
    bit[1:0]addr;
    @(posedge clock)
    (in2.vld_out) ##1 !in2.vld_out |=>$fell(in2.read_enb);
    
  endproperty
       
  property read_enb_3;
  
    bit[1:0]addr;
    @(posedge clock)
    (in0.vld_out) ##1 !in0.vld_out |=>$fell(in0.read_enb);
    
  endproperty
  
  
  V:assert property(pkt_valid);
  V1:assert property(pkt_valid1);
  V2:assert property(pkt_valid2);
  V3:assert property(pkt_valid3);
  RR1:assert property(read_enb_1);  
  RR2:assert property(read_enb_2);
  RR3:assert property(read_enb_3);
  R2:assert property(read2);
  R1:assert property(read1);
  R3:assert property(read0);
  A1:assert property(pkt_vld);
  A2:assert property(stable);
  
  initial 
    begin
      $dumpfile("dump.vcd");
      $dumpvars(top);
    end
  
endmodule