# rv32i — a minimal RISC-V CPU in Verilog

Single-cycle RV32I core.

Includes an interactive HTML datapath visualizer (`riscv_visualizer_wide.html`) that
shows signal flow through the datapath.

## What it implements

18 instructions: LUI, ADDI, ANDI, ORI, XORI, SLTI, ADD, SUB, AND, OR, XOR, SLT,
BEQ, BNE, JAL, JALR, LW, SW.

## Files

```
src/
  cpu.v        top level — wires everything together
  decoder.v    reads opcode/funct3/funct7, produces control signals
  immgen.v     extracts and sign-extends the 5 immediate formats
  alu.v        32-bit ALU (ADD SUB AND OR XOR SLT PASSB)
  pc.v         32-bit program counter, async reset
  regfile.v    32 registers, x0 hardwired to 0
  aMux.v       ALU A source: rs1 or PC
  bMux.v       ALU B source: rs2 or immediate
  wbMux.v      write-back source: ALU / PC+4 / memory
  ram.v        4 KB data memory
  imem.v       4 KB instruction ROM, loaded from program.hex
  reset_gen.v  power-on reset + button debounce  [from original project]
  uart_tx.v    UART transmitter                   [from original project]

cpu_tb.v     testbench
program.hex  test program (21 instructions)
```

## How to run

Compile:
```
iverilog -o cpu_sim cpu_tb.v src/cpu.v src/decoder.v src/immgen.v src/alu.v \
  src/pc.v src/regfile.v src/bMux.v src/aMux.v src/wbMux.v \
  src/ram.v src/imem.v src/reset_gen.v src/uart_tx.v
```

Simulate:
```
vvp cpu_sim
```

Waveforms:
```
gtkwave cpu.vcd
```

## Expected output

```
PASS: x1 = 5
PASS: x2 = 10
PASS: x3 = 15 (ADD)
PASS: x4 = 5 (SUB)
PASS: x5 = 0 (AND)
PASS: x6 = 15 (OR)
PASS: x7 = 15 (XOR)
PASS: x8 = 1 (SLT)
PASS: mem[0] = 15 (SW)
PASS: x9 = 15 (LW)
PASS: x10 = ABCD0123 (LUI+ADDI)
PASS: x11 = 42 (BEQ taken)
PASS: x13 = 0x48 (JAL)
PASS: x15 = 0x54 (JALR)
Finished simulation
```

## What the test program does

```
ADDI x1,  x0, 5       x1 = 5
ADDI x2,  x0, 10      x2 = 10
ADD  x3,  x1, x2      x3 = 15
SUB  x4,  x2, x1      x4 = 5
AND  x5,  x1, x2      x5 = 0
OR   x6,  x1, x2      x6 = 15
XOR  x7,  x1, x2      x7 = 15
SLT  x8,  x1, x2      x8 = 1
SW   x3,  0(x0)       mem[0] = 15
LW   x9,  0(x0)       x9 = 15
LUI  x10, 0xABCD0     x10 = 0xABCD0000
ADDI x10, x10, 0x123  x10 = 0xABCD0123
BEQ  x1,  x4, +8      taken (both are 5) — skips next instruction
ADDI x11, x0, 99      skipped
ADDI x11, x0, 42      x11 = 42
BNE  x1,  x2, +8      taken (5 != 10) — skips next instruction
ADDI x12, x0, 0       skipped
JAL  x13, +8          x13 = return addr, jumps forward
ADDI x14, x0, 55      skipped by JAL
ADDI x14, x0, 77      x14 = 77
JALR x15, x13, 0      x15 = return addr, loops back
```

## Limitations

- LB/LH/SB/SH not implemented (word access only)
- No shift instructions (SLL/SRL/SRA)
- No BLT/BGE/BLTU/BGEU branches
- No AUIPC
- No CSR or exceptions
