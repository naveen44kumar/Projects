class base_v_seq extends uvm_sequence #(uvm_sequence_item);

  `uvm_object_utils(base_v_seq)
  `uvm_declare_p_sequencer(virtual_sequencer)

  virtual_sequencer v_seqr;
  master_sequencer m_seqrh[];
  slave_sequencer s_seqrh[];

  axi_config cfg;

  function new(string name="base_v_seq");
    super.new(name);
  endfunction

  task body();
    v_seqr = p_sequencer;
    if(v_seqr == null)
                `uvm_fatal(get_type_name(),"virtual sequencer handle is null")

    if(!uvm_config_db #(axi_config)::get(v_seqr,"","axi_config",cfg))
                `uvm_fatal(get_type_name(),"getting is failed")

    m_seqrh = new[cfg.no_of_masters];
    s_seqrh = new[cfg.no_of_slaves];
    foreach(m_seqrh[i])
    m_seqrh[i] = v_seqr.m_seqrh[i];
    foreach(s_seqrh[i])
    s_seqrh[i] = v_seqr.s_seqrh[i];

  endtask

endclass

class fixed_v_seq extends base_v_seq;

  `uvm_object_utils(fixed_v_seq)

  fixed_sequence seq;
  function new(string name="fixed_v_seq");
  super.new(name);
  endfunction
  task body();
  super.body();
  seq = fixed_sequence::type_id::create("seq");

  foreach(m_seqrh[i])
        seq.start(m_seqrh[i]);
  endtask

endclass

class inc_v_seq extends base_v_seq;

  `uvm_object_utils(inc_v_seq)

  inc_sequence seq;
  function new(string name="inc_v_seq");
  super.new(name);
  endfunction
  task body();
  super.body();
  seq = inc_sequence::type_id::create("seq");

  foreach(m_seqrh[i])
        seq.start(m_seqrh[i]);
  endtask
endclass

class wrap_v_seq extends base_v_seq;

  `uvm_object_utils(wrap_v_seq)

  wrap_sequence seq;
  function new(string name="wrap_v_seq");
  super.new(name);
  endfunction
  task body();
  super.body();
  seq = wrap_sequence::type_id::create("seq");
  foreach(m_seqrh[i])
        seq.start(m_seqrh[i]);
  endtask
endclass

