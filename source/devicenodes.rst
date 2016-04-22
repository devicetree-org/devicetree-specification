Device Node Requirements
========================

Base Device Node Types
----------------------

The sections that follow specify the requirements for the base set of
device nodes required in an ePAPR-compliant device tree.

All device trees shall have a root node and the following nodes shall be
present at the root of all device trees:

*  One *cpus* node

*  At least one *memory* node

Root node
---------

The device tree has a single root node of which all other device nodes
are descendants. The full path to the root node is ``/``.

.. tabularcolumns:: l c l J
.. table:: Root Node Properties

   =================== ====== ================= ===============================================
   Property Name       Usage  Value Type        Definition                                     
   =================== ====== ================= ===============================================
   ``#address-cells``  R      ``<u32>``         Specifies the number of ``<u32>`` cells to     
                                                represent the address in the *reg* property in 
                                                children of root.                              
   ``#size-cells``     R      ``<u32>``         Specifies the number of ``<u32>`` cells to     
                                                represent the size in the *reg* property in    
                                                children of root.                              
   ``model``           R      ``<string>``      Specifies a string that uniquely identifies    
                                                the model of the system board. The recommended 
                                                format is "manufacturer,model-number".         
   ``compatible``      R      ``<stringlist>``  Specifies a list of platform architectures     
                                                with which this platform is compatible. This   
                                                property can be used by operating systems in   
                                                selecting platform specific code. The          
                                                recommended form of the property value is:     
                                                                                               
                                                ``"manufacturer,model"``                   
                                                                                               
                                                For example:                                   
                                                                                               
                                                ``compatible = "fsl,mpc8572ds"``           
   Usage legend: R=Required, O=Optional, OR=Optional but Recommended, SD=See Definition
   ============================================================================================

.. note:: All other standard properties (section 2.3) are allowed but are optional.

aliases node
------------

A device tree may have an aliases node (``/aliases``) that defines one or
more alias properties. The alias node shall be at the root of the device
tree and have the node name aliases.

Each property of the ``/aliases`` node defines an alias. The property name
specifies the alias name. The property value specifies the full path to
a node in the device tree. For example, the property serial0 =
``"/simple-bus@fe000000/serial@llc500"`` defines the alias serial0.

Alias names shall be a lowercase text strings of 1 to 31 characters from
the following set of characters.

.. tabularcolumns:: c J
.. table:: Valid characters for alias name

   ========= ================
   Character Description
   ========= ================
   0-9       digit
   a-z       lowercase letter
   \-        dash
   ========= ================

An alias value is a device path and is encoded as a string. The value
represents the full path to a node, but the path does not need to refer
to a leaf node.

A client program may use an alias property name to refer to a full
device path as all or part of its string value. A client program, when
considering a string as a device path, shall detect and use the alias.

**Example**

::

    aliases {
        serial0 = "/simple-bus@fe000000/serial@llc500";
        ethernet0 = "/simple-bus@fe000000/ethernet@31c000";
    }

Given the alias serial0, a client program can look at the aliases node
and determine the alias refers to the device path
``/simple-bus@fe000000/serial@llc500``.

Memory node
-----------

A memory device node is required for all device trees and describes the
physical memory layout for the system. If a system has multiple ranges
of memory, multiple memory nodes can be created, or the ranges can be
specified in the *reg* property of a single memory node.

The name component of the node name (see FIXME 2.2.1) shall be memory.

The client program may access memory not covered by any memory
reservations (see section 8.3 FIXME) using any storage attributes it chooses.
However, before changing the storage attributes used to access a real
page, the client program is responsible for performing actions required
by the architecture and implementation, possibly including flushing the
real page from the caches. The boot program is responsible for ensuring
that, without taking any action associated with a change in storage
attributes, the client program can safely access all memory (including
memory covered by memory reservations) as WIMG = 0b001x. That is:

-  not Write Through Required not Caching Inhibited Memory Coherence

-  Required either not Guarded or Guarded (i.e., WIMG = 0b001x)

If the VLE storage attribute is supported, with VLE=0.

.. tabularcolumns:: l c l J
.. table:: Memory Node Properties

   ======================= ====== ===================== ===============================================
   Property Name           Usage  Value Type            Definition
   ======================= ====== ===================== ===============================================
   ``device_type``         R       <string>             Value shall be "memory"
   ``reg``                 R       <prop-encoded-array> Consists of an arbitrary number of address and
                                                        size pairs that specify the physical address
                                                        and size of the memory ranges.
   ``initial-mapped-area`` O       <prop-encoded-array> Specifies the address and size of the Initial
                                                        Mapped Area (see section 5.3 FIXME).

                                                        Is a prop-encoded-array consisting of a
                                                        triplet of (effective address, physical
                                                        address, size). The effective and physical
                                                        address shall each be 64-bit (``<u64>`` value),
                                                        and the size shall be 32-bits (``<u32>`` value).
   Usage legend: R=Required, O=Optional, OR=Optional but Recommended, SD=See Definition
   ====================================================================================================

.. note:: All other standard properties (section 2.3 FIXME) are allowed but are optional.

**Example**

Given a 64-bit Power system with the following physical memory layout:

-  RAM: starting address 0x0, length 0x80000000 (2GB)

-  RAM: starting address 0x100000000, length 0x100000000 (4GB)

Memory nodes could be defined as follows, assuming an ``#address-cells`` == 2
and ``#size-cells`` == 2:

**Example #1**

::

    memory@0 {
        device_type = "memory";
        reg = <0x000000000 0x00000000 0x00000000 0x80000000
               0x000000001 0x00000000 0x00000001 0x00000000>;
    };

**Example #2**

::

    memory@0 {
        device_type = "memory";
        reg = <0x000000000 0x00000000 0x00000000 0x80000000>;
    };
    memory@100000000 {
        device_type = "memory";
        reg = <0x000000001 0x00000000 0x00000001 0x00000000>;
    };

The ``reg`` property is used to define the address and size of the two
memory ranges. The 2 GB I/O region is skipped. Note that the
``#address-cells`` and ``#size-cells`` properties of the root node specify a
value of 2, which means that two 32-bit cells are required to define the
address and length for the ``reg`` property of the memory node.

Chosen
------

The chosen node does not represent a real device in the system but
describes parameters chosen or specified by the system firmware at run
time. It shall be a child of the root node.

The node name (see 2.2.1) shall be chosen.

+------------+---------+---------+------------------------------------------------+
| Property   | Usage   | Value   | Definition                                     |
| Name       |         | Type    |                                                |
+============+=========+=========+================================================+
| bootargs   | O       | <string | A string that specifies the boot arguments for |
|            |         | >       | the client program. The value could            |
|            |         |         | potentially be a null string if no boot        |
|            |         |         | arguments are required.                        |
+------------+---------+---------+------------------------------------------------+
| stdout-pat | O       | <string | A string that specifies the full path to the   |
| h          |         | >       | node representing the device to be used for    |
|            |         |         | boot console output. If the character ":" is   |
|            |         |         | present in the value it terminates the path.   |
|            |         |         | The value may be an alias.                     |
|            |         |         |                                                |
|            |         |         | If the stdin-path property is not specified,   |
|            |         |         | stdout-path should be assumed to define the    |
|            |         |         | input device.                                  |
+------------+---------+---------+------------------------------------------------+
| stdin-path | O       | <string | A string that specifies the full path to the   |
|            |         | >       | node representing the device to be used for    |
|            |         |         | boot console input. If the character ":" is    |
|            |         |         | present in the value it terminates the path.   |
|            |         |         | The value may be an alias.                     |
+------------+---------+---------+------------------------------------------------+

Table: Chosen node properties

Usage legend: R=Required, O=Optional, OR=Optional but Recommended,
SD=See Definition

Note: All other standard properties (section 2.3) are allowed but are
optional.

**Example.**

::

    chosen {
        bootargs = “root=/dev/nfs rw nfsroot=192.168.1.1 console=ttyS0,115200”;
    };

Older versions of device trees may be encountered that contain a
deprecated form of the stdout-path property called linux,stdout-path.
For compatibility, a client program might want to support
linux,stdout-path if a stdout-path property is not present. The meaning
and use of the two properties is identical.

CPUS Node Properties
--------------------

A cpus node is required for all device trees. It does not represent a
real device in the system, but acts as a container for child cpu nodes
which represent the systems CPUs.

The node name (see 2.2.1) shall be cpus.

+------------+---------+---------+------------------------------------------------+
| Property   | Usage   | Value   | Definition                                     |
| Name       |         | Type    |                                                |
+============+=========+=========+================================================+
| #address-c | R       | <u32>   | The value specifies how many cells each        |
| ells       |         |         | element of the *reg* property array takes in   |
|            |         |         | children of this node.                         |
+------------+---------+---------+------------------------------------------------+
| #size-cell | R       | <u32>   | Value shall be 0. Specifies that no size is    |
| s          |         |         | required in the *reg* property in children of  |
|            |         |         | this node.                                     |
+------------+---------+---------+------------------------------------------------+

Table: cpus node properties

Usage legend: R=Required, O=Optional, OR=Optional but Recommended,
SD=See Definition

Note: All other standard properties (section 2.3) are allowed but are
optional.

The cpus node may contain properties that are common across CPU nodes.
See section 3.7 for details.

For an example, see section 3.7.4.

CPU Node Properties
-------------------

A cpu node represents a hardware execution block that is sufficiently
independent that it is capable of running an operating system without
interfering with other CPUs possibly running other operating systems.

Hardware threads that share an MMU would generally be represented under
one cpu node. If other more complex CPU topographies are designed, the
binding for the CPU must describe the topography (e.g. threads that
don’t share an MMU).

CPUs and threads are numbered through a unified number-space that should
match as closely as possible the interrupt controller’s numbering of
CPUs/threads.

Properties that have identical values across CPU nodes may be placed in
the cpus node instead. A client program must first examine a specific
CPU node, but if an expected property is not found then it should look
at the parent cpus node. This results in a less verbose representation
of properties which are identical across all CPUs.

The node name for every cpu node (see 2.2.1) should be cpu.

General Properties of CPU nodes
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following table describes the general properties of CPU nodes. Some
of the properties described in ? are select standard properties with
specific applicable detail.

+------------+---------+---------+------------------------------------------------+
| Property   | Usage   | Value   | Definition                                     |
| Name       |         | Type    |                                                |
+============+=========+=========+================================================+
| device\_ty | R       | <string | Value shall be “cpu”.                          |
| pe         |         | >       |                                                |
+------------+---------+---------+------------------------------------------------+
| reg        | R       | <propen | The value of "reg" is a <prop-encoded-array>   |
|            |         | codedar | that defines a unique CPU/thread id for the    |
|            |         | ray>    | CPU/threads represented by the CPU node.       |
|            |         |         |                                                |
|            |         |         | If a CPU supports more than one thread (i.e.   |
|            |         |         | multiple streams of execution) the *reg*       |
|            |         |         | property is an array with 1 element per        |
|            |         |         | thread. The *#address-cells* on the /cpus node |
|            |         |         | specifies how many cells each element of the   |
|            |         |         | array takes. Software can determine the number |
|            |         |         | of threads by dividing the size of *reg* by    |
|            |         |         | the parent node’s *#address-cells*.            |
|            |         |         |                                                |
|            |         |         | If a CPU/thread can be the target of an        |
|            |         |         | external interrupt the "reg" property value    |
|            |         |         | must be a unique CPU/thread id that is         |
|            |         |         | addressable by the interrupt controller.       |
|            |         |         |                                                |
|            |         |         | If a CPU/thread cannot be the target of an     |
|            |         |         | external interrupt, then "reg" must be unique  |
|            |         |         | and out of bounds of the range addressed by    |
|            |         |         | the interrupt controller                       |
|            |         |         |                                                |
|            |         |         | If a CPU/thread’s PIR is modifiable, a client  |
|            |         |         | program should modify PIR to match the "reg"   |
|            |         |         | property value. If PIR cannot be modified and  |
|            |         |         | the PIR value is distinct from the interrupt   |
|            |         |         | controller numberspace, the CPUs binding may   |
|            |         |         | define a binding-specific representation of    |
|            |         |         | PIR values if desired.                         |
+------------+---------+---------+------------------------------------------------+
| clock-freq | R       | <propen | Specifies the current clock speed of the CPU   |
| uency      |         | codedar | in Hertz. The value is a <prop-encoded-array>  |
|            |         | ray>    | in one of two forms:                           |
|            |         |         |                                                |
|            |         |         | 1. A 32-bit integer consisting of one <u32>    |
|            |         |         |    specifying the frequency.                   |
|            |         |         |                                                |
|            |         |         | 2. A 64-bit integer represented as a <u64>     |
|            |         |         |    specifying the frequency.                   |
+------------+---------+---------+------------------------------------------------+
| timebase-f | R       | <propen | Specifies the current frequency at which the   |
| requency   |         | codedar | timebase and decrementer registers are updated |
|            |         | ray>    | (in Hertz). The value is a                     |
|            |         |         | <prop-encoded-array> in one of two forms:      |
|            |         |         |                                                |
|            |         |         | 1. A 32-bit integer consisting of one <u32>    |
|            |         |         | specifying the frequency. 2. A 64-bit integer  |
|            |         |         | represented as a <u64>.                        |
+------------+---------+---------+------------------------------------------------+
| cache-op-b | SD      | <u32>   | Specifies the block size in bytes upon which   |
| lock-size  |         |         | cache block instructions operate (e.g., dcbz). |
|            |         |         | Required if different than the L1 cache block  |
|            |         |         | size.                                          |
+------------+---------+---------+------------------------------------------------+
| reservatio | SD      | <u32>   | Specifies the reservation granule size         |
| n-granule- |         |         | supported by this processor in bytes.          |
| size       |         |         |                                                |
+------------+---------+---------+------------------------------------------------+
| status     | SD      | <string | A standard property describing the state of a  |
|            |         | >       | CPU. This property shall be present for nodes  |
|            |         |         | representing CPUs in a symmetric               |
|            |         |         | multiprocessing (SMP) configuration. For a CPU |
|            |         |         | node the meaning of the “okay” and “disabled”  |
|            |         |         | values are as follows:                         |
|            |         |         |                                                |
|            |         |         | -  “okay”. The CPU is running.                 |
|            |         |         |                                                |
|            |         |         | -  “disabled”. The CPU is in a quiescent       |
|            |         |         |    state.                                      |
|            |         |         |                                                |
|            |         |         | A quiescent CPU is in a state where it cannot  |
|            |         |         | interfere with the normal operation of other   |
|            |         |         | CPUs, nor can its state be affected by the     |
|            |         |         | normal operation of other running CPUs, except |
|            |         |         | by an explicit method for enabling or          |
|            |         |         | reenabling the quiescent CPU (see the          |
|            |         |         | enable-method property).                       |
|            |         |         |                                                |
|            |         |         | In particular, a running CPU shall be able to  |
|            |         |         | issue broadcast TLB invalidates without        |
|            |         |         | affecting a quiescent CPU.                     |
|            |         |         |                                                |
|            |         |         | Examples: A quiescent CPU could be in a spin   |
|            |         |         | loop, held in reset, and electrically isolated |
|            |         |         | from the system bus or in another              |
|            |         |         | implementation dependent state.                |
|            |         |         |                                                |
|            |         |         | Note: See section 5.5 (Symmetric               |
|            |         |         | Multiprocessing (SMP) Boot Requirements) for a |
|            |         |         | description of how these values are used for   |
|            |         |         | booting multi-CPU SMP systems.                 |
+------------+---------+---------+------------------------------------------------+
| enable-met | SD      | <string | Describes the method by which a CPU in a       |
| hod        |         | list>   | disabled state is enabled. This property is    |
|            |         |         | required for CPUs with a status property with  |
|            |         |         | a value of “disabled”. The value consists of   |
|            |         |         | one or more strings that define the method to  |
|            |         |         | release this CPU. If a client program          |
|            |         |         | recognizes any of the methods, it may use it.  |
|            |         |         | The value shall be one of the following:       |
|            |         |         |                                                |
|            |         |         | -  "spin-table" The CPU is enabled with the    |
|            |         |         |    spin table method defined in the ePAPR.     |
|            |         |         |                                                |
|            |         |         | -  "[vendor],[method]" An                      |
|            |         |         |    implementation-dependent string that        |
|            |         |         |    describes the method by which a CPU is      |
|            |         |         |    released from a "disabled" state. The       |
|            |         |         |    required format is: "vendor,method" where   |
|            |         |         |    vendor is a string describing the name of   |
|            |         |         |    the manufacturer and method is a string     |
|            |         |         |    describing the vendorspecific mechanism.    |
|            |         |         |                                                |
|            |         |         | Example: "fsl,MPC8572DS"                       |
|            |         |         |                                                |
|            |         |         | Note: Other methods may be added to later      |
|            |         |         | revisions of the ePAPR specification.          |
+------------+---------+---------+------------------------------------------------+
| cpu-releas | SD      | <u64>   | The cpu-release-addr property is required for  |
| e-addr     |         |         | cpu nodes that have an enable-method property  |
|            |         |         | value of "spin-table". The value specifies the |
|            |         |         | physical address of a spin table entry that    |
|            |         |         | releases a secondary CPU from its spin loop.   |
|            |         |         |                                                |
|            |         |         | See section 5.5.2, Spin Table or details on    |
|            |         |         | the structure of a spin table.                 |
+------------+---------+---------+------------------------------------------------+
| power-isa- | O       | <string | A string that specifies the numerical portion  |
| version    |         | >       | of the Power ISA version string. For example,  |
|            |         |         | for an implementation complying with Power ISA |
|            |         |         | Version 2.06, the value of this property would |
|            |         |         | be "2.06".                                     |
+------------+---------+---------+------------------------------------------------+
| power-isa- | O       | <empty> | If the power-isa-version property exists, then |
| \*         |         |         | for each category from the Categories section  |
|            |         |         | of Book I of the Power ISA version indicated,  |
|            |         |         | the existence of a property named              |
|            |         |         | power-isa-[CAT], where [CAT] is the            |
|            |         |         | abbreviated category name with all uppercase   |
|            |         |         | letters converted to lowercase, indicates that |
|            |         |         | the category is supported by the               |
|            |         |         | implementation.                                |
|            |         |         |                                                |
|            |         |         | For example, if the power-isa-version property |
|            |         |         | exists and its value is "2.06" and the         |
|            |         |         | power-isa-e.hv property exists, then the       |
|            |         |         | implementation supports                        |
|            |         |         | [Category:Embedded.Hypervisor] as defined in   |
|            |         |         | Power ISA Version 2.06.                        |
+------------+---------+---------+------------------------------------------------+
| mmu-type   | O       | <string | Specifies the CPU’s MMU type.                  |
|            |         | >       |                                                |
|            |         |         | Valid values are shown below:                  |
|            |         |         |                                                |
|            |         |         |     ::                                         |
|            |         |         |                                                |
|            |         |         |         "mpc8xx"                               |
|            |         |         |         "ppc40x"                               |
|            |         |         |         "ppc440"                               |
|            |         |         |         "ppc476"                               |
|            |         |         |         "power-embedded"                       |
|            |         |         |         "powerpc-classic"                      |
|            |         |         |         "power-server-stab"                    |
|            |         |         |         "power-server-slb"                     |
|            |         |         |         "none"                                 |
+------------+---------+---------+------------------------------------------------+

Table: cpu node general properties

Usage legend: R=Required, O=Optional, OR=Optional but Recommended,
SD=See Definition Note: All other standard properties (section 2.3) are
allowed but are optional.

Older versions of device trees may be encountered that contain a
bus-frequency property on CPU nodes. For compatibility, a client-program
might want to support bus-frequency. The format of the value is
identical to that of clock-frequency. The recommended practice is to
represent the frequency of a bus on the bus node using a clock-frequency
property.

TLB Properties
~~~~~~~~~~~~~~

The following properties of a cpu node describe the translate look-aside
buffer in the processor’s MMU.

+------------+---------+---------+------------------------------------------------+
| Property   | Usage   | Value   | Definition                                     |
| Name       |         | Type    |                                                |
+============+=========+=========+================================================+
| tlb-split  | SD      | <empty> | If present specifies that the TLB has a split  |
|            |         |         | configuration, with separate TLBs for          |
|            |         |         | instructions and data. If absent, specifies    |
|            |         |         | that the TLB has a unified configuration.      |
|            |         |         | Required for a CPU with a TLB in a split       |
|            |         |         | configuration.                                 |
+------------+---------+---------+------------------------------------------------+
| tlb-size   | SD      | <u32>   | Specifies the number of entries in the TLB.    |
|            |         |         | Required for a CPU with a unified TLB for      |
|            |         |         | instruction and data addresses.                |
+------------+---------+---------+------------------------------------------------+
| tlb-sets   | SD      | <u32>   | Specifies the number of associativity sets in  |
|            |         |         | the TLB. Required for a CPU with a unified TLB |
|            |         |         | for instruction and data addresses.            |
+------------+---------+---------+------------------------------------------------+
| d-tlb-size | SD      | <u32>   | Specifies the number of entries in the data    |
|            |         |         | TLB. Required for a CPU with a split TLB       |
|            |         |         | configuration.                                 |
+------------+---------+---------+------------------------------------------------+
| d-tlb-sets | SD      | <u32>   | Specifies the number of associativity sets in  |
|            |         |         | the data TLB. Required for a CPU with a split  |
|            |         |         | TLB configuration.                             |
+------------+---------+---------+------------------------------------------------+
| i-tlb-size | SD      | <u32>   | Specifies the number of entries in the         |
|            |         |         | instruction TLB. Required for a CPU with a     |
|            |         |         | split TLB configuration.                       |
+------------+---------+---------+------------------------------------------------+
| i-tlb-sets | SD      | <u32>   | Specifies the number of associativity sets in  |
|            |         |         | the instruction TLB. Required for a CPU with a |
|            |         |         | split TLB configuration.                       |
+------------+---------+---------+------------------------------------------------+

Table: Table 3-7, cpu node TLB properties

Usage legend: R=Required, O=Optional, OR=Optional but Recommended,
SD=See Definition

Note: All other standard properties (section 2.3) are allowed but are
optional.

Internal (L1) Cache Properties
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following properties of a cpu node describe the processor’s internal
(L1) cache.

+------------+---------+---------+------------------------------------------------+
| Property   | Usage   | Value   | Definition                                     |
| Name       |         | Type    |                                                |
+============+=========+=========+================================================+
| cache-unif | SD      | <empty> | If present, specifies the cache has a unified  |
| ied        |         |         | organization. If not present, specifies that   |
|            |         |         | the cache has a Harvard architecture with      |
|            |         |         | separate caches for instructions and data.     |
+------------+---------+---------+------------------------------------------------+
| cache-size | SD      | <u32>   | Specifies the size in bytes of a unified       |
|            |         |         | cache. Required if the cache is unified        |
|            |         |         | (combined instructions and data).              |
+------------+---------+---------+------------------------------------------------+
| cache-sets | SD      | <u32>   | Specifies the number of associativity sets in  |
|            |         |         | a unified cache. Required if the cache is      |
|            |         |         | unified (combined instructions and data)       |
+------------+---------+---------+------------------------------------------------+
| cache-bloc | SD      | <u32>   | Specifies the block size in bytes of a unified |
| k-size     |         |         | cache. Required if the processor has a unified |
|            |         |         | cache (combined instructions and data)         |
+------------+---------+---------+------------------------------------------------+
| cache-line | SD      | <u32>   | Specifies the line size in bytes of a unified  |
| -size      |         |         | cache, if different than the cache block size  |
|            |         |         | Required if the processor has a unified cache  |
|            |         |         | (combined instructions and data).              |
+------------+---------+---------+------------------------------------------------+
| i-cache-si | SD      | <u32>   | Specifies the size in bytes of the instruction |
| ze         |         |         | cache. Required if the cpu has a separate      |
|            |         |         | cache for instructions.                        |
+------------+---------+---------+------------------------------------------------+
| i-cache-se | SD      | <u32>   | Specifies the number of associativity sets in  |
| ts         |         |         | the instruction cache. Required if the cpu has |
|            |         |         | a separate cache for instructions.             |
+------------+---------+---------+------------------------------------------------+
| i-cache-bl | SD      | <u32>   | Specifies the block size in bytes of the       |
| ock-size   |         |         | instruction cache. Required if the cpu has a   |
|            |         |         | separate cache for instructions.               |
+------------+---------+---------+------------------------------------------------+
| i-cache-li | SD      | <u32>   | Specifies the line size in bytes of the        |
| ne-size    |         |         | instruction cache, if different than the cache |
|            |         |         | block size. Required if the cpu has a separate |
|            |         |         | cache for instructions.                        |
+------------+---------+---------+------------------------------------------------+
| d-cache-si | SD      | <u32>   | Specifies the size in bytes of the data cache. |
| ze         |         |         | Required if the cpu has a separate cache for   |
|            |         |         | data.                                          |
+------------+---------+---------+------------------------------------------------+
| d-cache-se | SD      | <u32>   | Specifies the number of associativity sets in  |
| ts         |         |         | the data cache. Required if the cpu has a      |
|            |         |         | separate cache for data.                       |
+------------+---------+---------+------------------------------------------------+
| d-cache-bl | SD      | <u32>   | Specifies the block size in bytes of the data  |
| ock-size   |         |         | cache. Required if the cpu has a separate      |
|            |         |         | cache for data.                                |
+------------+---------+---------+------------------------------------------------+
| d-cache-li | SD      | <u32>   | Specifies the line size in bytes of the data   |
| ne-size    |         |         | cache, if different than the cache block size. |
|            |         |         | Required if the cpu has a separate cache for   |
|            |         |         | data.                                          |
+------------+---------+---------+------------------------------------------------+
| next-level | SD      | <phandl | If present, indicates that another level of    |
| -cache     |         | e>      | cache exists. The value is the phandle of the  |
|            |         |         | next level of cache. The phandle value type is |
|            |         |         | fully described in section 2.3.3.              |
+------------+---------+---------+------------------------------------------------+

Table: Table 3-8 Cache properties

Usage legend: R=Required, O=Optional, OR=Optional but Recommended,
SD=See Definition

Note: All other standard properties (section 2.3) are allowed but are
optional.

Older versions of device trees may be encountered that contain a
deprecated form of the next-level-cache property called l2-cache. For
compatibility, a client-program may wish to support l2-cache if a
next-level-cache property is not present. The meaning and use of the two
properties is identical.

Example
~~~~~~~

Here is an example of a cpus node with one child cpu node:

::

    cpus {
        #address-cells = <1>;
        #size-cells = <0>;
        cpu@0 {
            device_type = "cpu";
            reg = <0>;
            d-cache-block-size = <32>; // L1 - 32 bytes
            i-cache-block-size = <32>; // L1 - 32 bytes
            d-cache-size = <0x8000>; // L1, 32K
            i-cache-size = <0x8000>; // L1, 32K
            timebase-frequency = <82500000>; // 82.5 MHz
            clock-frequency = <825000000>; // 825 MHz
        };
    };

Multi-level and Shared Caches
-----------------------------

Processors and systems may implement additional levels of cache
hierarchy—for example, secondlevel (L2) or third-level (L3) caches.
These caches can potentially be tightly integrated to the CPU or
possibly shared between multiple CPUs.

A device node with a compatible value of "cache" describes these types
of caches.

The cache node shall define a phandle property, and all cpu nodes or
cache nodes that are associated with or share the cache each shall
contain a next-level-cache property that specifies the phandle to the
cache node.

A cache node may be represented under a CPU node or any other
appropriate location in the device tree.

Multiple-level and shared caches are represented with the properties in
Table 3-9. The L1 cache properties are described in Table 3-8.

+------------+---------+---------+------------------------------------------------+
| Property   | Usage   | Value   | Definition                                     |
| Name       |         | Type    |                                                |
+============+=========+=========+================================================+
| compatible | R       | <string | A standard property. The value shall include   |
|            |         | >       | the string “cache”                             |
+------------+---------+---------+------------------------------------------------+
| cache-leve | R       | <u32>   | Specifies the level in the cache hierarchy.    |
| l          |         |         | For example, a level 2 cache has a value of    |
|            |         |         | <2>.                                           |
+------------+---------+---------+------------------------------------------------+

Table: Table 3-9 Multiple-level and shared cache properties

Usage legend: R=Required, O=Optional, OR=Optional but Recommended,
SD=See Definition

Note: All other standard properties (section 2.3) are allowed but are
optional.

**Example.**

See the following example of a device tree representation of two CPUs,
each with their own on-chip L2 and a shared L3.

::

    cpus {
        #address-cells = <1>;
        #size-cells = <0>;
        cpu@0 {
            device_type = "cpu";
            reg = <0>;
            cache-unified;
            cache-size = <0x8000>; // L1, 32KB
            cache-block-size = <32>;
            timebase-frequency = <82500000>; // 82.5 MHz
            next-level-cache = <&L2_0>; // phandle to L2

            L2_0:l2-cache {
                compatible = “cache”;
                cache-unified;
                cache-size = <0x40000>; // 256 KB

                cache-sets = <1024>;
                cache-block-size = <32>;
                cache-level = <2>;
                next-level-cache = <&L3>; // phandle to L3

                L3:l3-cache {
                    compatible = “cache”;
                    cache-unified;
                    cache-size = <0x40000>; // 256 KB
                    cache-sets = <0x400>; // 1024
                    cache-block-size = 
                    cache-level = <3>;
                };
            };
        };

        cpu@1 {
            device_type = "cpu";
            reg = <0>;
            cache-unified;
            cache-block-size = <32>;
            cache-size = <0x8000>; // L1, 32KB
            timebase-frequency = <82500000>; // 82.5 MHz
            clock-frequency = <825000000>; // 825 MHz
            cache-level = <2>;
            next-level-cache = <&L2_1>; // phandle to L2
            L2_1:l2-cache {
                compatible = “cache”;
                cache-unified;
                cache-size = <0x40000>; // 256 KB
                cache-sets = <0x400>; // 1024
                cache-line-size = <32> // 32 bytes
                next-level-cache = <&L3>; // phandle to L3
            };
        };
    };

