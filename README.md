# UVM Verification of the YAPP Packet Router

SystemVerilog/UVM testbench built progressively, lab by lab, around a small
packet router DUT (the **YAPP router**), following Cadence's *SystemVerilog
Accelerated Verification Using UVM* course. Each commit in this repository
corresponds to one lab and layers a new piece of the UVM methodology on top
of the previous one — stimulus modeling, the UVM component hierarchy,
factories, sequences, virtual interfaces, multi-UVC integration, scoreboarding,
and functional coverage.

## The Design Under Test

The **YAPP router** accepts byte-stream packets on a single input port and
routes each one to one of three output channels based on a 2-bit address in
the packet header. It also exposes a memory-mapped host bus (**HBUS**) for
configuring registers (max packet size, enable bits, per-address packet
counters) and two memory blocks.

```
                         ┌───────────────┐
  in_data, in_data_vld ─►│               ├─► channel0 (data_0, data_vld_0)
       in_suspend    ◄───┤   YAPP router ├─► channel1 (data_1, data_vld_1)
                         │               ├─► channel2 (data_2, data_vld_2)
    hdata, haddr, hen ──►│   registers   │
                         └───────────────┴─► error
```

A packet is `[header(addr:2, length:6)] [payload: 1-63 bytes] [parity byte]`.
The router drops packets that are disabled, oversized, or carry an illegal
address (3), and it can be programmed/inspected over HBUS while running.

## Verification Environment

The testbench is composed of four independently reusable **UVCs** (UVM
Verification Components), driven from a single testbench and, from Lab 8
onward, coordinated by a virtual (multichannel) sequencer:

| UVC | Role |
|---|---|
| `yapp/` | Drives packets into the router's input port; built from scratch over Labs 1–6 |
| `hbus/` | Master/slave agents for the register-programming host bus |
| `channel/` | Receives and acknowledges packets on each of the 3 output channels |
| `clock_and_reset/` | Generates clock and reset for the environment |

A **scoreboard** (`router_scoreboard`, Lab 9A) clones every packet the YAPP
monitor sends in and compares it against what each Channel UVC's monitor
collects, using TLM analysis ports. A **reference model** (`router_reference`,
Lab 9B) mirrors the HBUS-programmed `maxpktsize`/`router_en` fields so the
scoreboard only expects packets the router is actually expected to forward —
together they form the reusable `router_module` UVC.

## Repository Layout

```
test_install/        Sanity check that the UVM library is installed correctly
lab01_data/           Lab 1  — YAPP packet (uvm_sequence_item) + randomization
lab02_test/           Lab 2  — test/testbench UVM hierarchy, phasing
lab03_uvc/            Lab 3  — YAPP TX driver/sequencer/monitor/agent/env
lab04_factory/        Lab 4  — factory overrides, config_db
lab05_seq/            Lab 5  — UVM sequence library
lab06_vif/            Lab 6  — virtual interface, first connection to router_rtl
yapp/ hbus/ channel/   Standalone UVCs assembled for system-level integration
clock_and_reset/
router_rtl/            The router RTL (DUT) and the Lab 9B router_module UVC
lab07_integ/           Lab 7  — all 4 UVCs integrated against the real DUT
lab08_mcseq/           Lab 8  — multichannel (virtual) sequencer
lab09_sba/             Lab 9A — TLM scoreboard
lab09_sbb/             Lab 9B — scoreboard + reference model as one module UVC
lab10_fcoverage/       Lab 10 — functional coverage model
```

Each `labNN_*` directory is a self-contained checkpoint — later labs build on
a copy of the previous one's `sv`/`tb` sources, per the course's own
"copy forward, then extend" workflow, so you can diff any two consecutive
labs to see exactly what that lab added.

## Running a Lab

Each lab's `tb/run.f` is an Xcelium argument file:

```bash
cd lab07_integ/tb
xrun -f run.f +UVM_TESTNAME=simple_test +UVM_VERBOSITY=UVM_LOW
```

Simulator build/debug output (`xcelium.d/`, waveform databases, `.simvision/`,
logs) is intentionally untracked — see `.gitignore` — only source is versioned.

## Tooling

- **Simulator:** Cadence Xcelium (UVM 1.1d/1.2)
- **Methodology:** UVM (Universal Verification Methodology)
- **Language:** SystemVerilog
