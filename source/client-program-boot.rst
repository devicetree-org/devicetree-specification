Client Program Boot Requirements
================================

Boot and Secondary CPUs
-----------------------

A boot cpu is the CPU on which control is transferred from the boot
program to a client program. Other CPUs that belong to the client
program are considered secondary CPUs.

For a partition with multiple CPUs in an SMP configuration, one CPU
shall be designated as the boot cpu. The unit address of the CPU node
for the boot cpu is set in the boot\_cpuid\_phys field of the flattened
device tree header (see section 8.2, Header).

Device Tree
-----------

A boot program shall load a device tree image into the client program’s
memory before transferring control to the client on the boot cpu. The
logical structure of the device tree shall comply with the requirements
specified in section 3.1 (Base Device Node Types). The physical
structure of the device tree image shall comply with the requirements
specified in chapter 8 (Flat Device Tree Physical Structure).

The loaded device tree image shall be aligned on an 8-byte boundary in
the client’s memory.

Initial Mapped Areas
--------------------

CPUs that implement the Power ISA Book III-E embedded environment, which
run with address translation always enabled, have some unique boot
requirements related to initial memory mappings. This section introduces
the concept of an Initial Mapped Area (or IMA), which is applicable to
Book III-E CPUs.

A client program’s IMA is a region of memory that contains the entry
points for a client program. Both boot CPUs and secondary CPUs begin
client program execution in an IMA. The terms Boot IMA (BIMA) and
Secondary IMA (SIMA) are used to distinguish the IMAs for boot CPUs and
secondary CPUs where necessary.

All IMAs have the following requirements:

1. An IMA shall be virtually and physically contiguous

2. An IMA shall start at effective address zero (0) which shall be
   mapped to a physical address naturally aligned to the size of the
   IMA.

3. The mapping shall not be invalidated except by a client program’s
   explicit action (i.e., not subject to broadcast invalidates from
   other CPUs)

4. The Translation ID (TID) field in the TLB entry or entries shall be
   zero.

5. The memory and cache access attributes (WIMGE) have the following
   requirements:

   -  WIMG = 001x

   -  E=0 (i.e., big-endian)

   -  VLE (if implemented) is set to 0

6. An IMA may be mapped by a TLB entry larger than the IMA size,
   provided the MMU guarded attribute is set (G=1)

7. An IMA may span multiple TLB entries.

Those CPUs with an IPROT capable TLB should use the IPROT facility to
ensure requirement #3.

CPU Entry Point Requirements
----------------------------

This section describes the state of the processor and system when a boot
program passes control to a client program.

Boot CPU Initial Register State
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

A boot CPU shall have its initial register values set as described in
the following table.

+---------------------+------------------------------------------------------+
| Register            | Value                                                |
+=====================+======================================================+
| MSR                 | ::                                                   |
|                     |                                                      |
|                     |     PR=0 supervisor state                            |
|                     |     EE=0 interrupts disabled                         |
|                     |     ME=0 machine check interrupt disabled            |
|                     |     IP=0 interrupt prefix-- low memory               |
|                     |     IR=0,DR=0 real mode (see note 1)                 |
|                     |     IS=0,DS=0 address space 0 (see note 1)           |
|                     |     SF=0, CM=0, ICM=0 32-bit mode                    |
|                     |                                                      |
|                     | The state of any additional MSR bits is defined in   |
|                     | the applicable processor supplement specification.   |
+---------------------+------------------------------------------------------+
| R3                  | Effective address of the device tree image. Note:    |
|                     | This address shall be 8 bytes aligned in memory.     |
+---------------------+------------------------------------------------------+
| R4                  | 0                                                    |
+---------------------+------------------------------------------------------+
| R5                  | 0                                                    |
+---------------------+------------------------------------------------------+
| R6                  | ePAPR magic value—to distinguish from non-ePAPR      |
|                     | compliant firmware                                   |
|                     |                                                      |
|                     | -  For Book III-E CPUs shall be 0x45504150           |
|                     |                                                      |
|                     | -  For non-Book III-E CPUs shall be 0x65504150       |
+---------------------+------------------------------------------------------+
| R7                  | shall be the size of the boot IMA in bytes           |
+---------------------+------------------------------------------------------+
| R8                  | 0                                                    |
+---------------------+------------------------------------------------------+
| R9                  | 0                                                    |
+---------------------+------------------------------------------------------+
| TCR                 | WRC=0, no watchdog timer reset will occur (see note  |
|                     | 2)                                                   |
+---------------------+------------------------------------------------------+
| other registers     | implementation dependent                             |
+---------------------+------------------------------------------------------+

Table: Table 5-1 Boot CPU initial register values

Note 1: Applicable only to CPUs that define these bits

Note 2: Applicable to Book III-E CPUs only

On a multi-threaded processor that supports [Category: Embedded
Multi-Threading], the client program shall be entered on thread zero
with the register values defined in the preceding table. All other
threads shall be disabled and shall have register values set as defined
in the preceding table except as follows:

-  R3 shall be zero.

-  R6 shall be zero.

-  R7 shall be zero.

-  PC shall be 0x4.

The boot program is expected to place a store instruction at effective
address 0x0 and a branch-to-self instruction at effective address 0x4.
The store instruction is expected to be used to set a shared variable
indicating that the thread has reached the branch-to-self instruction
and is ready to be disabled.

I/O Devices State
~~~~~~~~~~~~~~~~~

The boot program shall leave all devices with the following conditions
true:

-  All devices: no DMA and not interrupting

-  Host bridges: responding to config cycles and passing through config
   cycles to children

Initial I/O Mappings (IIO)
~~~~~~~~~~~~~~~~~~~~~~~~~~

A boot program might pass a client program a device tree containing
device nodes with a *virtual-reg* property (see 2.3.7, *virtual-reg*).
The *virtual-reg* property describes an Initial I/O (or IIO) mapping set
up by firmware, and the value is the effective address of a device’s
registers.

For Book III-E CPUs, effective to physical address mappings shall be
present in the CPU’s MMU to map any IIO. An IIO has the following
requirements on Book III-E CPUs:

1. An IIO shall be virtually and physically contiguous.

2. An IIO shall map the effective address in *virtual-reg* to the
   physical address at which the device appears at the point of entry.

3. An IIO shall not be invalidated except by client’s explicit action
   (i.e., not subject to broadcast invalidates from other partitions).

4. The Translation ID (TID) field in the TLB entry shall be zero.

5. The memory and cache access attributes (WIMGE) have the following
   requirements:

   -  WIMG shall be suitable for accessing the device in question.
      Typically I=1, G=1.

   -  E=0 (i.e., big-endian)

6. An IIO shall be large enough to cover all of device’s registers.

7. Multiple devices may share an IIO.

Boot CPU Entry Requirements: Real Mode
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For real mode (i.e., non-Book III-E) CPUs, the following requirements
apply at client entry for boot CPUs: 1. The CPU shall have address
translation disabled at client entry (i.e., MSR[IR]=0, MSR[DR]=0). 2.
All PT\_LOAD segments shall be loaded into an area of memory that is
appropriate for the platform. 3. The device tree shall be loaded into an
area of memory that is appropriate for the platform (with the address in
r3). The device tree must not overlap any PT\_LOAD segment (taking into
account the p\_memsz field in the program header which may be different
than p\_filesz). 4. r7 shall contain the size of the contiguous physical
memory available to the client.

Boot CPU Entry Requirements for IMAs: Book IIII-E
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For Book III-E CPUs the following requirements apply at client entry for
boot CPUs:

1. The Boot IMA (BIMA) mapping in the MMU shall be mapped at effective
   address 0.

2. All PT\_LOAD segments shall be loaded into BIMA.

3. The device tree shall be loaded into the BIMA (with the address in
   r3). The device tree must not overlap any PT\_LOAD segment (taking
   into account the p\_memsz field in the program header which may be
   different than p\_filesz).

4. IIOs shall be present for all devices with a *virtual-reg* property

5. Other mappings may be present in Address Space (AS) 0.

6. No mappings shall be present in Address Space (AS) 1.

7. r7 shall contain the size of the BIMA.

8. The MMU mappings for the BIMA and all IIOs shall be such that the
   TLBs can accommodate a reasonable number of additional mappings.

-  A boot program might wish to select BIMA size based on client image
   layout in order to satisfy requirement #2

-  Client can determine physical address of IMA by either of two
   methods:

   1. tlbsx on EA 0, then read and parse TLB entry

   2. from the optional initial-mapped-area property on a memory node

Symmetric Multiprocessing (SMP) Boot Requirements
-------------------------------------------------

Overview
~~~~~~~~

For CPUs in an SMP configuration, one CPU shall be designated the boot
CPU and initialized as described in section 5.4, CPU Entry Point
Requirements. All other CPUs are considered secondary.

A boot program passes control to a client program on the boot CPU only.
At the time the client program is started, all secondary CPUs shall in a
quiescent state. A quiescent CPU is in a state where it cannot interfere
with the normal operation of other CPUs, nor can its state be affected
by the normal operation of other running CPUs, except by an explicit
method for enabling or re-enabling the quiescent CPU. The status
property of the quiescent CPU’s cpu node in the device tree shall have a
value of “disabled” (see 3.7.1, General Properties of CPU nodes).

Secondary CPUs may be started using the spin table or
implementation-specific mechanisms described in the following sections.

Spin Table
~~~~~~~~~~

Overview
^^^^^^^^

The ePAPR defines a spin table mechanism for starting secondary CPUs.
The boot program places all secondary CPUs into a loop where each CPU
spins until the branch\_address field in the spin table is updated
specifying that the core is released.

A spin table is a table data structure consisting of 1 entry per CPU
where each entry is defined as follows:

    ::

        struct {
            uint64_t entry_addr;
            uint64_t r3;
            uint32_t rsvd1;
            uint32_t pir;
        };

The spin table fields are defined as follows:

+------------+---------------------------------------------------------------+
| entry\_add | Specifies the physical address of the client entry point for  |
| r          | the spin table code to branch to. The boot program’s spin     |
|            | loop must wait until the least significant bit of entry\_addr |
|            | is zero.                                                      |
+------------+---------------------------------------------------------------+
| r3         | Contains the value to put in the r3 register at secondary cpu |
|            | entry. The high 32-bits are ignored on 32-bit chip            |
|            | implementations. 64-bit chip implementations however shall    |
|            | load all 64-bits                                              |
+------------+---------------------------------------------------------------+
| pir        | Contains a value to load into the PIR (processor              |
|            | identification) register for those CPUs with writable PIR.    |
+------------+---------------------------------------------------------------+

Before a secondary CPU enters a spin loop, the spin table fields shall
be set with these initial values:

+--------------------------------------+--------------------------------------+
| Field                                | Initial Value                        |
+======================================+======================================+
| entry\_addr                          | 0x1                                  |
+--------------------------------------+--------------------------------------+
| r3                                   | Value of the *reg* property from the |
|                                      | CPU node in the device tree that     |
|                                      | corresponds to this CPU.             |
+--------------------------------------+--------------------------------------+
| pir                                  | A valid PIR value, different on each |
|                                      | CPU within the same partition.       |
+--------------------------------------+--------------------------------------+

The spin table shall be cache-line size aligned in memory.

The boot program and client program shall ensure that all virtual pages
through which the spin table can be accessed have storage control
attributes such that all accesses to the spin table are not Write
Through Required, not Caching Inhibited, Memory Coherence Required, and
either not Guarded or Guarded (i.e., WIMG = 0b001x). Further, if the E
storage attribute is supported, it shall be set to BigEndian (E = 0),
and if the VLE storage attribute is supported, it shall be set to 0.

Some older boot programs perform Caching Inhibited and not Memory
Coherence Required accesses to the spin table, taking advantage of
implementation-specific knowledge of the behavior of accesses to shared
storage with conflicting Caching Inhibited attribute values. If
compatibility with such boot programs is required, client programs
should use dcbf to flush a spin table entry from the caches both before
and after accessing the spin table entry.

Boot Program Requirements
^^^^^^^^^^^^^^^^^^^^^^^^^

The boot program shall place a spin loop and spin table into an area of
memory that is appropriate for the platform. If the spin loop and table
reside in a memory region belonging to a client program, the memory
occupied by the loop and table shall be marked reserved in the device
tree’s DTB memory reservation block (see section 8.3, Memory Reservation
Block).

Before starting a client program on the boot cpu, the boot program shall
set certain properties in the device tree passed to the client as
follows:

-  Each secondary CPU’s cpu node shall have a status property with a
   value of “disabled”.

-  Each secondary CPU’s cpu node shall have an enable-method property.

-  For each secondary cpu node with an enable-method value of
   “spin-table”, the cpu node shall have a cpu-release-addr property
   that describes the address of the applicable spin table entry to
   release the CPU.

For secondary CPUs with address translation always enabled (e.g., Book
III-E), the boot program shall set up an address mapping in the
secondary CPU’s MMU for the spin loop and table.

The boot program shall place a spinning CPU in a quiescent state where
it cannot interfere with the normal operation of other CPUs, nor can its
state be affected by the normal operation of other running CPUs, except
by an explicit method for enabling or reenabling the quiescent CPU. (see
the enable-method property). Note in particular that a running CPU shall
be able to issue broadcast TLB invalidations without affecting a
quiescent CPU.

When a secondary CPU is released from its spin loop, its state shall be
identical to the state of boot CPUs (see 5.4.1, Boot CPU Initial
Register State) except as noted here:

-  R3 contains the value of the r3 field from the spin table (only for
   the first thread of the CPU).

-  R6 shall be 0.

-  If the CPU has a programmable PIR register, the PIR shall contain the
   value of the pir field from the spin table.

-  No I/O device mappings (see 5.4.3, Initial I/O Mappings (IIO)) are
   required.

-  For CPUs with address translation always enabled:

   -  The Secondary IMA (SIMA) mapping (described in 5.3, Initial Mapped
      Areas) in the MMU shall map effective address 0 to the entry\_addr
      field in the spin table, aligned down to the SIMA size.

   -  R7 shall contain the size of the SIMA.

   -  The SIMA shall have a minimum size of 1MiB.

   -  Other mappings may be present in Address Space (AS) 0.

   -  No mappings shall be present in Address Space (AS) 1.

   -  The MMU mapping for the SIMA shall be such that the TLBs can
      accommodate a reasonable number of additional mappings.

   -  The SIMA mapping shall not be affected by any actions taken by any
      other CPU.

-  For real mode (i.e., non-Book III-E) CPUs:

   -  The CPU shall have address translation disabled at client entry
      (i.e., (MSR[IR] =0, MSR[DR]=0).

   -  R7 shall contain the size of the contiguous physical memory
      available to the client.

Note: Spin table entries do not need to lie in either the BIMA or SIMA.

-  A client program should physically align its secondary entry points
   so that the 1MiB SIMA size requirement is sufficient to ensure that
   enough code is in the SIMA to transfer the secondary CPU to the
   client’s MMU domain (which will typically involve a temporary mapping
   in AS1)

-  Boot programs will typically need to establish the SIMA mapping after
   leaving the spin loop and reading the entry\_addr spin table field.
   However, this mapping might not be necessary if, for example, the
   boot program always uses a SIMA that covers all RAM.

Client Program Requirements
^^^^^^^^^^^^^^^^^^^^^^^^^^^

When a client program is started on its boot CPU, it is passed a device
tree that specifies all secondary CPUs that belong to the client, the
state of those CPUs, and the address of the spin table entry to release
each CPU.

For each secondary CPU, the physical address of the spin table entry for
the CPU is specified in the device tree in the cpu node’s
cpu-release-addr property. To activate a secondary CPU, the client
program (running on the boot cpu) may write the pir field value, may
write the r3 value, may write the most significant 32 bits of the
entry\_addr value, and shall write the least significant 32 bits of the
entry\_addr value. After the client has written the least significant 32
bits of the entry\_addr field, the entry\_addr field might subsequently
be altered by the boot program.

The client program may use a 64-bit store instruction to write both the
most significant 32 bits and the least significant 32 bits of the
entry\_addr field atomically. However, since the client program is
permitted to use two 32-bit store instructions to write the entry\_addr
field (the first store for the most significant 32 bits and the second
store for the least significant 32 bits), the boot program’s spin loop
must wait until the least significant bit of entry\_addr is zero (in
particular, it is insufficient for the boot program only to wait until
entry\_addr has a value other than 0x1).

Implementation-Specific Release from Reset
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Some CPUs have implementation-specific mechanisms to hold CPUs in reset
(or otherwise inhibit them from executing instructions) and can also
direct CPUs to arbitrary reset vectors.

The use of implementation-specific mechanisms is permitted by the ePAPR.
CPUs with this capability are indicated by an implementation-specific
value in the enable-method property of a CPU node. A client program can
release these types of CPUs using implementation-specific means not
specified by the ePAPR.

Timebase Synchronization
~~~~~~~~~~~~~~~~~~~~~~~~

For configurations that use the spin table method of booting secondary
cores (i.e.CPU’s enablemethod = “spin-table”), the boot program shall
enable and synchronize the time base (TBU and TBL) across the boot and
secondary CPUs.

For configurations that use implementation specific methods (see section
5.5.3) to release secondary cores, the methods must provide some means
of synchronizing the time base across CPUs. The precise means to
accomplish this, which steps are the responsibility of the boot program,
and which are the responsibility of the client program is specified by
the implementation specific method.

Asymmetric Configuration Considerations
---------------------------------------

For multiple CPUs in a partitioned or asymmetric (AMP) configuration,
the ePAPR boot requirements apply independently to each domain or
partition. For example, a four-CPU system could be partitioned into
three domains: one SMP domain with two CPUs and two UP domains each with
one CPU. Each domain could have distinct client image, device tree, boot
cpu, etc.

