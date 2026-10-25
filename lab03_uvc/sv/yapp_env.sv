
class yapp_env extends uvm_env;

    `uvm_component_utils(yapp_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    yapp_tx_agent agent;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent = yapp_tx_agent::type_id::create("agent", this);
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "start_of_simulation_phase called",UVM_HIGH)
    endfunction

endclass