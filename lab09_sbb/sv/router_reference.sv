`uvm_analysis_imp_decl(_hbus)

class router_reference extends uvm_component;

    `uvm_component_utils(router_reference)    

    uvm_analysis_imp_yapp #(yapp_packet, router_reference) yapp_in;
    uvm_analysis_imp_hbus #(hbus_transaction, router_reference) hbus_in;
    uvm_analysis_port #(yapp_packet) yapp_out;

    int maxpktsize;
    bit router_en;
    int router_counter;
    int yp_length_counter;
    int yp_addr_counter;

    function new(string name, uvm_component parent);
        super.new(name, parent);
        yapp_in = new("yapp_in", this);
        hbus_in = new("hbus_in", this);
        yapp_out = new("yapp_out", this);

    endfunction

    function void write_hbus(hbus_transaction tr);
        if (tr.hwr_rd == HBUS_WRITE) begin
            case (tr.haddr)
                16'h1000: maxpktsize = tr.hdata;
                16'h1001: router_en = tr.hdata[0];
            endcase
            `uvm_info("HBUS_DEBUG",
    $sformatf("HBUS: addr=%h data=%h router_en=%0b maxpktsize=%0d",
              tr.haddr, tr.hdata, router_en, maxpktsize),
    UVM_LOW)
        end
    endfunction

    function void write_yapp(yapp_packet yp);
        `uvm_info("REF_DEBUG",
    $sformatf("Packet: addr=%0d length=%0d router_en=%0b maxpktsize=%0d",
              yp.addr, yp.length, router_en, maxpktsize),
    UVM_LOW)

        if(!router_en) 
            router_counter ++;
        else if(yp.length > maxpktsize)
                yp_length_counter++;
        else if(yp.addr == 2'b11)
                yp_addr_counter++;
        
        else
            yapp_out.write(yp);

    endfunction



endclass