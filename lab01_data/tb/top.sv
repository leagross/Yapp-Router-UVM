/*-----------------------------------------------------------------
File name     : top.sv
Description   : lab01_data top module template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module top;
    import uvm_pkg ::*;
    import yapp_pkg::*;
    `include "uvm_macros.svh"
    yapp_packet pkt; 
    initial begin
        pkt = yapp_packet::type_id::create("pkt");
        repeat (5) begin
          pkt.randomize();
          pkt.print();
        end
    end

endmodule : top
