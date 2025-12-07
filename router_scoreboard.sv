`include "uvm_macros.svh"
import uvm_pkg::*;
import router_pkg::*;
class router_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(router_scoreboard)
  
  uvm_tlm_analysis_fifo#(read_xtn) fifo_rdh[];
  uvm_tlm_analysis_fifo#(write_xtn) fifo_wrh;
  
  write_xtn wr_data;
  read_xtn  rd_data;
  read_xtn read_cov_data;
  write_xtn write_cov_data;
  
  router_env_config e_cfg;
  int data_verified_count;
  bit busy =1;
  
  covergroup router_fcov1;
    option.per_instance=1;
    
    CHANNEL:coverpoint write_cov_data.header[1:0]
    {
      bins low = {2'b00};
      bins mid1= {2'b01};
      bins mid2= {2'b10};
    }
    PAYLOAD_SIZE : coverpoint write_cov_data.header[7:2]
    {
      bins small_packet = {[1:15]};
      bins medium_packet = {[16:30]};
      bins large_packet = {[31:63]};
    }
    
    BAD_PKT : coverpoint write_cov_data.busy
    {
      bins bad_pkt = {1};
    }
    
    CHANNEL_X_PAYLOAD_SIZE : cross CHANNEL,PAYLOAD_SIZE;
    CHANNEL_X_PAYLOAD_SIZE_X_BAD_PKT : cross CHANNEL, PAYLOAD_SIZE,BAD_PKT;
    
  endgroup :router_fcov1
  
 covergroup router_fcov2;
    option.per_instance=1;
    
    CHANNEL:coverpoint read_cov_data.header[1:0]
    {
      bins low = {2'b00};
      bins mid1= {2'b01};
      bins mid2= {2'b10};
    }
    PAYLOAD_SIZE : coverpoint read_cov_data.header[7:2]
    {
      bins small_packet = {[1:15]};
      bins medium_packet = {[16:30]};
      bins large_packet = {[31:63]};
    }
   
    CHANNEL_X_PAYLOAD_SIZE : cross CHANNEL,PAYLOAD_SIZE;
   
  endgroup :router_fcov2 
  
  
  extern function void check_data(read_xtn rd);
  extern function new(string name,uvm_component parent);
  extern function void build_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);
  extern function void report_phase(uvm_phase phase);
endclass



function router_scoreboard::new(string name,uvm_component parent);

  super.new(name,parent);
  router_fcov1=new();
  router_fcov2=new();
  
endfunction

function void router_scoreboard::build_phase(uvm_phase phase);

  super.build_phase(phase);
  
  if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",e_cfg))
    `uvm_fatal("EN_cfg","no update")
    
  wr_data = write_xtn::type_id::create("wr_data",this);
  rd_data = read_xtn::type_id::create("rd_data",this);
  
  fifo_wrh = new("fifo_wrh",this);
  fifo_rdh =new[e_cfg.no_of_read_agent];
  
  foreach (fifo_rdh[i])
    begin
      fifo_rdh[i]=new($sformatf("fifo_rdh[%0d]",i),this);
    end
endfunction

task router_scoreboard::run_phase(uvm_phase phase);
  fork 
    begin
      forever 
        begin
          fifo_wrh.get(wr_data);
          `uvm_info("WRITE SB","write data",UVM_LOW)
          wr_data.print;
          write_cov_data=wr_data;
          router_fcov1.sample();
        end
    end
    
    begin
      forever
        begin
        
          fork
            begin
              fifo_rdh[0].get(rd_data);
              `uvm_info("READ SB[0]","read_data",UVM_LOW)
              rd_data.print;
              check_data(rd_data);
              read_cov_data=rd_data;
              router_fcov2.sample();
            end
             begin
              fifo_rdh[1].get(rd_data);
               `uvm_info("READ SB[1]","read_data",UVM_LOW)
              rd_data.print;
              check_data(rd_data);
              read_cov_data=rd_data;
              router_fcov2.sample();
             end
             begin
               fifo_rdh[2].get(rd_data);
              `uvm_info("READ SB[2]","read_data",UVM_LOW)
              rd_data.print;
              check_data(rd_data);
              read_cov_data=rd_data;
              router_fcov2.sample();
         
             end
          join_any
          
          disable fork;
        end
      end
     join
 endtask
            
function void router_scoreboard::check_data(read_xtn rd);
  if(wr_data.header == rd.header)
    `uvm_info("SB","HEADER MATCHED SUCCESSFULLY",UVM_LOW)
  else
      `uvm_error("SB","HEADER COMPARISION FAILED")
  if(wr_data.payload_data == rd.payload_data)
    `uvm_info("SB","PAYLOAD MATCHED SUCCESSFULLY",UVM_LOW)
  else
      `uvm_error("SB","PAYLOAD COMPARISION FAILED")
  if(wr_data.parity == rd.parity)
    `uvm_info("SB","PARITY MATCHED SUCCESSFULLY",UVM_LOW)
  else
      `uvm_error("SB","PARITY COMPARISION FAILED")
 data_verified_count++;
endfunction
            
function void router_scoreboard::report_phase(uvm_phase phase);
  `uvm_info(get_type_name(),$sformatf("Report: Number of data verified in SB %0d",data_verified_count),UVM_LOW)
endfunction
