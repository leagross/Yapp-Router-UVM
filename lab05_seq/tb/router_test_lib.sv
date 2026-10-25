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
    bit enable_default_sequence = 1;


    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(enable_default_sequence)
            uvm_config_wrapper::set(this, "rtr_tb.env.agent.sequencer.run_phase"
            , "default_sequence", yapp_5_packets::get_type());

        uvm_config_int::set( this, "*", "recording_detail", 1);
        rtr_tb = router_tb::type_id::create("rtr_tb", this);
        `uvm_info(get_type_name(), "The build phase of the test is begin execute",UVM_HIGH)

    endfunction : build_phase


    function void end_of_elaboration_phase(uvm_phase phase);

        uvm_top.print_topology();

    endfunction : end_of_elaboration_phase


    function void check_phase (uvm_phase phase);

        super.check_phase(phase);
        check_config_usage();

    endfunction : check_phase

endclass

//....................................................
//
// name: test2
//
//....................................................


class test2 extends base_test;

    `uvm_component_utils(test2)
    
    function new(string name, uvm_component parent);

        super.new(name,parent);

    endfunction : new

endclass

//....................................................
//
// name: short_packet_test
//
//....................................................


class short_packet_test extends base_test;

    `uvm_component_utils(short_packet_test)

    function new(string name, uvm_component parent);

        super.new(name, parent);

    endfunction : new


    virtual function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        set_type_override_by_type(
            yapp_packet::get_type(),
            short_yapp_packet::get_type()
        );

    endfunction : build_phase

endclass


//....................................................
//
// name: set_config_test
//
//....................................................


class set_config_test extends base_test;

    `uvm_component_utils(set_config_test)

    function new(string name, uvm_component parent);

        super.new(name, parent);

    endfunction : new


    virtual function void build_phase(uvm_phase phase);
    
        enable_default_sequence = 0;

        uvm_config_int::set(this, "rtr_tb.env.agent", "is_active", UVM_ACTIVE);
        super.build_phase(phase);

    endfunction : build_phase

endclass

//....................................................
//
// name: incr_payload_test
//
//....................................................

class incr_payload_test extends base_test;

    `uvm_component_utils(incr_payload_test)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);

        set_type_override_by_type(
            yapp_packet::get_type(),
            short_yapp_packet::get_type()
        );
        super.build_phase(phase);

        uvm_config_wrapper::set(this, "rtr_tb.env.agent.sequencer.run_phase"
            , "default_sequence", yapp_incr_payload_seq::get_type());


    endfunction

endclass

//....................................................
//
// name: exhaustive_seq_test
//
//....................................................

class exhaustive_seq_test extends base_test;

    `uvm_component_utils(exhaustive_seq_test)

    function new(string name, uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);

         set_type_override_by_type(
            yapp_packet::get_type(),
            short_yapp_packet::get_type()
        );
        super.build_phase(phase);
         uvm_config_wrapper::set(this, "rtr_tb.env.agent.sequencer.run_phase"
            , "default_sequence", yapp_exhaustive_seq::get_type());
        
    endfunction
endclass

