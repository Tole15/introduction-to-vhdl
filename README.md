# introduction-to-vhdl

This repository contains a collection of VHDL design examples, practices and projects aimed at learning digital design with VHDL. It is organized into several directories representing different exercises and larger projects.

## 📁 Directory Structure

- **docs/**
  - Supporting documentation and resources.

- **Practicas/**
  - A set of practice VHDL files covering counters, generators and motor control designs.
  - Subfolder `Motores/` contains a complete motor controller project with FSM, PWM, SPI, and related modules.
    - `motor_ctrl_top.vhd`, `pwm_module.vhd`, `spi_slave_sync.vhd`, etc.
    - Quartus project files (`.qpf`, `.qsf`, `.qws`) for FPGA synthesis.
    - A database of incremental builds under `db/` and `incremental_db/`.
  - Top‑level examples such as `contBCD29.vhd`, `contGen.vhd`.

- **Reloj24HrsEvaluacionv2/**
  - An extensive 24‑hour clock design and evaluation project.
  - Includes packages (`compPackage.vhd`, `funPackage.vhd`), counters, display drivers (`dec7seg.vhd`, `display4dig.vhd`).
  - Project files for simulation (`.prj`, `.wdb`) and synthesis outputs (`.ngc`, `.ncd`, `.bit`, etc.).
  - Variants such as `Reloj24Completo` with complete build artifacts.
  - Testbenches (`test_Reloj24Completo.vhd`, `TestReloj24.vhd`) and history of synthesis reports.

## 📌 Highlights

- **Learning focus:** Basic counters, BCD conversions, generational circuits, FSM design, PWM, and clock/ display implementations.
- **Tools used:** VHDL source files target FPGA development (likely with Intel/Altera Quartus given `.qpf`/`.qsf` and Xilinx project outputs).
- **Structure:** Each major design has attendant simulation and synthesis artifacts allowing hands‑on experimentation.

## 🚀 Getting Started

1. Browse the `Practicas` folder for simple examples to compile and simulate.
2. Explore the `Motores` project for a complete multi‑module design with FSM and PWM.
3. Dive into `Reloj24HrsEvaluacionv2` for a full clock project with display and evaluation reports.

> Feel free to add your own modules or modify existing ones as you learn VHDL and FPGA design.

---

*Generated automatically to describe repository contents.*
