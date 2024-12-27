# Square Root Computing
The aim of this project is to design and implement multiple FPGA architectures for computing the integer square root of a 2n-bit input. These architectures utilize two distinct algorithms:
- **Newton’s Method**
- **Iterative Algorithm** (computing sequentially the result bits)  

The algorithms are inspired by the proposed method in [here](https://citeseerx.ist.psu.edu/document?repid=rep1&type=pdf&doi=0897444f6814a52978f4f23f5eb7db394a27727a)

For more details about project, refer to [requirement docs](square_root_implementation_on_FPGA_v2.pdf)


## Table of Contents
- [1. Overview](#1-overview)
  - [1.1. Toolchains](#11-toolchains)
  - [1.2. Performance metric](#12-performance-metric)
  - [1.3. Implemented Architectures](#13-implemented-architectures)
- [2. Github Structure](#2-github-structure)
- [3. Quick Run](#3-quick-run)
- [4. Results](#4-results)

## 1. Overview

### 1.1. Toolchains
The module is designed to compute the square root of a **2n-bit unsigned input**, producing an **n-bit unsigned output**.

- ***Language***: VHDL
- ***Simulation***: ModelSim
- ***Synthesis***:
    - Tools: Quartus
    - Device: Cyclone V 5CGXFC7C7F23C8

### 1.2. Performance metric
Performance comparisons for each architecture were based on:
- Maximum working frequency
- Worst-case clock cycles
- FPGA resource utilization (Regs, ALMs)

### 1.3 Implemented Architectures

| Architecture      | Description                                                                   |
|-------------------|-------------------------------------------------------------------------------|
| **a1**            | Sequential architecture using Newton's Method (Behavioral approach)           |
| **a2**            | Sequential architecture using the Iterative Algorithm (Behavioral approach)   |
| **a3**            | Combinational architecture using the Iterative Algorithm (Behavioral approach)|
| **a4**            | Pipeline architecture using the Iterative Algorithm (Behavioral approach)     |
| **a5**            | Sequential architecture using the Iterative Algorithm (Structural approach)   |

## 2. Github Structure

| Directory |Description                                                                    |
|-----------|-------------------------------------------------------------------------------|
| **syn**   | Contains synthesis results generated using Quartus                            |
| **sim**   | Contains simulation results generated using ModelSim                          |
| **script**| Contains TCL scripts to automate synthesis, simulation, and waveform viewing  |
| **src**   | Contains source files (design, testbenchs, Python script)                     |
| **sdc**   | Contains constraint files used during synthesis for each architecture         |
| **fig**   | Contains figures and plots of synthesis and simulation results                |

## 3. Quick Run

To easily running, re-simulation, re-synthesis the project, we create a Makefile supports the following commands with `<ARCH_NUM>` in range (1,5):

| Command                      | Description                                                            |
|------------------------------|------------------------------------------------------------------------|
| `make sim<ARC_NUM>`          | Run simulation for the corresponding architecture                      |
| `make syn<ARC_NUM>`          | Run synthesis for the corresponding architecture                       |
| `make a<ARC_NUM>`            | Run both simulation and synthesis for the corresponding architecture   |
| `make wave<ARC_NUM>`         | View the waveform for the corresponding architecture                   |
| `make view_rpt<ARC_NUM>`     | View Quartus compilation report for the corresponding architecture     |
| `make run_sim`               | Run simulations for all architectures                                  |
| `make run_syn`               | Run synthesis for all architectures                                    |

**Examples:**
- To simulate architecture 4:  
```bash
  make sim4
```

## 4. Result
| Architecture      | Fclk (MHz) | Fclk max (MHz) | ALMs | Regs |
|-------------------|------------|----------------|------|------|
| a1                | 4          | 4.52           | 2097 | 100  |
| a2                | 111.11     | 117.5          | 159  | 230  |
| a3                | 9.09       | 10.03          | 1344 | 109  |
| a4                | 111.11     | 117.18         | 1421 | 2622 |
| a5                | 111.11     | 117.5          | 95   | 214  |