
class base_sequence extends uvm_sequence #(axi_xtn);

  `uvm_object_utils (base_sequence)

  axi_config cfg;
  axi_xtn req;

  function new(string name="base_sequence");
    super.new(name);
  endfunction

  task body();
    if(!uvm_config_db #(axi_config) :: get(m_sequencer,"","axi_config",cfg))
        `uvm_fatal(get_full_name(),"getting is failed")
  endtask

endclass

class fixed_sequence extends base_sequence;
  `uvm_object_utils (fixed_sequence)

  function new(string name="fixed_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();
    repeat(cfg.no_of_transactions)

    begin
        req = axi_xtn :: type_id :: create("req");
        start_item(req);
        assert(req.randomize() with {AWBURST==0;ARBURST==0;});
        finish_item(req);
    end

  endtask

endclass


class inc_sequence extends base_sequence;
  `uvm_object_utils (inc_sequence)

  function new(string name="inc_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();
    repeat(cfg.no_of_transactions)

    begin
        req = axi_xtn :: type_id :: create("req");
        start_item(req);
        assert(req.randomize() with {AWBURST==1;ARBURST==1;});
        finish_item(req);
    end

  endtask

endclass

class wrap_sequence extends base_sequence;
  `uvm_object_utils (wrap_sequence)

  function new(string name="wrap_sequence");
    super.new(name);
  endfunction

  task body();

    super.body();
    repeat(cfg.no_of_transactions)

    begin
        req = axi_xtn :: type_id :: create("req");
        start_item(req);
        assert(req.randomize() with {AWBURST==2;ARBURST==2;});
        finish_item(req);
    end

  endtask

endclass
