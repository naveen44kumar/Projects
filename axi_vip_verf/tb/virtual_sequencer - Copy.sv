
class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);
  `uvm_component_utils(virtual_sequencer)

  master_sequencer m_seqrh[];
  slave_sequencer s_seqrh[];
  axi_config cfg;

  function new(string name="virtual_sequencer",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);

    if(!uvm_config_db #(axi_config)::get(this,"","axi_config",cfg))
        `uvm_fatal(get_type_name(),"getting is failed in virtual_sequencer")

    m_seqrh = new[cfg.no_of_masters];
    s_seqrh = new[cfg.no_of_slaves];

  endfunction
endclass

