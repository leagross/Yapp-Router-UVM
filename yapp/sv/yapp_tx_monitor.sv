
class yapp_tx_monitor extends uvm_monitor;

    `uvm_component_utils(yapp_tx_monitor)

    uvm_analysis_port#(yapp_packet) yapp_out;

    virtual interface yapp_if vif;

    // Collected Data handle
    yapp_packet pkt;

    // Count packets collected
    int num_pkt_col;

    covergroup packet_cg;
      length_cp : coverpoint pkt.length {
        bins MIN = {1};
        bins MAX = {63};
        bins SMALL ={[2:10]};
        bins MEDIUM = {[11:40]};
        bins LARGE = {[41:62]};
      }

      addr_cp: coverpoint pkt.addr {
        bins legal[] = {[0:2]};
        bins illegal = {3};
      }

      parity_cp: coverpoint pkt.parity_type {
       bins good = {GOOD_PARITY};
       bins bad  = {BAD_PARITY};
      }

      size_addr_parity_cross: cross length_cp, addr_cp, parity_cp {
        ignore_bins illegal_addr =
        binsof(addr_cp.illegal);
        ignore_bins good_parity  = binsof(parity_cp.good);
      }

    endgroup


    function new(string name, uvm_component parent);
        super.new(name, parent);
        yapp_out = new("yapp_out", this);
        packet_cg = new();
    endfunction


  // UVM run() phase
  task run_phase(uvm_phase phase);
    // Look for packets after reset
    @(posedge vif.reset)
    @(negedge vif.reset)
    `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
    forever begin 
      // Create collected packet instance
      pkt = yapp_packet::type_id::create("pkt", this);

      // concurrent blocks for packet collection and transaction recording
      fork
        // collect packet
        vif.collect_packet(pkt.length, pkt.addr, pkt.payload, pkt.parity);
        // trigger transaction at start of packet
        @(posedge vif.monstart) void'(begin_tr(pkt, "Monitor_YAPP_Packet"));
      join

      pkt.parity_type = (pkt.parity == pkt.calc_parity()) ? GOOD_PARITY : BAD_PARITY;
      // End transaction recording
      end_tr(pkt);
      collect_packets();
      
      `uvm_info(get_type_name(), $sformatf("Packet Collected :\n%s", pkt.sprint()), UVM_LOW)
      num_pkt_col++;
    end
  endtask : run_phase

  // UVM report_phase
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Report: YAPP Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
  endfunction : report_phase

    function void connect_phase(uvm_phase phase);
        if(! yapp_vif_config :: get(this, "", "vif", vif))
            `uvm_error("NOVIF", "vif not set")
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), "start_of_simulation_phase called",UVM_HIGH)
    endfunction


    task collect_packets();
        packet_cg.sample();
        yapp_out.write(pkt);

    endtask


endclass