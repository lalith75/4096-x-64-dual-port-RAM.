# 4096-x-64-dual-port-RAM

Dual port RAM can be written and read simultaneously. This special type of RAM has two unidirectional data ports an input port for writing data and an output port for reading data. Each port has its own data and address buses. The write port has a signal called WRITE to allow writing the data. The read port has a signal called READ to enable the data output. Both reading and writing data occur on the rising clock edge.
The write driver gets 3 signals: write:0/1, wr_address and data_in.
The read driver gets 2 signals: read and rd_address
The data is received and transferred through modules with the help of modules parameterised to class ram_trans.
The reference model samples the data from read monitor and write monitor to reference the data with scoreboard.
The scoreboard has coverpoints to check the coverage of all the signals.

****Verification Plan:****

**Features:**
**Reset** 
**Read (To Avoid)**
Random Read - Reading the empty location 
Random Read - Reading the same locations consecutively 
**Write (To Avoid)**
Random Write - Writing into the same locations consecutively 
**Read+Write (To Avoid)
**Read+Write - on the same memory location

**Strategies:**
Reset 
Write zeros into the memory 
**Read** 
Random read - reading the valid data 
SB: Compare the data only during read operation 
Receiver: Collect the read address and data out and create transaction 
Random Read - Reading the empty location 
SB: Message: NO random data written 
Random Read - Reading the same locations consecutively 
**Write** 
Random Write - Writing into the same locations consecutively 
**Memory Model**
Model: A reference model for memory is implemented using associative array 
**Read+Write **
Read+Write - on the same memory location 
Not allowed - Define a constraint in Transaction

**Transaction** 
**Base Class **- Random: Read and Write Addresses, Input Data, Output data, Read and Write control signals 
**Extended Classes: **
TC1: Input data & Address - Weighted Random, 
TC2: Address & Data - Additional constraints, 
TC3: Directed 
**Transactors **
**Generator** - generates random transaction 
**Driver** - Drives address, data_in and control signals for Read and Write operations 
**Monitor** - Collects the read address and data out and composes received transaction 
**SB** - Compares the transactions and generates coverage 
**Coverage Model - Write**
WR ADD: [MIN, MID, MAX] 
DATA: [MIN, MID, MAX] 
WR 
WRITEXADDXDATA 
**Coverage Model - Read**
RD ADD: [MIN, MID, MAX] 
DATA: [MIN, MID, MAX] 
RD 
READXADDXDATA
