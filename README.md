# Microprocessor implementation in Verilog
Implementation of an simple microprocessor in Verilog.

## Microprocessor Details
Our microprocessor supports 4 instructions: add, load, store, jump.      
Also our microprocessor is not pipelined; the fetch -> decode -> execute cycle is done in 1 clk cycle.

The encodings for each instructions are shown as below: 

![image](https://github.com/user-attachments/assets/9c8328c7-deac-4c94-ae63-f6f6464a932e)

Our microprocessor also displays the Reg Write Data (only when enabled), current PC value, and the type of instruction (A: Add, L: Load, S: Store, J: Jump) in 7-segment display.

The implementations and the figures are adapted from the final project of SNU Logic Design (2025 Spring).
