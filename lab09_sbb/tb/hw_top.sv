/*-----------------------------------------------------------------
File name     : hw_top.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : lab06_vif hardware top module for acceleration
              : Instantiates clock generator and YAPP interface only for testing - no DUT
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

module hw_top;

  // Clock and reset signals
  logic [31:0]  clock_period;
  logic         run_clock;
  logic         clock;
  logic         reset;

  clock_and_reset_if clk_and_rst_if (
    .clock(clock),
    .reset(reset),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );

  hbus_if hbus_if_ (clock, reset);
  channel_if channel_0_if(clock, reset);
  channel_if channel_1_if(clock, reset);
  channel_if channel_2_if(clock, reset);

  // YAPP Interface to the DUT
  yapp_if in0(clock, reset);

  // CLKGEN module generates clock
  clkgen clkgen (
    .clock(clock),
    .run_clock(run_clock),
    .clock_period(clock_period)
  );

    yapp_router dut(
    .reset(reset),
    .clock(clock),
    .error(),

    // YAPP interface
    .in_data(in0.in_data),
    .in_data_vld(in0.in_data_vld),
    .in_suspend(in0.in_suspend),

    // Output Channels
    //Channel 0
    .data_0(channel_0_if.data),
    .data_vld_0(channel_0_if.data_vld),
    .suspend_0(channel_0_if.suspend),
    //Channel 1
    .data_1(channel_1_if.data),
    .data_vld_1(channel_1_if.data_vld),
    .suspend_1(channel_1_if.suspend),
    //Channel 2
    .data_2(channel_2_if.data),
    .data_vld_2(channel_2_if.data_vld),
    .suspend_2(channel_2_if.suspend),

    // HBUS Interface 
    .haddr(hbus_if_.haddr),
    .hdata(hbus_if_.hdata_w),
    .hen(hbus_if_.hen),
    .hwr_rd(hbus_if_.hwr_rd));

endmodule
