/*-----------------------------------------------------------------
File name     : yapp_tx_seqs.sv
Developers    : Kathleen Meade, Brian Dickinson
Created       : 01/04/11
Description   : YAPP UVC simple TX test sequence for labs 2 to 4
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

//------------------------------------------------------------------------------
//
// SEQUENCE: base yapp sequence - base sequence with objections from which 
// all sequences can be derived
//
//------------------------------------------------------------------------------
class yapp_base_seq extends uvm_sequence #(yapp_packet);
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_base_seq)

  // Constructor
  function new(string name="yapp_base_seq");
    super.new(name);
  endfunction

  task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
      // in UVM1.2, get starting phase from method
      phase = get_starting_phase();
    `else
      phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body

endclass : yapp_base_seq

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_5_packets
//
//  Configuration setting for this sequence
//    - update <path> to be hierarchial path to sequencer 
//
//  uvm_config_wrapper::set(this, "<path>.run_phase",
//                                 "default_sequence",
//                                 yapp_5_packets::get_type());
//
//------------------------------------------------------------------------------
class yapp_5_packets extends yapp_base_seq;
  
  // Required macro for sequences automation
  `uvm_object_utils(yapp_5_packets)

  // Constructor
  function new(string name="yapp_5_packets");
    super.new(name);
  endfunction

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_5_packets sequence", UVM_LOW)
     repeat(5)
      `uvm_do(req)
  endtask
  
endclass : yapp_5_packets


//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_1_seq
//
//------------------------------------------------------------------------------
class yapp_1_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_1_seq)

  function new(string name = "yapp_1_seq");
      super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_1_seq sequence", UVM_LOW)
    `uvm_do_with(req, {addr == 1;});
  endtask

endclass


//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_012_seq
//
//------------------------------------------------------------------------------
class yapp_012_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_012_seq)

  function new(string name="yapp_012_seq");
    super.new(name);
  endfunction

  virtual task body();
    short_yapp_packet short_req;
    `uvm_info(get_type_name(), "Executing yapp_012_seq sequence", UVM_LOW)
    `uvm_do_with(req, {addr == 0;})
    `uvm_do_with(req, {addr == 1;})
    `uvm_create(req)
    if (!$cast(short_req, req))
       `uvm_fatal("CAST", "Expected short_yapp_packet")

    short_req.exclude_channel2.constraint_mode(0);

    if (!req.randomize() with {addr == 2;}) begin
      `uvm_error("RAND", "Randomization failed")
      return;
end

`uvm_send(req)
  endtask

endclass


//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_111_seq
//
//------------------------------------------------------------------------------

class yapp_111_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_111_seq)

  function new(string name="yapp_111_seq");
    super.new(name);
  endfunction

  yapp_1_seq y_1_seq;

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_111_seq sequence", UVM_LOW)

    repeat(3) begin
        `uvm_do(y_1_seq);
     end

  endtask

endclass

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_repeat_addr_seq
//
//------------------------------------------------------------------------------

class yapp_repeat_addr_seq extends yapp_base_seq;

  rand bit [1:0] seq_addr;

  constraint c_addr {
    seq_addr inside {[0:2]};
  }

  `uvm_object_utils(yapp_repeat_addr_seq)

  function new(string name="yapp_repeat_addr_seq");
    super.new(name);
  endfunction

  virtual task body();

    `uvm_info(get_type_name(), "Executing yapp_repeat_addr_seq sequence", UVM_LOW)
    if (!this.randomize())
        `uvm_fatal("RAND", "Sequence randomization failed")
    `uvm_do_with(req, {addr == local::seq_addr;})
    `uvm_do_with(req, {addr == local::seq_addr;})
  endtask

endclass

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_incr_payload_seq
//
//------------------------------------------------------------------------------

class yapp_incr_payload_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_incr_payload_seq)

  function new(string name="yapp_incr_payload_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Executing yapp_incr_payload_seq sequence", UVM_LOW)
    `uvm_create(req)
    req.randomize();

    if (!req.randomize()) begin
      `uvm_error("RAND", "Packet randomization failed")
      return;
    end

    foreach (req.payload[i]) begin
      req.payload[i] = i;
    end
  
  req.set_parity();
  `uvm_send(req)

endtask

endclass

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_rnd_seq
//
//------------------------------------------------------------------------------

class yapp_rnd_seq extends yapp_base_seq;
  `uvm_object_utils(yapp_rnd_seq)
  function new(string name = "yapp_rnd_seq");
    super.new(name);
  endfunction

  rand int count;
  bit was_randomized = 0;

  function void post_randomize();
    was_randomized = 1;
  endfunction

  constraint c_cnt { count >= 1 && count<=10;}


  virtual task body();
  if (!was_randomized) begin
    if (!this.randomize())
    `uvm_warning("RAND", "Randomization failed") end

    `uvm_info(get_type_name(), $sformatf("count val = %0d", count), UVM_LOW)
    repeat (count) begin
      `uvm_do(req)
    end
  endtask

endclass

//------------------------------------------------------------------------------
//
// SEQUENCE: six_yapp_seq
//
//------------------------------------------------------------------------------

class six_yapp_seq extends yapp_base_seq;

  `uvm_object_utils(six_yapp_seq)
  function new(string name="six_yapp_seq");
    super.new(name);
  endfunction

  yapp_rnd_seq y_rnd_seq;

  virtual task body();
    `uvm_do_with(y_rnd_seq, {count == 6;})
  endtask
endclass

//------------------------------------------------------------------------------
//
// SEQUENCE: yapp_incr_payload_seq
//
//------------------------------------------------------------------------------

class yapp_exhaustive_seq extends yapp_base_seq;

  `uvm_object_utils(yapp_exhaustive_seq)

  function new(string name = "yapp_exhaustive_seq");
    super.new(name);
  endfunction

  yapp_5_packets y_5_packets;
  yapp_1_seq y_1_seq;
  yapp_111_seq y_111_seq;
  yapp_012_seq y_012_seq;
  yapp_repeat_addr_seq y_repeat_addr_seq;
  yapp_incr_payload_seq y_incr_payload_seq;
  yapp_rnd_seq y_rnd_seq;
  six_yapp_seq s_yapp_seq;

  virtual task body();
    `uvm_do(y_5_packets)
    `uvm_do(y_1_seq)
    `uvm_do(y_111_seq)
    `uvm_do(y_012_seq)
    `uvm_do(y_repeat_addr_seq)
    `uvm_do(y_incr_payload_seq)
    `uvm_do(y_rnd_seq)
    `uvm_do(s_yapp_seq)
  endtask

endclass

