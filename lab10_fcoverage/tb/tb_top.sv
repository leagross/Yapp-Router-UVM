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
    import channel_pkg::*;
    import hbus_pkg::*;
    import clock_and_reset_pkg::*;
    import router_module::*;
    
    `include "uvm_macros.svh"

    `include "router_mcsequencer.sv"
    `include "router_tb.sv"
    `include "router_mcseqs_lib.sv"
    `include "router_test_lib.sv"  

    initial begin   
      yapp_vif_config::set(null, "uvm_test_top.rtr_tb.env.agent.*", "vif", hw_top.in0);
      hbus_vif_config::set(null, "*.hbus_env_.*", "vif", hw_top.hbus_if_);
      clock_and_reset_vif_config::set(null, "*.clk_and_rst_env.*", "vif",hw_top.clk_and_rst_if);
      channel_vif_config::set(null, "*.channel_0_env.*", "vif",hw_top.channel_0_if);
      channel_vif_config::set(null, "*.channel_1_env.*", "vif",hw_top.channel_1_if);
      channel_vif_config::set(null, "*.channel_2_env.*", "vif",hw_top.channel_2_if);

      run_test();
    end

endmodule : tb_top
