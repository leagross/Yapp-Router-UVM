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

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_type_name(), "The build phase of the testbench is begin execute",UVM_HIGH)
    endfunction

endclass