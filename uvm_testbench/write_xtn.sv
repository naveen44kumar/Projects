`include "uvm_macros.svh"
import uvm_pkg::*;
import router_pkg::*;
class write_xtn extends uvm_sequence_item;
  `uvm_object_utils(write_xtn);
	rand bit [7:0] header;
	rand bit [7:0] payload_data[];
	bit      [7:0] parity;
	bit            busy;
	bit            err;
  

	constraint INVALID_ADDR {header[1:0] != 3;}
	constraint DATA_IN_SIZE {payload_data.size == header[7:2];}
	constraint INVALID_DATA_LEN {payload_data.size!= 0;} 

	extern function new(string name="write_xtn");
	extern function void post_randomize();
	extern function void do_print(uvm_printer printer);
endclass 



function write_xtn::new(string name="write_xtn");
    super.new(name);
endfunction




function void write_xtn::post_randomize();
	parity = 0^header;
    
	foreach (payload_data[i])
		parity = payload_data[i]^parity;
endfunction:post_randomize

function void write_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field("header",this.header,8,UVM_HEX);
	foreach(payload_data[i])
		printer.print_field($sformatf("payload_data[%0d]",i), this.payload_data[i],8,UVM_HEX);
		printer.print_field("parity",this.parity,8,UVM_HEX);
endfunction

