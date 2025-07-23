## 🧩 Architecture

The processor includes the following modules:

- **ALU**: Supports arithmetic and logic operations (ADD, SUB, AND, OR, etc.)
- **Control Unit**: Generates control signals based on the opcode of the instruction.
- **Program Counter (PC)**: Holds the address of the current instruction.
- **Accumulator**: Stores intermediate results.
- **Register File**: A small bank of general-purpose registers.
- **Memory Unit**: Stores instructions and data.
- **Top Module**: Integrates all components into a single system.


## 🧪 Testing & Simulation

- Developed testbenches for each core component and the integrated system.
- Verified instruction execution, data transfer, and control signal generation via simulation.
- Designed to be compatible with FPGA mapping (tested on Xilinx Vivado/ModelSim).
