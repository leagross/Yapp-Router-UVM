/*-----------------------------------------------------------------
File name     : router_tb.sv
Description   : lab02_test router from uvm_env
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

class router_tb extends uvm_env;

    `uvm_component_utils(router_tb)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    yapp_env env;
    channel_env channel_0_env;
    channel_env channel_1_env;
    channel_env channel_2_env;
    hbus_env hbus_env_;
    clock_and_reset_env clk_and_rst_env;
    router_mcsequencer mcseqr;
    router_scoreboard scoreboard;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "The build phase of the testbench is begin execute",UVM_HIGH)
        
        env = yapp_env::type_id::create("env", this);
        channel_0_env = channel_env::type_id::create("channel_0_env", this);
        channel_1_env = channel_env::type_id::create("channel_1_env", this);
        channel_2_env = channel_env::type_id::create("channel_2_env", this);
        clk_and_rst_env = clock_and_reset_env::type_id::create("clk_and_rst_env", this);
        hbus_env_ = hbus_env::type_id::create("hbus_env_", this);
        mcseqr = router_mcsequencer::type_id::create("mcseqr", this);
        scoreboard = router_scoreboard::type_id::create("scoreboard", this);

        uvm_config_int::set(this, "hbus_env_", "num_masters", 1);
        uvm_config_int::set(this, "hbus_env_", "num_slaves", 0);
        uvm_config_int::set(this, "channel_0_env", "channel_id", 0);
        uvm_config_int::set(this, "channel_1_env", "channel_id", 1);
        uvm_config_int::set(this, "channel_2_env", "channel_id", 2);

    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mcseqr.yapp_seqr = env.agent.sequencer;
        mcseqr.hbus_seqr = hbus_env_.masters[0].sequencer;
        env.agent.monitor.yapp_out.connect(scoreboard.yapp_in);
        channel_0_env.rx_agent.monitor.item_collected_port.connect(scoreboard.chan0_in);
        channel_1_env.rx_agent.monitor.item_collected_port.connect(scoreboard.chan1_in);
        channel_2_env.rx_agent.monitor.item_collected_port.connect(scoreboard.chan2_in);
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "start_of_simulation_phase called",UVM_HIGH)
    endfunction

endclass