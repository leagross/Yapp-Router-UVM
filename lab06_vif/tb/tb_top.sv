/*-----------------------------------------------------------------
File name     : tb_top.sv
Description   : lab02_test top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module tb_top;
    import uvm_pkg ::*;
    import yapp_pkg::*; 
    `include "uvm_macros.svh"
    `include "router_tb.sv"
    `include "router_test_lib.sv"

    initial begin   
      yapp_vif_config::set(null, "uvm_test_top.rtr_tb.env.agent.*", "vif", hw_top.in0);
      run_test();
    end

endmodule : tb_top
