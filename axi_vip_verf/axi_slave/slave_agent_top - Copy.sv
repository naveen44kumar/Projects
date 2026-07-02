class slave_agent_top extends uvm_agent;
  `uvm_component_utils(slave_agent_top)
  axi_config cfg;

  slave_agent s_agent[];

  function new(string name="slave_agent_top",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(axi_config) :: get(this,"","axi_config",cfg))
        `uvm_fatal(get_type_name(),"getting is failed")

  s_agent = new[cfg.no_of_slaves];

  foreach(s_agent[i])
        begin
                s_agent[i]=slave_agent::type_id::create($sformatf("s_agent[%0d]",i),this);
                uvm_config_db #(slave_config) :: set(this,$sformatf("s_agent[%0d]*",i),"slave_config",cfg.s_cfg[i]);
        end

  endfunction

endclass

