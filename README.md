# SystemVerilog RTL Design — Building Toward a RISC CPU

A collection of digital hardware components implemented in **SystemVerilog**, developed as part of my learning journey in RTL design, digital logic, computer architecture, and hardware verification.

## Project Overview

The purpose of this repository is to strengthen my understanding of how digital hardware is designed and how individual RTL components can be combined into more complex systems.

Rather than starting with a complete processor, I am building the essential hardware blocks individually, understanding their internal behavior, and gradually integrating them into a simple **RISC-style CPU**.

My main objectives are to:

- Develop practical skills in SystemVerilog and RTL design.
- Understand combinational and sequential logic at the hardware level.
- Design reusable and modular hardware components.
- Practice module instantiation and signal interconnection.
- Learn how to create testbenches and verify hardware functionality.
- Eventually implement a simple processor datapath and control unit.

## Implemented Modules

### 1. 4-Bit Up/Down Counter (`counter_enable`)

A synchronous 4-bit counter with an asynchronous, active-high reset.

**Features:**
- Increment and decrement operations.
- Enable signal to control counting.
- Parallel loading of a 4-bit value.
- Automatic wraparound for 4-bit arithmetic.
- Retention of the previous value when counting is disabled.

**Control priority:**

1. `reset` — Clears the counter to zero.
2. `load_in` — Loads the value of `load[3:0]`.
3. `enable` — Increments or decrements based on `down`.
4. Otherwise — Holds the previous count.

This module helped me practice sequential RTL, nonblocking assignments, reset behavior, and control-signal priority.

### 2. 4-Bit Register (`reg4`)

A 4-bit register that captures its input on the rising edge of the clock.

**Features:**
- Stores a 4-bit value.
- Active-high asynchronous reset.
- Updates its output on each rising clock edge.

This module demonstrates the operation of D flip-flops and clock-controlled data storage.

### 3. Counter and Register Integration (`counter_reg`)

A top-level module that connects the 4-bit counter to the 4-bit register.

**Datapath:**

`counter_enable → reg4 → count_result`

The register captures the counter's previous value at each rising clock edge, creating a one-clock-cycle delay between the counter's updated output and the registered result during normal operation.

**Learning objectives:**
- Hierarchical hardware design.
- Instantiating multiple modules.
- Connecting modules using internal signals.
- Understanding clocked data transfers and nonblocking assignment timing.

### 4. 8-Bit Arithmetic Logic Unit (`ALU`)

A combinational 8-bit ALU capable of performing arithmetic and bitwise operations.

| Opcode | Operation | Description |
|---|---|---|
| `00` | `A + B + carry_in` | Addition with carry input |
| `01` | `A - B` | Subtraction |
| `10` | `A & B` | Bitwise AND |
| `11` | `A ^ B` | Bitwise XOR |

**Features:**
- Two 8-bit operands.
- Two-bit operation selector.
- Enable control.
- Carry-in support for addition.
- Zero flag (`zero_f`) indicating whether the 8-bit result equals zero.

The ALU is implemented using `always_comb`, meaning its output is determined by its current inputs without requiring a clock edge.

The arithmetic result is limited to 8 bits; a separate carry-out or signed-overflow flag has not yet been implemented.

**Learning objectives:**
- Designing combinational logic.
- Using `case` statements to select operations.
- Understanding arithmetic width limitations.
- Implementing condition flags.

### 5. 8-Bit Register (`Register_8bit`)

An 8-bit register designed to serve as the basic storage component of the register file.

**Features:**
- 8-bit data storage.
- Active-high asynchronous reset.
- Write-enable control.
- Complementary output (`Q_not = ~Q`).

When `write_enable` is asserted, the register captures its input on the rising clock edge. Otherwise, it retains its previously stored value.

This module demonstrates how sequential storage elements can be controlled independently.

### 6. 4 × 8-Bit Register File (`Register_File_4x8`)

A register file containing four independent 8-bit registers, implemented using four instances of `Register_8bit`.

**Architecture:**
- Four 8-bit registers (`R1`–`R4`).
- Two independent combinational read ports.
- One synchronous write port.
- Two-bit read and write addresses.
- A 2-to-4 write-address decoder.
- Shared clock and asynchronous reset.

**Write operation:**

The write decoder converts `write_addr[1:0]` into four individual register-enable signals. When the global write enable is asserted, the selected register captures `write_data[7:0]` at the rising clock edge.

| Write address | Selected register |
|---|---|
| `00` | R1 |
| `01` | R2 |
| `10` | R3 |
| `11` | R4 |

**Read operation:**

The two read ports independently select stored register values using combinational multiplexing.

This enables two operands to be retrieved simultaneously, making the register file suitable for connection to an ALU.

**Learning objectives:**
- Building larger hardware blocks from reusable modules.
- Designing address decoders and multiplexers.
- Understanding synchronous writes and combinational reads.
- Preparing the datapath for arithmetic instruction execution.

## Current Project Architecture

The repository currently contains the following building blocks:

```text
SystemVerilog RTL Components
│
├── Counter System
│   ├── counter_enable
│   ├── reg4
│   └── counter_reg
│
├── Arithmetic Logic Unit
│   └── ALU (8-bit)
│
└── Register File
    ├── Register_8bit
    └── Register_File_4x8
        ├── R1
        ├── R2
        ├── R3
        └── R4
```

These modules are currently educational building blocks. The register file and ALU have not yet been integrated into a complete CPU datapath.

## Planned CPU Datapath

The next major objective is to connect the register file to the ALU and provide a controlled write-back path.

```text
         Register File
        ┌───────────────┐
        │  R1 R2 R3 R4  │
        └───┬───────┬───┘
            │       │
          Data A  Data B
            │       │
            ▼       ▼
         ┌────────────┐
         │  8-bit ALU │
         └──────┬─────┘
                │
             Result
                │
                ▼
          Write-back
                │
                └──► Register File
```

The final processor will also require instruction decoding, control logic, a program counter, instruction storage, and an appropriate execution sequence.

## Development Roadmap

- [x] Learn basic SystemVerilog syntax and module declarations.
- [x] Implement combinational logic.
- [x] Implement sequential logic using `always_ff`.
- [x] Design an up/down counter with control signals.
- [x] Create reusable register modules.
- [x] Integrate a counter with a register.
- [x] Implement an 8-bit ALU.
- [x] Implement a 4 × 8-bit register file.
- [ ] Verify the register file with a SystemVerilog testbench.
- [ ] Add carry-out and overflow handling to the ALU.
- [ ] Connect the register file to the ALU.
- [ ] Implement a controlled ALU write-back datapath.
- [ ] Design an instruction format and decoder.
- [ ] Implement a program counter and instruction memory.
- [ ] Develop an FSM-based CPU control unit.
- [ ] Integrate the components into a simple RISC-style CPU.
- [ ] Develop automated testbenches for the complete design.

## Tools and Technologies

- **SystemVerilog** — RTL design and hardware description.
- **EDA Playground** — Writing and simulating SystemVerilog.
- **GitHub** — Version control and project documentation.
- **RTL Simulation** — Observing timing, logic behavior, and module interactions.

## Learning Philosophy

This repository is a learning project rather than a finished processor implementation.

My approach is to understand the behavior of each hardware component, implement it independently, verify its functionality, and then integrate it with other components.

As the project grows, I intend to explore more advanced topics in digital design, including finite-state machines, processor datapaths, instruction execution, pipelining, and SystemVerilog verification.

## Long-Term Goal

My long-term goal is to build a simple processor from the ground up while developing a stronger foundation in **RTL design, computer architecture, digital verification, and VLSI engineering**.

The project will evolve as I continue learning and implementing new hardware components.

---

**Project Status:** In development

**Focus:** SystemVerilog · RTL Design · Digital Logic · Computer Architecture · Hardware Verification
