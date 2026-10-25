/*-----------------------------------------------------------------
File name     : run.f
Description   : lab02_test simulator run template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
              : Set $UVMHOME to install directory of UVM library
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/
// 64 bit option for AWS labs
-64

 -uvmhome $UVMHOME

../../router_rtl/yapp_router.sv
+incdir+../../channel/sv
../../channel/sv/channel_if.sv
../../channel/sv/channel_pkg.sv
+incdir+../../clock_and_reset/sv
../../clock_and_reset/sv/clock_and_reset_if.sv
../../clock_and_reset/sv/clock_and_reset_pkg.sv
+incdir+../../hbus/sv
../../hbus/sv/hbus_pkg.sv
../../hbus/sv/hbus_if.sv
+incdir+../../yapp/sv
../../yapp/sv/yapp_if.sv
../../yapp/sv/yapp_pkg.sv
clkgen.sv
hw_top.sv
tb_top.sv
+UVM_TESTNAME=router_mctest 
+UVM_VERBOSITY=UVM_FULL
+SVSEED=random
-timescale 1ns/1ns

