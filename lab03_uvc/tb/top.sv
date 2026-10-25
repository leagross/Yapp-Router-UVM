/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab02_test top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;
    import uvm_pkg ::*;
    import yapp_pkg::*; 
    
    `include "uvm_macros.svh"
    `include "router_tb.sv"
    `include "router_test_lib.sv"

    initial begin
      run_test();
    end

endmodule : top
