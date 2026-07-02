class master_agent_top extends uvm_env;

  `uvm_component_utils(master_agent_top)
  axi_config cfg;

  master_agent m_agent[];

  function new(string name="master_agent_top",uvm_component parent);
    super.new(name,parent);
  endfunction

  function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(axi_config) :: get(this,"","axi_config",cfg))
        `uvm_fatal(get_type_name(),"getting is failed")

    m_agent = new[cfg.no_of_masters];

    foreach(m_agent[i])
        begin
                m_agent[i]=master_agent::type_id::create($sformatf("m_agent[%0d]",i),this);
                uvm_config_db #(master_config) :: set(this,$sformatf("m_agent[%0d]*",i),"master_config",cfg.m_cfg[i]);
        end

  endfunction

  function void report_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

endclass


