/*-----------------------------------------------------------------
File name     : router-test_lib.sv
Description   : lab02_test base_class
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

class base_test extends uvm_test;

    `uvm_component_utils(base_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction :new

    router_tb rtr_tb;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uvm_config_wrapper::set(this, "rtr_tb.env.agent.sequencer.run_phase",
                            "default_sequence",
                            yapp_5_packets::get_type());

        rtr_tb = router_tb::type_id::create("rtr_tb", this);
        `uvm_info(get_type_name(), "The build phase of the test is begin execute",UVM_HIGH)
    endfunction : build_phase

    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction

endclass

class test2 extends base_test;
    `uvm_component_utils(test2)
    
    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

endclass