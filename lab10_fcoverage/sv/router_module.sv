package router_module;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import yapp_pkg::*;
    import hbus_pkg::*;
    import channel_pkg::*;
    
    `uvm_analysis_imp_decl(_yapp)

    `include "router_reference.sv"
    `include "router_scoreboard.sv"
    `include "router_module_env.sv"

endpackage : router_module