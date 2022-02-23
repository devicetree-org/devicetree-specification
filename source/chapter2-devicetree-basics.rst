.. SPDX-License-Identifier: Apache-2.0

.. _chapter-devicetree:

The Devicetree
==============

Overview
--------

|spec| specifies a construct called a *devicetree* to describe
system hardware. A boot program loads a devicetree into a client
program’s memory and passes a pointer to the devicetree to the client.

This chapter describes the logical structure of the devicetree and
specifies a base set of properties for use in describing device nodes.
:numref:`Chapter %s <chapter-device-node-requirements>` specifies certain device nodes
required by a |spec|-compliant
devicetree. :numref:`Chapter %s <chapter-device-bindings>` describes the
|spec|-defined device bindings -- the requirements for representing
certain device types or classes of devices.
:numref:`Chapter %s <chapter-fdt-structure>` describes the in-memory encoding of the devicetree.

A devicetree is a tree data structure with nodes that describe the
devices in a system. Each node has property/value pairs that describe
the characteristics of the device being represented. Each node has
exactly one parent except for the root node, which has no parent.

A |spec|-compliant devicetree describes device information in a system
that cannot necessarily be dynamically detected by a client program. For
example, the architecture of PCI enables a client to probe and detect
attached devices, and thus devicetree nodes describing PCI devices
might not be required. However, a device node is required to describe a
PCI host bridge device in the system if it cannot be detected by
probing.

**Example**

:numref:`example-simple-devicetree` shows an example representation of a
simple devicetree that is nearly
complete enough to boot a simple operating system, with the platform
type, CPU, memory and a single UART described. Device nodes are shown
with properties and values inside each node.

.. _example-simple-devicetree:
.. digraph:: tree
   :caption: Devicetree Example

   rankdir = LR;
   ranksep = equally;
   size = "6,8"
   node [ shape="Mrecord"; width="3.5"; fontname = Courier; ];

   "/" [ label = "\N |
   model=\"fsl,mpc8572ds\"\l
   compatible=\"fsl,mpc8572ds\"\l
   #address-cells=\<1\>\l
   #size-cells=\<1\>\l"]

   "cpus" [ label="\N |
   #address-cells=\<1\>\l
   #size-cells=\<0\>\l"]

   "cpu@0" [ label="\N |
   device_type=\"cpu\"\l
   reg=\<0\>\l
   timebase-frequency=\<825000000\>\l
   clock-frequency=\<825000000\>\l"]

   "cpu@1" [ label="\N |
   device_type=\"cpu\"\l
   reg=\<1\>\l
   timebase-frequency=\<825000000\>\l
   clock-frequency=\<825000000\>\l"]

   "memory@0" [ label="\N |
   device_type=\"memory\"\l
   reg=\<0 0x20000000\>\l"]

   "uart@fe001000" [ label="\N |
   compatible=\"ns16550\"\l
   reg=\<0xfe001000 0x100\>\l"]

   "chosen" [ label="\N |
   bootargs=\"root=/dev/sda2\"\l"]

   "aliases" [ label="\N |
   serial0=\"/uart@fe001000\"\l"]

   "/":e    -> "cpus":w
   "cpus":e -> "cpu@0":w
   "cpus":e -> "cpu@1":w
   "/":e    -> "memory@0":w
   "/":e    -> "uart@fe001000":w
   "/":e    -> "chosen":w
   "/":e    -> "aliases":w

Devicetree Structure and Conventions
------------------------------------

.. _sect-node-names:

Node Names
~~~~~~~~~~

Node Name Requirements
^^^^^^^^^^^^^^^^^^^^^^

Each node in the devicetree is named according to the following
convention:

   ``node-name@unit-address``

The *node-name* component specifies the name of the node. It shall be 1
to 31 characters in length and consist solely of characters from the set
of characters in :numref:`node-name-characters`.

.. tabularcolumns:: | c p{8cm} |
.. _node-name-characters:
.. table:: Valid characters for node names

   ========= ================
   Character Description
   ========= ================
   ``0-9``   digit
   ``a-z``   lowercase letter
   ``A-Z``   uppercase letter
   ``,``     comma
   ``.``     period
   ``_``     underscore
   ``+``     plus sign
   ``-``     dash
   ========= ================

The *node-name* shall start with a lower or uppercase character and
should describe the general class of device.

The *unit-address* component of the name is specific to the bus type on
which the node sits. It consists of one or more ASCII characters from
the set of characters in :numref:`node-name-characters`. The
unit-address must match the first
address specified in the *reg* property of the node. If the node has no
*reg* property, the *@unit-address* must be omitted and the
*node-name* alone differentiates the node from other nodes at the same
level in the tree. The binding for a particular bus may specify
additional, more specific requirements for the format of *reg* and the
*unit-address*.

In the case of *node-name* without an *@unit-address* the *node-name* shall
be unique from any property names at the same level in the tree.

The root node does not have a node-name or unit-address. It is
identified by a forward slash (/).

.. _example-nodenames:
.. digraph:: tree
   :caption: Examples of Node Names

   rankdir = LR;
   ranksep = equally;
   size = "6,8"
   node [ shape="Mrecord"; width="2.5"; fontname = Courier; ];

   "/":e    -> "cpus":w
   "cpus":e -> "cpu@0":w
   "cpus":e -> "cpu@1":w
   "/":e    -> "memory@0":w
   "/":e    -> "uart@fe001000":w
   "/":e    -> "ethernet@fe002000":w
   "/":e    -> "ethernet@fe003000":w

In :numref:`example-nodenames`:

* The nodes with the name ``cpu`` are distinguished by their unit-address
  values of 0 and 1.
* The nodes with the name ``ethernet`` are distinguished by their
  unit-address values of ``fe002000`` and ``fe003000``.

Generic Names Recommendation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The name of a node should be somewhat generic, reflecting the function
of the device and not its precise programming model. If appropriate, the
name should be one of the following choices:

.. FIXME should describe when each node name is appropriate

.. hlist::
   :columns: 3

   * adc
   * accelerometer
   * air-pollution-sensor
   * atm
   * audio-codec
   * audio-controller
   * backlight
   * bluetooth
   * bus
   * cache-controller
   * camera
   * can
   * charger
   * clock
   * clock-controller
   * co2-sensor
   * compact-flash
   * cpu
   * cpus
   * crypto
   * disk
   * display
   * dma-controller
   * dsi
   * dsp
   * eeprom
   * efuse
   * endpoint
   * ethernet
   * ethernet-phy
   * fdc
   * flash
   * gnss
   * gpio
   * gpu
   * gyrometer
   * hdmi
   * hwlock
   * i2c
   * i2c-mux
   * ide
   * interrupt-controller
   * iommu
   * isa
   * keyboard
   * key
   * keys
   * lcd-controller
   * led
   * leds
   * led-controller
   * light-sensor
   * lora
   * magnetometer
   * mailbox
   * mdio
   * memory
   * memory-controller
   * mmc
   * mmc-slot
   * mouse
   * nand-controller
   * nvram
   * oscillator
   * parallel
   * pc-card
   * pci
   * pcie
   * phy
   * pinctrl
   * pmic
   * pmu
   * port
   * ports
   * power-monitor
   * pwm
   * regulator
   * reset-controller
   * rng
   * rtc
   * sata
   * scsi
   * serial
   * sound
   * spi
   * spmi
   * sram-controller
   * ssi-controller
   * syscon
   * temperature-sensor
   * timer
   * touchscreen
   * tpm
   * usb
   * usb-hub
   * usb-phy
   * video-codec
   * vme
   * watchdog
   * wifi

Path Names
~~~~~~~~~~

A node in the devicetree can be uniquely identified by specifying the
full path from the root node, through all descendant nodes, to the
desired node.

The convention for specifying a device path is:

    ``/node-name-1/node-name-2/node-name-N``

For example, in :numref:`example-nodenames`, the device path to cpu #1 would be:

    ``/cpus/cpu@1``

The path to the root node is /.

A unit address may be omitted if the full path to the node is
unambiguous.

If a client program encounters an ambiguous path, its behavior is
undefined.

Properties
~~~~~~~~~~

Each node in the devicetree has properties that describe the
characteristics of the node. Properties consist of a name and a value.

Property Names
^^^^^^^^^^^^^^

Property names are strings of 1 to 31 characters from the characters show in
:numref:`property-name-characters`

.. tabularcolumns:: | c p{8cm} |
.. _property-name-characters:
.. table:: Valid characters for property names

   ========= ================
   Character Description
   ========= ================
   ``0-9``   digit
   ``a-z``   lowercase letter
   ``A-Z``   uppercase letter
   ``,``     comma
   ``.``     period
   ``_``     underscore
   ``+``     plus sign
   ``?``     question mark
   ``#``     hash
   ``-``     dash
   ========= ================

Nonstandard property names should specify a unique string prefix, such
as a stock ticker symbol, identifying the name of the company or
organization that defined the property. Examples:

   | ``fsl,channel-fifo-len``
   | ``ibm,ppc-interrupt-server#s``
   | ``linux,network-index``

.. _sect-property-values:

Property Values
^^^^^^^^^^^^^^^

A property value is an array of zero or more bytes that contain
information associated with the property.

Properties might have an empty value if conveying true-false
information. In this case, the presence or absence of the property is
sufficiently descriptive.

:numref:`property-values-table` describes the set of basic value types defined by the |spec|.

.. tabularcolumns:: | p{4cm} p{12cm} |
.. _property-values-table:
.. table:: Property values
   :class: longtable

   ======================== ==================================================================
   Value                    Description
   ======================== ==================================================================
   ``<empty>``              Value is empty. Used for conveying true-false information, when
                            the presence or absence of the property itself is sufficiently
                            descriptive.
   ``<u32>``                A 32-bit integer in big-endian format. Example: the 32-bit value
                            0x11223344 would be represented in memory as:

                               ::

                                  address    11
                                  address+1  22
                                  address+2  33
                                  address+3  44
   ``<u64>``                Represents a 64-bit integer in big-endian format. Consists of
                            two ``<u32>`` values where the first value contains the most
                            significant bits of the integer and the second value contains
                            the least significant bits.

                            Example: the 64-bit value 0x1122334455667788 would be
                            represented as two cells as: ``<0x11223344 0x55667788>``.

                            The value would be represented in memory as:

                               ::

                                    address  11
                                  address+1  22
                                  address+2  33
                                  address+3  44
                                  address+4  55
                                  address+5  66
                                  address+6  77
                                  address+7  88
   ``<string>``             Strings are printable and null-terminated. Example: the string
                            "hello" would be represented in memory as:

                               ::

                                    address  68  'h'
                                  address+1  65  'e'
                                  address+2  6C  'l'
                                  address+3  6C  'l'
                                  address+4  6F  'o'
                                  address+5  00  '\0'
   ``<prop-encoded-array>`` Format is specific to the property. See the property definition.
   ``<phandle>``            A ``<u32>`` value. A *phandle* value is a way to reference another
                            node in the devicetree. Any node that can be referenced defines
                            a phandle property with a unique ``<u32>`` value. That number
                            is used for the value of properties with a phandle value
                            type.
   ``<stringlist>``         A list of ``<string>`` values concatenated together.

                            Example: The string list "hello","world" would be represented in
                            memory as:

                               ::

                                      address  68  'h'
                                    address+1  65  'e'
                                    address+2  6C  'l'
                                    address+3  6C  'l'
                                    address+4  6F  'o'
                                    address+5  00  '\0'
                                    address+6  77  'w'
                                    address+7  6f  'o'
                                    address+8  72  'r'
                                    address+9  6C  'l'
                                   address+10  64  'd'
                                   address+11  00  '\0'
   ======================== ==================================================================

.. _sect-standard-properties:

Standard Properties
-------------------

|spec| specifies a set of standard properties for device nodes. These
properties are described in detail in this section.
Device nodes defined by |spec|
(see :numref:`Chapter %s <chapter-device-node-requirements>`) may specify
additional requirements or constraints regarding the use of the standard
properties.
:numref:`Chapter %s <chapter-device-bindings>` describes the representation
of specific devices and may also specify additional requirements.

.. note:: All examples of devicetree nodes in this document use the
   :abbr:`DTS (Devicetree Source)` format for specifying nodes and properties.


.. _sect-standard-properties-compatible:

compatible
~~~~~~~~~~

Property name: ``compatible``

Value type: ``<stringlist>``

Description:

   The *compatible* property value consists of one or more strings that
   define the specific programming model for the device. This list of
   strings should be used by a client program for device driver selection.
   The property value consists of a concatenated list of null terminated
   strings, from most specific to most general. They allow a device to
   express its compatibility with a family of similar devices, potentially
   allowing a single device driver to match against several devices.

   The recommended format is ``"manufacturer,model"``, where
   ``manufacturer`` is a string describing the name of the manufacturer
   (such as a stock ticker symbol), and ``model`` specifies the model
   number.

   The compatible string should consist only of lowercase letters, digits and
   dashes, and should start with a letter. A single comma is typically only
   used following a vendor prefix. Underscores should not be used.

Example:

   ``compatible = "fsl,mpc8641", "ns16550";``

   In this example, an operating system would first try to locate a device
   driver that supported fsl,mpc8641. If a driver was not found, it
   would then try to locate a driver that supported the more general
   ns16550 device type.

model
~~~~~

Property name: ``model``

Value type: ``<string>``

Description:

   The model property value is a ``<string>`` that specifies the manufacturer’s
   model number of the device.

   The recommended format is: ``"manufacturer,model"``, where
   ``manufacturer`` is a string describing the name of the manufacturer
   (such as a stock ticker symbol), and model specifies the model number.

Example:

   ``model = "fsl,MPC8349EMITX";``

.. _sect-standard-properties-phandle:

phandle
~~~~~~~

Property name: ``phandle``

Value type: ``<u32>``

Description:

   The *phandle* property specifies a numerical identifier for a node that
   is unique within the devicetree. The *phandle* property value is used
   by other nodes that need to refer to the node associated with the
   property.

Example:

   See the following devicetree excerpt:

   .. code-block:: dts

      pic@10000000 {
         phandle = <1>;
         interrupt-controller;
         reg = <0x10000000 0x100>;
      };

   A *phandle* value of 1 is defined. Another device node could reference
   the pic node with a phandle value of 1:

   .. code-block:: dts

      another-device-node {
        interrupt-parent = <1>;
      };

.. note:: Older versions of devicetrees may be encountered that contain a
   deprecated form of this property called ``linux,phandle``. For
   compatibility, a client program might want to support ``linux,phandle``
   if a ``phandle`` property is not present. The meaning and use of the two
   properties is identical.

.. note:: Most devicetrees in :abbr:`DTS (Device Tree Syntax)` (see Appendix A) will not
   contain explicit phandle properties. The DTC tool automatically inserts
   the ``phandle`` properties when the DTS is compiled into the binary DTB
   format.

status
~~~~~~

Property name: ``status``

Value type: ``<string>``

Description:

   The ``status`` property indicates the operational status of a device.  The
   lack of a ``status`` property should be treated as if the property existed
   with the value of ``"okay"``.
   Valid values are listed and defined in :numref:`table-prop-status-values`.

.. tabularcolumns:: | l J |
.. _table-prop-status-values:
.. table:: Values for status property

   ============== ==============================================================
   Value          Description
   ============== ==============================================================
   ``"okay"``     Indicates the device is operational.
   -------------- --------------------------------------------------------------
   ``"disabled"`` Indicates that the device is not presently operational, but it
                  might become operational in the future (for example, something
                  is not plugged in, or switched off).

                  Refer to the device binding for details on what disabled means
                  for a given device.
   -------------- --------------------------------------------------------------
   ``"reserved"`` Indicates that the device is operational, but should not be
                  used. Typically this is used for devices that are controlled
                  by another software component, such as platform firmware.
   -------------- --------------------------------------------------------------
   ``"fail"``     Indicates that the device is not operational. A serious error
                  was detected in the device, and it is unlikely to become
                  operational without repair.
   -------------- --------------------------------------------------------------
   ``"fail-sss"`` Indicates that the device is not operational. A serious error
                  was detected in the device and it is unlikely to become
                  operational without repair. The *sss* portion of the value is
                  specific to the device and indicates the error condition
                  detected.
   ============== ==============================================================

#address-cells and #size-cells
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Property name: ``#address-cells``, ``#size-cells``

Value type: ``<u32>``

Description:

   The *#address-cells* and *#size-cells* properties may be used in any
   device node that has children in the devicetree hierarchy and describes
   how child device nodes should be addressed. The *#address-cells*
   property defines the number of ``<u32>`` cells used to encode the address
   field in a child node's *reg* property. The *#size-cells* property
   defines the number of ``<u32>`` cells used to encode the size field in a
   child node’s *reg* property.

   The *#address-cells* and *#size-cells* properties are not inherited from
   ancestors in the devicetree. They shall be explicitly defined.

   A |spec|-compliant boot program shall supply *#address-cells* and
   *#size-cells* on all nodes that have children.

   If missing, a client program should assume a default value of 2 for
   *#address-cells*, and a value of 1 for *#size-cells*.

Example:

   See the following devicetree excerpt:

   .. code-block:: dts

      soc {
         #address-cells = <1>;
         #size-cells = <1>;

         serial@4600 {
            compatible = "ns16550";
            reg = <0x4600 0x100>;
            clock-frequency = <0>;
            interrupts = <0xA 0x8>;
            interrupt-parent = <&ipic>;
         };
      };

   In this example, the *#address-cells* and *#size-cells* properties of the ``soc`` node
   are both set to 1. This setting specifies that one cell is required to
   represent an address and one cell is required to represent the size of
   nodes that are children of this node.

   The serial device *reg* property necessarily follows this specification
   set in the parent (``soc``) node—the address is represented by a single cell
   (0x4600), and the size is represented by a single cell (0x100).

reg
~~~

Property name: ``reg``

Property value: ``<prop-encoded-array>`` encoded as an arbitrary number of (*address*, *length*) pairs.

Description:

   The *reg* property describes the address of the device’s resources
   within the address space defined by its parent bus. Most commonly this
   means the offsets and lengths of memory-mapped IO register blocks, but
   may have a different meaning on some bus types. Addresses in the address
   space defined by the root node are CPU real addresses.

   The value is a *<prop-encoded-array>*, composed of an arbitrary number
   of pairs of address and length, *<address length>*. The number of
   *<u32>* cells required to specify the address and length are
   bus-specific and are specified by the *#address-cells* and *#size-cells*
   properties in the parent of the device node. If the parent node
   specifies a value of 0 for *#size-cells*, the length field in the value
   of *reg* shall be omitted.

Example:

   Suppose a device within a system-on-a-chip had two blocks of registers, a
   32-byte block at offset 0x3000 in the SOC and a 256-byte block at offset
   0xFE00. The *reg* property would be encoded as follows (assuming
   *#address-cells* and *#size-cells* values of 1):

      ``reg = <0x3000 0x20 0xFE00 0x100>;``

.. _sect-standard-properties-virtual-reg:

virtual-reg
~~~~~~~~~~~

Property name: ``virtual-reg``

Value type: ``<u32>``

Description:

   The *virtual-reg* property specifies an effective address that maps to
   the first physical address specified in the *reg* property of the device
   node. This property enables boot programs to provide client programs
   with virtual-to-physical mappings that have been set up.

.. _sect-standard-properties-ranges:

ranges
~~~~~~

Property name: ``ranges``

Value type: ``<empty>`` or ``<prop-encoded-array>`` encoded as an arbitrary number of
(*child-bus-address*, *parent-bus-address*, *length*) triplets.

Description:

   The *ranges* property provides a means of defining a mapping or
   translation between the address space of the bus (the child address
   space) and the address space of the bus node’s parent (the parent
   address space).

   The format of the value of the *ranges* property is an arbitrary number
   of triplets of (*child-bus-address*, *parent-bus-address*, *length*)

   * The *child-bus-address* is a physical address within the child bus'
     address space. The number of cells to represent the address is bus
     dependent and can be determined from the *#address-cells* of this node
     (the node in which the *ranges* property appears).
   * The *parent-bus-address* is a physical address within the parent bus'
     address space. The number of cells to represent the parent address is
     bus dependent and can be determined from the *#address-cells* property
     of the node that defines the parent’s address space.
   * The *length* specifies the size of the range in the child’s address space. The number
     of cells to represent the size can be determined from the *#size-cells*
     of this node (the node in which the *ranges* property appears).

   If the property is defined with an ``<empty>`` value, it specifies that the
   parent and child address space is identical, and no address translation
   is required.

   If the property is not present in a bus node, it is assumed that no
   mapping exists between children of the node and the parent address
   space.

Address Translation Example:

   .. code-block:: dts

       soc {
          compatible = "simple-bus";
          #address-cells = <1>;
          #size-cells = <1>;
          ranges = <0x0 0xe0000000 0x00100000>;

          serial@4600 {
             device_type = "serial";
             compatible = "ns16550";
             reg = <0x4600 0x100>;
             clock-frequency = <0>;
             interrupts = <0xA 0x8>;
             interrupt-parent = <&ipic>;
          };
       };

   The ``soc`` node specifies a *ranges* property of

      ``<0x0 0xe0000000 0x00100000>;``

   This property value specifies that for a 1024 KB range of address space,
   a child node addressed at physical 0x0 maps to a parent address of
   physical 0xe0000000. With this mapping, the ``serial`` device node can
   be addressed by a load or store at address 0xe0004600, an offset of
   0x4600 (specified in *reg*) plus the 0xe0000000 mapping specified in
   *ranges*.

dma-ranges
~~~~~~~~~~

Property name: ``dma-ranges``

Value type: ``<empty>`` or ``<prop-encoded-array>`` encoded as an arbitrary number of
(*child-bus-address*, *parent-bus-address*, *length*) triplets.

Description:

   The *dma-ranges* property is used to describe the direct memory access
   (DMA) structure of a memory-mapped bus whose devicetree parent can be
   accessed from DMA operations originating from the bus. It provides a
   means of defining a mapping or translation between the physical address
   space of the bus and the physical address space of the parent of the
   bus.

   The format of the value of the *dma-ranges* property is an arbitrary
   number of triplets of (*child-bus-address*, *parent-bus-address*,
   *length*). Each triplet specified describes a contiguous DMA address
   range.

   * The *child-bus-address* is a physical address within the child bus'
     address space. The number of cells to represent the address depends
     on the bus and can be determined from the *#address-cells* of this
     node (the node in which the *dma-ranges* property appears).
   * The *parent-bus-address* is a physical address within the parent bus'
     address space. The number of cells to represent the parent address is
     bus dependent and can be determined from the *#address-cells*
     property of the node that defines the parent’s address space.
   * The *length* specifies the size of the range in the child’s address
     space. The number of cells to represent the size can be determined
     from the *#size-cells* of this node (the node in which the dma-ranges
     property appears).

dma-coherent
~~~~~~~~~~~~

Property name: ``dma-coherent``

Value type: ``<empty>``

Description:
   For architectures which are by default non-coherent for I/O, the
   *dma-coherent* property is used to indicate a device is capable of
   coherent DMA operations. Some architectures have coherent DMA by default
   and this property is not applicable.

name (deprecated)
~~~~~~~~~~~~~~~~~

Property name: ``name``

Value type: ``<string>``

Description:

   The *name* property is a string specifying the name of the node. This
   property is deprecated, and its use is not recommended. However, it
   might be used in older non-|spec|-compliant devicetrees. Operating
   system should determine a node’s name based on the *node-name* component of
   the node name (see :numref:`sect-node-names`).

device_type (deprecated)
~~~~~~~~~~~~~~~~~~~~~~~~

Property name: ``device_type``

Value type: ``<string>``

Description:

   The *device\_type* property was used in IEEE 1275 to describe the
   device’s FCode programming model. Because |spec| does not have FCode, new
   use of the property is deprecated, and it should be included only on ``cpu``
   and ``memory`` nodes for compatibility with IEEE 1275–derived devicetrees.

.. _sect-interrupts:

Interrupts and Interrupt Mapping
--------------------------------

|spec| adopts the interrupt tree model of representing interrupts
specified in *Open Firmware Recommended Practice: Interrupt Mapping,
Version 0.9* [b7]_. Within the devicetree a logical interrupt tree exists
that represents the hierarchy and routing of interrupts in the platform
hardware. While generically referred to as an interrupt tree it is more
technically a directed acyclic graph.

The physical wiring of an interrupt source to an interrupt controller is
represented in the devicetree with the *interrupt-parent* property.
Nodes that represent interrupt-generating devices contain an
*interrupt-parent* property which has a *phandle* value that points to
the device to which the device’s interrupts are routed, typically an
interrupt controller. If an interrupt-generating device does not have an
*interrupt-parent* property, its interrupt parent is assumed to be its
devicetree parent.

Each interrupt generating device contains an *interrupts* property with
a value describing one or more interrupt sources for that device. Each
source is represented with information called an *interrupt specifier*.
The format and meaning of an *interrupt specifier* is interrupt domain
specific, i.e., it is dependent on properties on the node at the root of
its interrupt domain. The *#interrupt-cells* property is used by the
root of an interrupt domain to define the number of ``<u32>`` values
needed to encode an interrupt specifier. For example, for an Open PIC
interrupt controller, an interrupt-specifer takes two 32-bit values and
consists of an interrupt number and level/sense information for the
interrupt.

An interrupt domain is the context in which an interrupt specifier is
interpreted. The root of the domain is either (1) an interrupt
controller or (2) an interrupt nexus.

#. An *interrupt controller* is a physical device and will need a driver
   to handle interrupts routed through it. It may also cascade into
   another interrupt domain. An interrupt controller is specified by the
   presence of an *interrupt-controller* property on that node in the
   devicetree.

#. An *interrupt nexus* defines a translation between one interrupt
   domain and another. The translation is based on both domain-specific
   and bus-specific information. This translation between domains is
   performed with the *interrupt-map* property. For example, a PCI
   controller device node could be an interrupt nexus that defines a
   translation from the PCI interrupt namespace (INTA, INTB, etc.) to an
   interrupt controller with Interrupt Request (IRQ) numbers.

The root of the interrupt tree is determined when traversal of the
interrupt tree reaches an interrupt controller node without an
*interrupts* property and thus no explicit interrupt parent.

See :numref:`example-interrupt-tree` for an example of a graphical
representation of a devicetree with interrupt parent relationships shown. It
shows both the natural structure of the devicetree as well as where each node
sits in the logical interrupt tree.

.. _example-interrupt-tree:
.. digraph:: tree
   :caption: Example of the interrupt tree

   rankdir = LR
   ranksep = "1.5"
   size = "6,8"
   edge [ dir="none" ]
   node [ shape="Mrecord" width="2.5" ]

   subgraph cluster_devices {
      label = "Devicetree"
      graph [ style = dotted ]
      "soc" [ ]
      "device1" [ label = "device1 | interrupt-parent=\<&open-pic\>" ]
      "device2" [ label = "device2 | interrupt-parent=\<&gpioctrl\>" ]
      "pci-host" [ label = "pci-host | interrupt-parent=\<&open-pic\>" ]
      "slot0" [ label = "slot0 | interrupt-parent=\<&pci-host\>" ]
      "slot1" [ label = "slot1 | interrupt-parent=\<&pci-host\>" ]
      "simple-bus" [ label = "simple-bus" ]
      "gpioctrl" [ label = "gpioctrl | interrupt-parent=\<&open-pic\>" ]
      "device3" [ label = "device3 | interrupt-parent=\<&gpioctrl\>" ]

      edge [dir=back color=blue]
      "soc":e -> "device1":w
      "soc":e -> "device2":w
      "soc":e -> "open-pic":w
      "soc":e -> "pci-host":w
      "soc":e -> "simple-bus":w
      "pci-host":e -> "slot0":w
      "pci-host":e -> "slot1":w
      "simple-bus":e -> "gpioctrl":w
      "simple-bus":e -> "device3":w
   }

   subgraph cluster_interrupts {
      label = "Interrupt tree"
      graph [ style = dotted ]

      "i-open-pic" [ label = "open-pic | Root of Interrupt tree" ]
      "i-pci-host" [ label = "pci-host | Nexus Node" ]
      "i-gpioctrl" [ label = "gpioctrl | Nexus Node" ]
      "i-device1" [ label = "device1" ]
      "i-device2" [ label = "device2" ]
      "i-device3" [ label = "device3" ]
      "i-slot0" [ label = "slot0" ]
      "i-slot1" [ label = "slot1" ]

      edge [dir=back color=green]
      "i-open-pic":e -> "i-device1":w
      "i-open-pic":e -> "i-pci-host":w
      "i-open-pic":e -> "i-gpioctrl":w
      "i-pci-host":e -> "i-slot0":w
      "i-pci-host":e -> "i-slot1":w
      "i-gpioctrl":e -> "i-device2":w
      "i-gpioctrl":e -> "i-device3":w
   }

   subgraph {
      edge [color=red, style=dotted, constraint=false]
      "open-pic" -> "i-open-pic"
      "gpioctrl":w -> "i-gpioctrl"
      "pci-host" -> "i-pci-host"
      "slot0":e -> "i-slot0":e
      "slot1":e -> "i-slot1":e
      "device2":e -> "i-device2":w
      "device3":e -> "i-device3":e
   }

In the example shown in :numref:`example-interrupt-tree`:

* The ``open-pic`` interrupt controller is the root of the interrupt tree.
* The interrupt tree root has three children—devices that route their
  interrupts directly to the ``open-pic``

  * device1
  * PCI host controller
  * GPIO Controller

* Three interrupt domains exist; one rooted at the ``open-pic`` node,
  one at the ``PCI host bridge`` node, and one at the
  ``GPIO Controller`` node.
* There are two nexus nodes; one at the ``PCI host bridge`` and one at
  the ``GPIO controller``.

Properties for Interrupt Generating Devices
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

interrupts
^^^^^^^^^^

Property: ``interrupts``

Value type: ``<prop-encoded-array>`` encoded as arbitrary number of
interrupt specifiers

Description:

   The *interrupts* property of a device node defines the interrupt or
   interrupts that are generated by the device. The value of the
   *interrupts* property consists of an arbitrary number of interrupt
   specifiers. The format of an interrupt specifier is defined by the
   binding of the interrupt domain root.

   *interrupts* is overridden by the *interrupts-extended*
   property and normally only one or the other should be used.

Example:

   A common definition of an interrupt specifier in an open PIC–compatible
   interrupt domain consists of two cells; an interrupt number and
   level/sense information. See the following example, which defines a
   single interrupt specifier, with an interrupt number of 0xA and
   level/sense encoding of 8.

      ``interrupts = <0xA 8>;``

interrupt-parent
^^^^^^^^^^^^^^^^

Property: ``interrupt-parent``

Value type: ``<phandle>``

Description:

   Because the hierarchy of the nodes in the interrupt tree might not match
   the devicetree, the *interrupt-parent* property is available to make
   the definition of an interrupt parent explicit. The value is the phandle
   to the interrupt parent. If this property is missing from a device, its
   interrupt parent is assumed to be its devicetree parent.

interrupts-extended
^^^^^^^^^^^^^^^^^^^

Property: ``interrupts-extended``

Value type: ``<phandle> <prop-encoded-array>``

Description:

   The *interrupts-extended* property lists the interrupt(s) generated by a
   device.
   *interrupts-extended* should be used instead of *interrupts* when a device
   is connected to multiple interrupt controllers as it encodes a parent phandle
   with each interrupt specifier.

Example:

   This example shows how a device with two interrupt outputs connected to two
   separate interrupt controllers would describe the connection using an
   *interrupts-extended* property.
   ``pic`` is an interrupt controller with an *#interrupt-cells* specifier
   of 2, while ``gic`` is an interrupt controller with an *#interrupts-cells*
   specifier of 1.

      ``interrupts-extended = <&pic 0xA 8>, <&gic 0xda>;``


The *interrupts* and *interrupts-extended* properties are mutually exclusive.
A device node should use one or the other, but not both.
Using both is only permissible when required for compatibility with software
that does not understand *interrupts-extended*.
If both *interrupts-extended* and *interrupts* are present then
*interrupts-extended* takes precedence.

Properties for Interrupt Controllers
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#interrupt-cells
^^^^^^^^^^^^^^^^

Property: ``#interrupt-cells``

Value type: ``<u32>``

Description:

   The *#interrupt-cells* property defines the number of cells required to
   encode an interrupt specifier for an interrupt domain.

interrupt-controller
^^^^^^^^^^^^^^^^^^^^

Property: ``interrupt-controller``

Value type: ``<empty>``

Description:

   The presence of an *interrupt-controller* property defines a node as an
   interrupt controller node.

Interrupt Nexus Properties
~~~~~~~~~~~~~~~~~~~~~~~~~~

An interrupt nexus node shall have an *#interrupt-cells* property.

interrupt-map
^^^^^^^^^^^^^

Property: ``interrupt-map``

Value type: ``<prop-encoded-array>`` encoded as an arbitrary number of
interrupt mapping entries.

Description:

   An *interrupt-map* is a property on a nexus node that bridges one
   interrupt domain with a set of parent interrupt domains and specifies
   how interrupt specifiers in the child domain are mapped to their
   respective parent domains.

   The interrupt map is a table where each row is a mapping entry
   consisting of five components: *child unit address*, *child interrupt
   specifier*, *interrupt-parent*, *parent unit address*, *parent interrupt
   specifier*.

   child unit address
       The unit address of the child node being mapped. The number of
       32-bit cells required to specify this is described by the
       *#address-cells* property of the bus node on which the child is
       located.

   child interrupt specifier
       The interrupt specifier of the child node being mapped. The number
       of 32-bit cells required to specify this component is described by
       the *#interrupt-cells* property of this node—the nexus node
       containing the *interrupt-map* property.

   interrupt-parent
       A single *<phandle>* value that points to the interrupt parent to
       which the child domain is being mapped.

   parent unit address
       The unit address in the domain of the interrupt parent. The number
       of 32-bit cells required to specify this address is described by the
       *#address-cells* property of the node pointed to by the
       interrupt-parent field.

   parent interrupt specifier
       The interrupt specifier in the parent domain. The number of 32-bit
       cells required to specify this component is described by the
       *#interrupt-cells* property of the node pointed to by the
       interrupt-parent field.

   Lookups are performed on the interrupt mapping table by matching a
   unit-address/interrupt specifier pair against the child components in
   the interrupt-map. Because some fields in the unit interrupt specifier
   may not be relevant, a mask is applied before the lookup is done. This
   mask is defined in the *interrupt-map-mask* property
   (see :numref:`sect-interrupt-map-mask`).

   .. note:: Both the child node and the interrupt parent node are required to
      have *#address-cells* and *#interrupt-cells* properties defined. If a
      unit address component is not required, *#address-cells* shall be
      explicitly defined to be zero.

.. _sect-interrupt-map-mask:

interrupt-map-mask
^^^^^^^^^^^^^^^^^^

Property: ``interrupt-map-mask``

Value type: ``<prop-encoded-array>`` encoded as a bit mask

Description:

   An *interrupt-map-mask* property is specified for a nexus node in the
   interrupt tree. This property specifies a mask that is ANDed with the
   incoming unit interrupt specifier being looked up in the table specified
   in the *interrupt-map* property.

#interrupt-cells
^^^^^^^^^^^^^^^^

Property: ``#interrupt-cells``

Value type: ``<u32>``

Description:

   The *#interrupt-cells* property defines the number of cells required to
   encode an interrupt specifier for an interrupt domain.

Interrupt Mapping Example
~~~~~~~~~~~~~~~~~~~~~~~~~

The following shows the representation of a fragment of a devicetree with
a PCI bus controller and a sample interrupt map for describing the
interrupt routing for two PCI slots (IDSEL 0x11,0x12). The INTA, INTB,
INTC, and INTD pins for slots 1 and 2 are wired to the Open PIC
interrupt controller.

.. _example-interrupt-mapping:

.. code-block:: dts

   soc {
      compatible = "simple-bus";
      #address-cells = <1>;
      #size-cells = <1>;

      open-pic {
         clock-frequency = <0>;
         interrupt-controller;
         #address-cells = <0>;
         #interrupt-cells = <2>;
      };

      pci {
         #interrupt-cells = <1>;
         #size-cells = <2>;
         #address-cells = <3>;
         interrupt-map-mask = <0xf800 0 0 7>;
         interrupt-map = <
            /* IDSEL 0x11 - PCI slot 1 */
            0x8800 0 0 1 &open-pic 2 1 /* INTA */
            0x8800 0 0 2 &open-pic 3 1 /* INTB */
            0x8800 0 0 3 &open-pic 4 1 /* INTC */
            0x8800 0 0 4 &open-pic 1 1 /* INTD */
            /* IDSEL 0x12 - PCI slot 2 */
            0x9000 0 0 1 &open-pic 3 1 /* INTA */
            0x9000 0 0 2 &open-pic 4 1 /* INTB */
            0x9000 0 0 3 &open-pic 1 1 /* INTC */
            0x9000 0 0 4 &open-pic 2 1 /* INTD */
         >;
      };
   };

One Open PIC interrupt controller is represented and is identified as an
interrupt controller with an *interrupt-controller* property.

Each row in the interrupt-map table consists of five parts: a child unit
address and interrupt specifier, which is mapped to an *interrupt-parent*
node with a specified parent unit address and interrupt specifier.

* For example, the first row of the interrupt-map table specifies the
  mapping for INTA of slot 1. The components of that row are shown here

  | child unit address: ``0x8800 0 0``
  | child interrupt specifier: ``1``
  | interrupt parent: ``&open-pic``
  | parent unit address: (empty because ``#address-cells = <0>`` in the
    open-pic node)
  | parent interrupt specifier: ``2 1``

  * The child unit address is ``<0x8800 0 0>``. This value is encoded
    with three 32-bit cells, which is determined by the value of the
    *#address-cells* property (value of 3) of the PCI controller. The
    three cells represent the PCI address as described by the binding for
    the PCI bus.

    * The encoding includes the bus number (0x0 << 16), device number
      (0x11 << 11), and function number (0x0 << 8).

  * The child interrupt specifier is ``<1>``, which specifies INTA as
    described by the PCI binding. This takes one 32-bit cell as specified
    by the *#interrupt-cells* property (value of 1) of the PCI
    controller, which is the child interrupt domain.

  * The interrupt parent is specified by a phandle which points to the
    interrupt parent of the slot, the Open PIC interrupt controller.

  * The parent has no unit address because the parent interrupt domain
    (the open-pic node) has an *#address-cells* value of ``<0>``.

  * The parent interrupt specifier is ``<2 1>``. The number of cells to
    represent the interrupt specifier (two cells) is determined by the
    *#interrupt-cells* property on the interrupt parent, the open-pic
    node.

    * The value ``<2 1>`` is a value specified by the device binding for
      the Open PIC interrupt controller
      (see :numref:`sect-bindings-simple-bus`).
      The value ``<2>`` specifies the
      physical interrupt source number on the interrupt controller to
      which INTA is wired. The value ``<1>`` specifies the level/sense
      encoding.

In this example, the interrupt-map-mask property has a value of ``<0xf800
0 0 7>``. This mask is applied to a child unit interrupt specifier before
performing a lookup in the *interrupt-map* table.

To perform a lookup of the open-pic interrupt source number for INTB for
IDSEL 0x12 (slot 2), function 0x3, the following steps would be
performed:

*  The child unit address and interrupt specifier form the value
   ``<0x9300 0 0 2>``.

   *  The encoding of the address includes the bus number (0x0 << 16),
      device number (0x12 << 11), and function number (0x3 << 8).

   *  The interrupt specifier is 2, which is the encoding for INTB as
      per the PCI binding.

*  The interrupt-map-mask value ``<0xf800 0 0 7>`` is applied, giving a
   result of ``<0x9000 0 0 2>``.

*  That result is looked up in the *interrupt-map* table, which maps to
   the parent interrupt specifier ``<4 1>``.

.. _sect-nexus:

Nexus Nodes and Specifier Mapping
---------------------------------

Nexus Node Properties
~~~~~~~~~~~~~~~~~~~~~

A nexus node shall have a *#<specifier>-cells* property, where <specifier> is
some specifier space such as 'gpio', 'clock', 'reset', etc.

<specifier>-map
^^^^^^^^^^^^^^^

Property: ``<specifier>-map``

Value type: ``<prop-encoded-array>`` encoded as an arbitrary number of
specifier mapping entries.

Description:

   A *<specifier>-map* is a property in a nexus node that bridges one
   specifier domain with a set of parent specifier domains and describes
   how specifiers in the child domain are mapped to their respective parent
   domains.

   The map is a table where each row is a mapping entry
   consisting of three components: *child specifier*, *specifier parent*, and
   *parent specifier*.

   child specifier
       The specifier of the child node being mapped. The number
       of 32-bit cells required to specify this component is described by
       the *#<specifier>-cells* property of this node—the nexus node
       containing the *<specifier>-map* property.

   specifier parent
       A single *<phandle>* value that points to the specifier parent to
       which the child domain is being mapped.

   parent specifier
       The specifier in the parent domain. The number of 32-bit
       cells required to specify this component is described by the
       *#<specifier>-cells* property of the specifier parent node.

   Lookups are performed on the mapping table by matching a specifier against
   the child specifier in the map. Because some fields in the specifier may
   not be relevant or need to be modified, a mask is applied before the lookup
   is done. This mask is defined in the *<specifier>-map-mask* property
   (see :numref:`sect-specifier-map-mask`).

   Similarly, when the specifier is mapped, some fields in the unit specifier
   may need to be kept unmodified and passed through from the child node to the
   parent node. In this case, a *<specifier>-map-pass-thru* property
   (see :numref:`sect-specifier-map-pass-thru`) may be specified to apply
   a mask to the child specifier and copy any bits that match to the parent
   unit specifier.

.. _sect-specifier-map-mask:

<specifier>-map-mask
^^^^^^^^^^^^^^^^^^^^

Property: ``<specifier>-map-mask``

Value type: ``<prop-encoded-array>`` encoded as a bit mask

Description:

   A *<specifier>-map-mask* property may be specified for a nexus node.
   This property specifies a mask that is ANDed with the child unit
   specifier being looked up in the table specified in the *<specifier>-map*
   property. If this property is not specified, the mask is assumed to be
   a mask with all bits set.

.. _sect-specifier-map-pass-thru:

<specifier>-map-pass-thru
^^^^^^^^^^^^^^^^^^^^^^^^^

Property: ``<specifier>-map-pass-thru``

Value type: ``<prop-encoded-array>`` encoded as a bit mask

Description:

   A *<specifier>-map-pass-thru* property may be specified for a nexus node.
   This property specifies a mask that is applied to the child unit
   specifier being looked up in the table specified in the *<specifier>-map*
   property. Any matching bits in the child unit specifier are copied over
   to the parent specifier. If this property is not specified, the mask is
   assumed to be a mask with no bits set.

#<specifier>-cells
^^^^^^^^^^^^^^^^^^

Property: ``#<specifier>-cells``

Value type: ``<u32>``

Description:

   The *#<specifier>-cells* property defines the number of cells required to
   encode a specifier for a domain.

Specifier Mapping Example
~~~~~~~~~~~~~~~~~~~~~~~~~

The following shows the representation of a fragment of a devicetree with
two GPIO controllers and a sample specifier map for describing the
GPIO routing of a few gpios on both of the controllers through a connector
on a board to a device. The expansion device node is on one side of the
connector node and the SoC with the two GPIO controllers is on the other
side of the connector.

.. _example-specifier-mapping:

.. code-block:: dts

        soc {
                soc_gpio1: gpio-controller1 {
                        #gpio-cells = <2>;
                };

                soc_gpio2: gpio-controller2 {
                        #gpio-cells = <2>;
                };
        };

        connector: connector {
                #gpio-cells = <2>;
                gpio-map = <0 0 &soc_gpio1 1 0>,
                           <1 0 &soc_gpio2 4 0>,
                           <2 0 &soc_gpio1 3 0>,
                           <3 0 &soc_gpio2 2 0>;
                gpio-map-mask = <0xf 0x0>;
                gpio-map-pass-thru = <0x0 0x1>;
        };

        expansion_device {
                reset-gpios = <&connector 2 GPIO_ACTIVE_LOW>;
        };


Each row in the gpio-map table consists of three parts: a child unit
specifier, which is mapped to a *gpio-controller*
node with a parent specifier.

* For example, the first row of the specifier-map table specifies the
  mapping for GPIO 0 of the connector. The components of that row are shown
  here

  | child specifier: ``0 0``
  | specifier parent: ``&soc_gpio1``
  | parent specifier: ``1 0``

  * The child specifier is ``<0 0>``, which specifies GPIO 0 in the connector
    with a *flags* field of ``0``. This takes two 32-bit cells as specified
    by the *#gpio-cells* property of the connector node, which is the
    child specifier domain.

  * The specifier parent is specified by a phandle which points to the
    specifier parent of the connector, the first GPIO controller in the SoC.

  * The parent specifier is ``<1 0>``. The number of cells to
    represent the gpio specifier (two cells) is determined by the
    *#gpio-cells* property on the specifier parent, the soc_gpio1
    node.

    * The value ``<1 0>`` is a value specified by the device binding for
      the GPIO controller. The value ``<1>`` specifies the
      GPIO pin number on the GPIO controller to which GPIO 0 on the connector
      is wired. The value ``<0>`` specifies the flags (active low,
      active high, etc.).

In this example, the *gpio-map-mask* property has a value of ``<0xf 0>``.
This mask is applied to a child unit specifier before performing a lookup in
the *gpio-map* table. Similarly, the *gpio-map-pass-thru* property has a value
of ``<0x0 0x1>``. This mask is applied to a child unit specifier when mapping
it to the parent unit specifier. Any bits set in this mask are cleared out of
the parent unit specifier and copied over from the child unit specifier
to the parent unit specifier.

To perform a lookup of the connector's specifier source number for GPIO 2
from the expansion device's reset-gpios property, the following steps would be
performed:

*  The child specifier forms the value ``<2 GPIO_ACTIVE_LOW>``.

   *  The specifier is encoding GPIO 2 with active low flags per the GPIO
      binding.

*  The *gpio-map-mask* value ``<0xf 0x0>`` is ANDed with the child specifier,
   giving a result of ``<0x2 0>``.

*  The result is looked up in the *gpio-map* table, which maps to
   the parent specifier ``<3 0>`` and &soc_gpio1 *phandle*.

*  The *gpio-map-pass-thru* value ``<0x0 0x1>`` is inverted and ANDed with the
   parent specifier found in the *gpio-map* table, resulting in ``<3 0>``.
   The child specifier is ANDed with the *gpio-map-pass-thru* mask, forming
   ``<0 GPIO_ACTIVE_LOW>`` which is then ORed with the cleared parent specifier
   ``<3 0>`` resulting in ``<3 GPIO_ACTIVE_LOW>``.

*  The specifier ``<3 GPIO_ACTIVE_LOW>`` is appended to the mapped *phandle*
   &soc_gpio1 resulting in ``<&soc_gpio1 3 GPIO_ACTIVE_LOW>``.
