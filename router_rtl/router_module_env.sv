class router_module_env extends uvm_env;

    `uvm_component_utils(router_module_env)

    router_scoreboard scoreboard;
    router_reference reference;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        scoreboard = router_scoreboard::type_id::create("scoreboard", this);
        reference = router_reference::type_id::create("reference", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        reference.yapp_out.connect(scoreboard.yapp_in);
    endfunction

endclass