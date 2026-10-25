`uvm_analysis_imp_decl(_chan0)
`uvm_analysis_imp_decl(_chan1)
`uvm_analysis_imp_decl(_chan2)


class router_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(router_scoreboard)
    
    yapp_packet q0[$];
    yapp_packet q1[$];
    yapp_packet q2[$];


    int received_count = 0;
    int matched_count  = 0;
    int wrong_count    = 0;

    //yapp declare
    
    uvm_analysis_imp_yapp #(yapp_packet, router_scoreboard) yapp_in;

    function void write_yapp(input yapp_packet packet);
        yapp_packet ypkt;
        $cast(ypkt, packet.clone());
        case (ypkt.addr)
            2'b00: q0.push_back(ypkt);
            2'b01: q1.push_back(ypkt);
            2'b10: q2.push_back(ypkt);
        endcase
    endfunction

    //channel_0 declare

    uvm_analysis_imp_chan0 #(channel_packet, router_scoreboard) chan0_in;

    function void write_chan0(input channel_packet chan0_pkt);
        yapp_packet yp;
        received_count++;

        if(q0.size() > 0) begin
            yp = q0.pop_front();
        if(comp_equal(yp, chan0_pkt))
            matched_count ++;
        else
            wrong_count++;
        end 

        else begin
         wrong_count++;
        `uvm_error("SCOREBOARD", "Unexpected packet on Channel 0")
        end       

    endfunction


    //channel_1 declare

    uvm_analysis_imp_chan1 #(channel_packet, router_scoreboard) chan1_in;

    function void write_chan1(input channel_packet chan1_pkt);
        yapp_packet yp;
        received_count++;

        if(q1.size() > 0) begin
            yp = q1.pop_front();
        if(comp_equal(yp, chan1_pkt))
            matched_count ++;
        else
            wrong_count++;
        end

        else begin
         wrong_count++;
        `uvm_error("SCOREBOARD", "Unexpected packet on Channel 1")
        end  
    endfunction


    //channel_2 declare


    uvm_analysis_imp_chan2 #(channel_packet, router_scoreboard) chan2_in;

    function void write_chan2 (input channel_packet chan2_pkt);
        yapp_packet yp;
        received_count++;

        if(q2.size() > 0) begin
            yp = q2.pop_front();
        if(comp_equal(yp, chan2_pkt))
            matched_count ++;
        else
            wrong_count++;
        end

        else begin
         wrong_count++;
        `uvm_error("SCOREBOARD", "Unexpected packet on Channel 2")
        end  
    endfunction

    //hbus declare

    // uvm_analysis_imp_hbus #(hbus, router_scoreboard) hbus_in;

    // function void write_hbus(input hbus _hbus);
        
    // endfunction

    function new(string name, uvm_component parent);
        super.new(name, parent);

        yapp_in= new("yapp_in", this);
        chan1_in= new("chan1_in", this);
        chan2_in= new("chan2_in", this);
        chan0_in= new("chan0_in", this);
        //hbus_in= new("hbus_in", this);

    endfunction


    function void report_phase(uvm_phase phase);
        `uvm_info("REPORT",
        $sformatf("wrong_count: %0d matched_count: %0d received_count: %0d  Remaining packets: %0d",
                  wrong_count, matched_count, received_count, q0.size() + q1.size() + q2.size()),
        UVM_LOW)
    endfunction


    /*-----------------------------------------------------------------
File name     : packet_compare.sv
Developers    : Brian Dickinson
Created       : 01/11/17
Description   : lab09_sba simple packet compare function using Verilog equality operators
Notes         : From the Cadence "SystemVerilog Accelerated Verification with UVM" training
-------------------------------------------------------------------
Copyright Cadence Design Systems (c)2017
-----------------------------------------------------------------*/

   // custom packet compare function using inequality operators
   function bit comp_equal (input yapp_packet yp, input channel_packet cp);
      // returns first mismatch only
      if (yp.addr != cp.addr) begin
        `uvm_error("PKT_COMPARE",$sformatf("Address mismatch YAPP %0d Chan %0d",yp.addr,cp.addr))
        return(0);
      end
      if (yp.length != cp.length) begin
        `uvm_error("PKT_COMPARE",$sformatf("Length mismatch YAPP %0d Chan %0d",yp.length,cp.length))
        return(0);
      end
      foreach (yp.payload [i])
        if (yp.payload[i] != cp.payload[i]) begin
          `uvm_error("PKT_COMPARE",$sformatf("Payload[%0d] mismatch YAPP %0d Chan %0d",i,yp.payload[i],cp.payload[i]))
          return(0);
        end
      if (yp.parity != cp.parity) begin
        `uvm_error("PKT_COMPARE",$sformatf("Parity mismatch YAPP %0d Chan %0d",yp.parity,cp.parity))
        return(0);
      end
      return(1);
   endfunction


endclass