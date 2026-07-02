class axi_config extends uvm_object;

  `uvm_object_utils (axi_config)

  int no_of_masters;
  int no_of_slaves;
  int no_of_transactions=1;
  bit has_virtual_sequencer;
  bit has_sb;
  master_config m_cfg[];
  slave_config s_cfg[];



  function new(string name="axi_config");
    super.new(name);
  endfunction
endclass

