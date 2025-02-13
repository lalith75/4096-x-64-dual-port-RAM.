# 4096 x 64 Dual-Port RAM

A dual-port RAM allows simultaneous read and write operations. This specialized type of RAM features two unidirectional data ports: an input port for writing data and an output port for reading data. Each port has its own dedicated data and address buses. The write port includes a `WRITE` signal to enable data writing, while the read port has a `READ` signal to enable data output. Both read and write operations occur on the rising edge of the clock.

## Design Overview

- **Write Driver**: Receives three signals:
  - `write`: 0/1 (write enable)
  - `wr_address`: Write address
  - `data_in`: Data to be written

- **Read Driver**: Receives two signals:
  - `read`: Read enable
  - `rd_address`: Read address

Data is transferred between modules using parameterized classes (`ram_trans`). The reference model samples data from the read and write monitors to compare it with the scoreboard. The scoreboard includes coverpoints to ensure comprehensive signal coverage.

---

## Verification Plan

### Features

- **Reset**
- **Read (To Avoid)**:
  - Random Read: Reading from an empty location
  - Random Read: Reading the same location consecutively
- **Write (To Avoid)**:
  - Random Write: Writing to the same location consecutively
- **Read + Write (To Avoid)**:
  - Simultaneous Read and Write on the same memory location

### Strategies

- **Reset**:
  - Write zeros into the memory.
- **Read**:
  - Random Read: Read valid data.
    - Scoreboard (SB): Compare data only during read operations.
    - Receiver: Collect read address and data output, then create a transaction.
  - Random Read: Reading from an empty location.
    - SB: Display message: "No random data written."
  - Random Read: Reading the same location consecutively.
- **Write**:
  - Random Write: Writing to the same location consecutively.
- **Memory Model**:
  - A reference model for memory is implemented using an associative array.
- **Read + Write**:
  - Simultaneous Read and Write on the same memory location is not allowed. Define constraints in the transaction.

---

## Transaction Model

### Base Class
- Randomizes:
  - Read and Write addresses
  - Input and Output data
  - Read and Write control signals

### Extended Classes
- **TC1**: Weighted randomization for input data and address.
- **TC2**: Additional constraints for address and data.
- **TC3**: Directed test cases.

---

## Transactors

- **Generator**: Generates random transactions.
- **Driver**: Drives address, `data_in`, and control signals for read and write operations.
- **Monitor**: Collects read address and data output, then composes the received transaction.
  - **Note**: In the testbench, it takes **2 clock cycles** for the monitor to sample the driven signals (read and write) from the driver.
- **Scoreboard (SB)**: Compares transactions and generates coverage.

![image](https://github.com/user-attachments/assets/5a26ce2c-647b-4658-bdff-f81583e1710b)

---

## Coverage Model

### Write Coverage
- **WR ADD**: [MIN, MID, MAX]
- **DATA**: [MIN, MID, MAX]
- **WR**
- **WRITE x ADD x DATA**

### Read Coverage
- **RD ADD**: [MIN, MID, MAX]
- **DATA**: [MIN, MID, MAX]
- **RD**
- **READ x ADD x DATA**

---

## Implementation and Results

This project was implemented and verified using **Synopsys Verdi**. The functional coverage results for the test cases are as follows:
- **Test Case 1**: 78% functional coverage achieved.
- **Test Case 2**: 90% functional coverage achieved.

---

This project implements a 4096 x 64 dual-port RAM with a comprehensive verification plan to ensure functionality and coverage. The testbench is designed such that the monitor requires **2 clock cycles** to sample the driven signals (read and write) from the driver.
