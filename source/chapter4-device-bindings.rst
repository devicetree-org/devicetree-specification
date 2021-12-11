.. SPDX-License-Identifier: Apache-2.0

.. _chapter-device-bindings:

Device Bindings
===============

This chapter contains requirements, known as bindings, for how specific
types and classes of devices are represented in the devicetree. The
compatible property of a device node describes the specific binding (or
bindings) to which the node complies.

Bindings may be defined as extensions of other each. For example a new
bus type could be defined as an extension of the simple-bus binding. In
this case, the compatible property would contain several strings
identifying each binding—from the most specific to the most general (see
:numref:`sect-standard-properties-compatible`, compatible).

Binding Guidelines
------------------

General Principles
~~~~~~~~~~~~~~~~~~

When creating a new devicetree representation for a device, a binding
should be created that fully describes the required properties and value
of the device. This set of properties shall be sufficiently descriptive
to provide device drivers with needed attributes of the device.

Some recommended practices include:

1. Define a compatible string using the conventions described in
   :numref:`sect-standard-properties-compatible`.

2. Use the standard properties (defined in
   :numref:`sect-standard-properties` and
   :numref:`sect-interrupts`) as
   applicable for the new device. This usage typically includes the
   ``reg`` and ``interrupts`` properties at a minimum.

3. Use the conventions specified in :numref:`chapter-device-bindings`
   (Device Bindings) if the new device fits into one the |spec| defined
   device classes.

4. Use the miscellaneous property conventions specified in
   :numref:`sect-misc-properties`, if applicable.

5. If new properties are needed by the binding, the recommended format
   for property names is: ``"<company>,<property-name>"``, where ``<company>``
   is an OUI or short unique string like a stock ticker that identifies
   the creator of the binding.

   Example: ``"ibm,ppc-interrupt-server#s"``

.. _sect-misc-properties:

Miscellaneous Properties
~~~~~~~~~~~~~~~~~~~~~~~~

This section defines a list of helpful properties that might be
applicable to many types of devices and device classes. They are defined
here to facilitate standardization of names and usage.

``clock-frequency`` Property
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: | l J |
.. table:: ``clock-frequency`` Property

   =========== ==============================================================
   Property    ``clock-frequency``
   =========== ==============================================================
   Value type  ``<prop-encoded-array>``
   Description Specifies the frequency of a clock in Hz. The value is a
               ``<prop-encoded-array>`` in one of two forms:

               a 32-bit integer consisting of one ``<u32>`` specifying the
               frequency

               a 64-bit integer represented as a ``<u64>`` specifying the
               frequency
   =========== ==============================================================

``reg-shift`` Property
^^^^^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: | l J |
.. table:: ``reg-shift`` Property

   =========== ==============================================================
   Property    ``reg-shift``
   =========== ==============================================================
   Value type  ``<u32>``
   Description The ``reg-shift`` property provides a mechanism to represent
               devices that are identical in most respects except for the
               number of bytes between registers. The ``reg-shift`` property
               specifies in bytes how far the discrete device registers are
               separated from each other. The individual register location
               is calculated by using following formula: "registers address"
               << reg-shift. If unspecified, the default value is 0.

               For example, in a system where 16540 UART registers are
               located at addresses 0x0, 0x4, 0x8, 0xC, 0x10, 0x14, 0x18,
               and 0x1C, a ``reg-shift = <2>``
               property would be used to specify register locations.
   =========== ==============================================================

``label`` Property
^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: | l J |
.. table:: ``label`` Property

   =========== ==============================================================
   Property    ``label``
   =========== ==============================================================
   Value type  ``<string>``
   Description The label property defines a human readable string describing
               a device. The binding for a given device specifies the exact
               meaning of the property for that device.
   =========== ==============================================================

Serial devices
--------------

Serial Class Binding
~~~~~~~~~~~~~~~~~~~~

The class of serial devices consists of various types of point to point
serial line devices. Examples of serial line devices include the 8250
UART, 16550 UART, HDLC device, and BISYNC device. In most cases hardware
compatible with the RS-232 standard fit into the serial device class.

I\ :sup:`2`\ C and SPI (Serial Peripheral Interface) devices shall not
be represented as serial port devices because they have their own
specific representation.

``clock-frequency`` Property
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: | l J |
.. table:: ``clock-frequecy`` Property

   =========== ==============================================================
   Property    ``clock-frequency``
   =========== ==============================================================
   Value type  ``<u32>``
   Description Specifies the frequency in Hertz of the baud rate generator's
               input clock.
   Example     ``clock-frequency = <100000000>;``
   =========== ==============================================================

``current-speed`` Property
^^^^^^^^^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: | l J |
.. table:: ``current-speed`` Property

   =========== ==============================================================
   Property    ``current-speed``
   =========== ==============================================================
   Value type  ``<u32>``
   Description Specifies the current speed of a serial device in bits per
               second. A boot program should set this property if it has
               initialized the serial device.
   Example     115,200 Baud: ``current-speed = <115200>;``
   =========== ==============================================================

National Semiconductor 16450/16550 Compatible UART Requirements
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Serial devices compatible to the National Semiconductor 16450/16550 UART
(Universal Asynchronous Receiver Transmitter) should be represented in
the devicetree using following properties.

.. tabularcolumns:: | p{4cm} p{0.75cm} p{4cm} p{6.5cm} |
.. table:: ns16550 UART Properties

   ======================= ===== ===================== ===============================================
   Property Name           Usage Value Type            Definition
   ======================= ===== ===================== ===============================================
   ``compatible``          R     <string list>         Value shall include "ns16550".
   ``clock-frequency``     R     ``<u32>``             Specifies the frequency (in Hz) of the baud
                                                       rate generator’s input clock
   ``current-speed``       OR    ``<u32>``             Specifies current serial device speed in bits
                                                       per second
   ``reg``                 R     ``<prop encoded       Specifies the physical address of the
                                 array>``              registers device within the address space of
                                                       the parent bus
   ``interrupts``          OR    ``<prop encoded       Specifies the interrupts generated by this
                                 array>``              device. The value of the interrupts property
                                                       consists of one or more interrupt specifiers.
                                                       The format of an interrupt specifier is
                                                       defined by the binding document describing the
                                                       node’s interrupt parent.
   ``reg-shift``           O     ``<u32>``             Specifies in bytes how far the discrete device
                                                       registers are separated from each other. The
                                                       individual register location is calculated by
                                                       using following formula: ``"registers address"
                                                       << reg-shift``. If unspecified, the default
                                                       value is 0.
   ``virtual-reg``         SD    ``<u32>``             See :numref:`sect-standard-properties-virtual-reg`.
                                 or                    Specifies an effective address that maps to the
                                 ``<u64>``             first physical address specified in the ``reg``
                                                       property. This property is required if this
                                                       device node is the system’s console.
   Usage legend: R=Required, O=Optional, OR=Optional but Recommended, SD=See Definition
   ===================================================================================================

.. note:: All other standard properties
   (:numref:`sect-standard-properties`) are allowed but are optional.


Network devices
---------------

Network devices are packet oriented communication devices. Devices in
this class are assumed to implement the data link layer (layer 2) of the
seven-layer OSI model and use Media Access Control (MAC) addresses.
Examples of network devices include Ethernet, FDDI, 802.11, and
Token-Ring.

Network Class Binding
~~~~~~~~~~~~~~~~~~~~~

``address-bits`` Property
^^^^^^^^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: | l J |
.. table:: ``address-bits`` Property

   =========== ==============================================================
   Property    ``address-bits``
   =========== ==============================================================
   Value type  ``<u32>``
   Description Specifies number of address bits required to address the
               device described by this node. This property specifies number
               of bits in MAC address. If unspecified, the default value is 48.
   Example     ``address-bits = <48>;``
   =========== ==============================================================

``local-mac-address`` Property
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: | l J |
.. table:: ``local-mac-address`` Property

   =========== ==============================================================
   Property    ``local-mac-address``
   =========== ==============================================================
   Value type  ``<prop-encoded-array>`` encoded as an array of hex numbers
   Description Specifies MAC address that was assigned to the network device
               described by the node containing this property.
   Example     ``local-mac-address = [ 00 00 12 34 56 78 ];``
   =========== ==============================================================

``mac-address`` Property
^^^^^^^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: | l J |
.. table:: ``mac-address`` Property

   =========== ==============================================================
   Property    ``mac-address``
   =========== ==============================================================
   Value type  ``<prop-encoded-array>`` encoded as an array of hex numbers
   Description Specifies the MAC address that was last used by the boot
               program. This property should be used in cases where the MAC
               address assigned to the device by the boot program is
               different from the local-mac-address property. This property
               shall be used only if the value differs from
               local-mac-address property value.
   Example     ``mac-address = [ 02 03 04 05 06 07 ];``
   =========== ==============================================================

``max-frame-size`` Property
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: | l J |
.. table:: ``max-frame-size`` Property

   =========== ==============================================================
   Property    ``max-frame-size``
   =========== ==============================================================
   Value type  ``<u32>``
   Description Specifies maximum packet length in bytes that the physical
               interface can send and receive.
   Example     ``max-frame-size = <1518>;``
   =========== ==============================================================

Ethernet specific considerations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Network devices based on the IEEE 802.3 collections of LAN standards
(collectively referred to as Ethernet) may be represented in the devicetree
using following properties, in addition to properties specified of
the network device class.

The properties listed in this section augment the properties listed in
the network device class.

``max-speed`` Property
^^^^^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: | l J |
.. table:: ``max-speed`` Property

   =========== ==============================================================
   Property    ``max-speed``
   =========== ==============================================================
   Value type  ``<u32>``
   Description Specifies maximum speed (specified in megabits per second)
               supported the device.
   Example     ``max-speed = <1000>;``
   =========== ==============================================================

``phy-connection-type`` Property
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: | l J |
.. table:: ``phy-connection-type`` Property

   =========== ==============================================================
   Property    ``phy-connection-type``
   =========== ==============================================================
   Value type  ``<string>``
   Description Specifies interface type between the Ethernet device and a
               physical layer (PHY) device. The value of this property is
               specific to the implementation.

               Recommended values are shown in the following table.
   Example     ``phy-connection-type = "mii";``
   =========== ==============================================================

.. tabularcolumns:: | l J |
.. table:: Defined values for the ``phy-connection-type`` Property

   ================================================= ============
   Connection type                                   Value
   ================================================= ============
   Media Independent Interface                       ``mii``
   Reduced Media Independent Interface               ``rmii``
   Gigabit Media Independent Interface               ``gmii``
   Reduced Gigabit Media Independent                 ``rgmii``
   rgmii with internal delay                         ``rgmii-id``
   rgmii with internal delay on TX only              ``rgmii-txid``
   rgmii with internal delay on RX only              ``rgmii-rxid``
   Ten Bit Interface                                 ``tbi``
   Reduced Ten Bit Interface                         ``rtbi``
   Serial Media Independent Interface                ``smii``
   Serial Gigabit Media Independent Interface        ``sgmii``
   Reverse Media Independent Interface               ``rev-mii``
   10 Gigabits Media Independent Interface           ``xgmii``
   Multimedia over Coaxial                           ``moca``
   Quad Serial Gigabit Media Independent Interface   ``qsgmii``
   Turbo Reduced Gigabit Media Independent Interface ``trgmii``
   ================================================= ============

``phy-handle`` Property
^^^^^^^^^^^^^^^^^^^^^^^

.. tabularcolumns:: | l J |
.. table:: ``phy-handle`` Property

   =========== ==============================================================
   Property    ``phy-handle``
   =========== ==============================================================
   Value type  ``<phandle>``
   Description Specifies a reference to a node representing a physical layer
               (PHY) device connected to this Ethernet device. This property
               is required in case where the Ethernet device is connected a
               physical layer device.
   Example     ``phy-handle = <&PHY0>;``
   =========== ==============================================================

Power ISA Open PIC Interrupt Controllers
----------------------------------------

This section specifies the requirements for representing Open PIC
compatible interrupt controllers. An Open PIC interrupt controller
implements the Open PIC architecture (developed jointly by AMD and
Cyrix) and specified in The Open Programmable Interrupt Controller (PIC)
Register Interface Specification Revision 1.2 [b18]_.

Interrupt specifiers in an Open PIC interrupt domain are encoded with
two cells. The first cell defines the interrupt number. The second cell
defines the sense and level information.

Sense and level information shall be encoded as follows in interrupt
specifiers:

    ::

        0 = low to high edge sensitive type enabled
        1 = active low level sensitive type enabled
        2 = active high level sensitive type enabled
        3 = high to low edge sensitive type enabled

.. tabularcolumns:: | p{4cm} p{0.75cm} p{4cm} p{6.5cm} |
.. table:: Open-PIC properties

   ======================== ===== ===================== ===============================================
   Property Name            Usage Value Type            Definition
   ======================== ===== ===================== ===============================================
   ``compatible``           R     ``<string>``          Value shall include ``"open-pic"``
   ``reg``                  R     ``<prop encoded       Specifies the physical address of the
                                  array>``              registers device within the address space of
                                                        the parent bus
   ``interrupt-controller`` R     ``<empty>``           Specifies that this node is an interrupt controller
   ``#interrupt-cells``     R     ``<u32>``             Shall be 2.
   ``#address-cells``       R     ``<u32>``             Shall be 0.
   Usage legend: R=Required, O=Optional, OR=Optional but Recommended, SD=See Definition
   ====================================================================================================

.. note:: All other standard properties
   (:numref:`sect-standard-properties`) are allowed but are optional.


.. _sect-bindings-simple-bus:

``simple-bus`` Compatible Value
-------------------------------

System-on-a-chip processors may have an internal I/O bus that cannot be
probed for devices. The devices on the bus can be accessed directly
without additional configuration required. This type of bus is
represented as a node with a compatible value of "simple-bus".

.. tabularcolumns:: | p{4cm} p{0.75cm} p{4cm} p{6.5cm} |
.. table:: ``simple-bus`` Compatible Node Properties

   ======================== ===== ===================== ===============================================
   Property Name            Usage Value Type            Definition
   ======================== ===== ===================== ===============================================
   ``compatible``           R     ``<string>``          Value shall include "simple-bus".
   ``ranges``               R     ``<prop encoded       This property represents the mapping between
                                  array>``              parent address to child address spaces (see
                                                        :numref:`sect-standard-properties-ranges`,
                                                        ranges).
   ``nonposted-mmio``       O     ``<empty>``           Specifies that direct children of this bus
                                                        should use non-posted memory accesses (i.e. a
                                                        non-posted mapping mode) for MMIO ranges.
   Usage legend: R=Required, O=Optional, OR=Optional but Recommended, SD=See Definition
   ====================================================================================================
