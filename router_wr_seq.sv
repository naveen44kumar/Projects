`include "uvm_macros.svh"
import uvm_pkg::*;
import router_pkg::*;


class router_wr_seq extends uvm_sequence #(write_xtn);
  `uvm_object_utils(router_wr_seq)
  
  extern function new(string name="router_wr_seq");
  
endclass :router_wr_seq


function router_wr_seq::new(string name ="router_wr_seq");
    super.new(name);
endfunction



// ----------Small Packet Sequence-------------
class router_wxtns_small_pkt extends router_wr_seq;
  `uvm_object_utils(router_wxtns_small_pkt)
  
  bit[1:0]addr;
  
  extern function new(string name = "router_wxtns_small_pkt");
  extern task body();
  write_xtn req;

endclass 

function router_wxtns_small_pkt::new(string name = "router_wxtns_small_pkt");
    super.new(name);
  endfunction


task router_wxtns_small_pkt::body();
    
    if (!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
      `uvm_fatal(get_type_name(),"getting the configuration faile,check if it set properly")
      
    req = write_xtn::type_id::create("req");
    start_item(req);
    
    assert(req.randomize() with {header[7:2] inside {[1:15]} && header[1:0]==addr;});
    
    `uvm_info("router_WR_SEQUENCE",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)
    finish_item(req);
 
endtask




// ------------Medium Packet sequence-------------

class router_wxtns_medium_pkt extends router_wr_seq;
  `uvm_object_utils(router_wxtns_medium_pkt)
  
  bit[1:0]addr;
  write_xtn req;
  
  extern function new(string name ="router_wxtns_medium_pkt");
  extern task body();
  
  
endclass 


function router_wxtns_medium_pkt::new(string name ="router_wxtns_medium_pkt");
    super.new(name);
endfunction
  
  
task router_wxtns_medium_pkt::body();
    
    if (!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
      `uvm_fatal(get_type_name(),"getting the configuration faile,check if it set properly")
      
    req = write_xtn::type_id::create("req");
    start_item(req);
    
    assert(req.randomize() with {header[7:2] inside {[15:31]} && header[1:0]==addr;});
    
    `uvm_info("router_WR_SEQUENCE",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)
    finish_item(req);
 
endtask


class router_wxtns_big_pkt extends router_wr_seq;
  `uvm_object_utils(router_wxtns_big_pkt)
  write_xtn req;
  bit[1:0]addr;
  
  extern function new(string name="router_wxtns_big_pkt");
  extern task body();  
  
endclass 


function router_wxtns_big_pkt::new(string name="router_wxtns_big_pkt");
    super.new(name);
endfunction

  
  
task router_wxtns_big_pkt::body();
    
    if (!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
      `uvm_fatal(get_type_name(),"getting the configuration faile,check if it set properly")
      
    req = write_xtn::type_id::create("req");
    start_item(req);
    
    assert(req.randomize() with {header[7:2] inside {[31:63]} && header[1:0]==addr;});
    
    `uvm_info("router_WR_SEQUENCE",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)
    finish_item(req);
 

endtask





//------------random pkt------------

class router_wxtns_rndm_pkt extends router_wr_seq;
  `uvm_object_utils(router_wxtns_rndm_pkt)
  write_xtn req;
  bit[1:0]addr;
  
  extern task body();
  extern function new(string name="router_wxtns_rndm_pkt");
  
  
endclass 


function router_wxtns_rndm_pkt::new(string name="router_wxtns_rndm_pkt");
  super.new(name);
endfunction
  
  
task router_wxtns_rndm_pkt::body();
  
  if (!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
    `uvm_fatal(get_type_name(),"getting the configuration file,check if it set properly")
    
  req = write_xtn::type_id::create("req");
  start_item(req);  
  assert(req.randomize() with {header[1:0]==addr;});
  
  `uvm_info("router_WR_SEQUENCE",$sformatf("printing from sequence \n %s",req.sprint()),UVM_HIGH)
  finish_item(req);
 
endtask

