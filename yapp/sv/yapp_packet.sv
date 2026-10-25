/*-----------------------------------------------------------------
File name     : yapp_packet.sv
Description   : lab01_data YAPP UVC packet template file
Notes         : From the Cadence "SystemVerilog Advanced Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2015
-----------------------------------------------------------------*/

// Define your enumerated type(s) here
typedef enum { GOOD_PARITY , BAD_PARITY } parity_type_e;

class yapp_packet extends uvm_sequence_item;


  rand bit [5:0] length;
  rand bit [1:0] addr;
  rand bit [7:0] payload[];
  bit [7:0] parity;
  rand bit packet_delay; 
  rand parity_type_e parity_type;

  `uvm_object_utils_begin(yapp_packet)
    `uvm_field_int( length, UVM_ALL_ON)
    `uvm_field_int( addr, UVM_ALL_ON)
    `uvm_field_array_int(payload, UVM_ALL_ON)
    `uvm_field_int( parity, UVM_ALL_ON)
    `uvm_field_int( packet_delay, UVM_ALL_ON + UVM_NOCOMPARE)
    `uvm_field_enum( parity_type_e, parity_type,  UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "yapp_packet");
     super.new(name);
  endfunction

  function bit[7:0] calc_parity();
    bit [7:0] cal_parity = '0;
    bit [7:0] header = {length,addr};
    cal_parity ^= header;
    foreach (payload[i]) begin
        cal_parity ^= payload[i]; 
    end
    return cal_parity;
  endfunction

  function void set_parity();
    parity = calc_parity();
    if (parity_type == BAD_PARITY)
        parity = ~parity;
  endfunction

  function void post_randomize();
    set_parity();
  endfunction

  //************
  // constraint
  //************

  constraint valid_addr { addr!=3; }
  constraint equal_length { length == payload.size(); }
  constraint parity_type_c { parity_type dist{
    GOOD_PARITY := 80,
    BAD_PARITY := 20
  }; }
  constraint pckt_delay { packet_delay >= 1; packet_delay <= 20;}

endclass: yapp_packet




class short_yapp_packet extends yapp_packet;

  `uvm_object_utils(short_yapp_packet)

    function new(string name = "short_yapp_packet");
        super.new(name);
    endfunction

      constraint short_packet {
    payload.size() inside {[1:14]};}
   //  constraint exclude_channel2 { addr!=2 ;}
endclass


