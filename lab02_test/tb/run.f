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

-incdir ../sv
../sv/yapp_pkg.sv
top.sv
+UVM_TESTNAME=test2
+UVM_VERBOSITY=UVM_MEDIUM

