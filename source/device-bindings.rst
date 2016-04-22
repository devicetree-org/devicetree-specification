Device Bindings
===============

This chapter contains requirements, known as bindings, for how specific
types and classes of devices are represented in the device tree. The
compatible property of a device node describes the specific binding (or
bindings) to which the node complies.

Bindings may be defined as extensions of other each. For example a new
bus type could be defined as an extension of the simple-bus binding. In
this case, the compatible property would contain several strings
identifying each binding—from the most specific to the most general (see
section 2.3.1, compatible).

Binding Guidelines
------------------

General Principles
~~~~~~~~~~~~~~~~~~

When creating a new device tree representation for a device, a binding
should be created that fully describes the required properties and value
of the device. This set of properties shall be sufficiently descriptive
to provide device drivers with needed attributes of the device.

Some recommended practices include:

1. Define a compatible string using the conventions described in section
   2.3.1.

2. Use the standard properties (defined in sections 2.3 and 2.4) as
   applicable for the new device. This usage typically includes the
   *reg* and interrupts properties at a minimum.

3. Use the conventions specified in section 6 (Device Bindings) if the
   new device fits into one the ePAPR defined device classes.

4. Use the miscellaneous property conventions specified in section
   6.1.2, if applicable.

5. If new properties are needed by the binding, the recommended format
   for property names is: “<company>,<property-name>”, where <company>
   is an OUI or short unique string like a stock ticker that identifies
   the creator of the binding.

   Example: ibm,ppc-interrupt-server#s

Miscellaneous Properties
~~~~~~~~~~~~~~~~~~~~~~~~

This section defines a list of helpful properties that might be
applicable to many types of devices and device classes. They are defined
here to facilitate standardization of names and usage.

clock-frequency
^^^^^^^^^^^^^^^

+------------+---------------------------------------------------------------+
| Property   | clock-frequency                                               |
+------------+---------------------------------------------------------------+
| Value type | <prop-encoded-array>                                          |
+------------+---------------------------------------------------------------+
| Descriptio | Specifies the frequency of a clock in Hz. The value is a      |
| n          | <prop-encoded-array> in one of two forms:                     |
|            |                                                               |
|            | 1. a 32-bit integer consisting of one <u32> specifying the    |
|            |    frequency                                                  |
|            |                                                               |
|            | 2. a 64-bit integer represented as a <u64> specifying the     |
|            |    frequency                                                  |
+------------+---------------------------------------------------------------+

reg-shift
^^^^^^^^^

+------------+---------------------------------------------------------------+
| Property   | reg-shift                                                     |
+------------+---------------------------------------------------------------+
| Value type | <u32>                                                         |
+------------+---------------------------------------------------------------+
| Descriptio | The *reg-shift* property provides a mechanism to represent    |
| n          | devices that are identical in most respects except for the    |
|            | number of bytes between registers. The *reg-shift* property   |
|            | specifies in bytes how far the discrete device registers are  |
|            | separated from each other. The individual register location   |
|            | is calculated by using following formula: “registers address” |
|            | << reg-shift. If unspecified, the default value is 0.         |
|            |                                                               |
|            | For example, in a system where 16540 UART registers are       |
|            | located at addresses 0x0, 0x4, 0x8, 0xC, 0x10, 0x14, 0x18,    |
|            | and 0x1C, a ``reg-shift =                                     |
|            | <2>`` property would be used to specify register locations.   |
+------------+---------------------------------------------------------------+

label
^^^^^

+------------+---------------------------------------------------------------+
| Property   | label                                                         |
+------------+---------------------------------------------------------------+
| Value type | <string>                                                      |
+------------+---------------------------------------------------------------+
| Descriptio | The label property defines a human readable string describing |
| n          | a device. The binding for a given device specifies the exact  |
|            | meaning of the property for that device.                      |
+------------+---------------------------------------------------------------+

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

clock-frequency
^^^^^^^^^^^^^^^

+------------+---------------------------------------------------------------+
| Property   | clock-frequency                                               |
+------------+---------------------------------------------------------------+
| Value type | <u32>                                                         |
+------------+---------------------------------------------------------------+
| Descriptio | Specifies the frequency in Hertz of the baud rate generator’s |
| n          | input clock.                                                  |
+------------+---------------------------------------------------------------+
| Example    | clock-frequency = <100000000>;                                |
+------------+---------------------------------------------------------------+

current-speed
^^^^^^^^^^^^^

+------------+---------------------------------------------------------------+
| Property   | current-speed                                                 |
+------------+---------------------------------------------------------------+
| Value type | <u32>                                                         |
+------------+---------------------------------------------------------------+
| Descriptio | Specifies the current speed of a serial device in bits per    |
| n          | second. A boot program should set this property if it has     |
|            | initialized the serial device.                                |
+------------+---------------------------------------------------------------+
| Example    | current-speed = <115200>; # 115200 baud                       |
+------------+---------------------------------------------------------------+

National Semiconductor 16450/16550 Compatible UART Requirements
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Serial devices compatible to the National Semiconductor 16450/16550 UART
(Universal Asynchronous Receiver Transmitter) should be represented in
the device tree using following properties.

+------------+---------+---------+------------------------------------------------+
| Property   | Usage   | Value   | Definition                                     |
| Name       |         | Type    |                                                |
+============+=========+=========+================================================+
| compatible | R       | <string | Value shall include “ns16550”.                 |
|            |         | list>   |                                                |
+------------+---------+---------+------------------------------------------------+
| clock-freq | R       | <u32>   | Specifies the frequency (in Hz) of the baud    |
| uency      |         |         | rate generator’s input clock                   |
+------------+---------+---------+------------------------------------------------+
| current-sp | OR      | <u32>   | Specifies current serial device speed in bits  |
| eed        |         |         | per second                                     |
+------------+---------+---------+------------------------------------------------+
| reg        | R       | <prop-e | Specifies the physical address of the          |
|            |         | ncoded- | registers device within the address space of   |
|            |         | array>  | the parent bus                                 |
+------------+---------+---------+------------------------------------------------+
| interrupts | OR      | <prop-e | Specifies the interrupts generated by this     |
|            |         | ncoded- | device. The value of the interrupts property   |
|            |         | array>  | consists of one or more interrupt specifiers.  |
|            |         |         | The format of an interrupt specifier is        |
|            |         |         | defined by the binding document describing the |
|            |         |         | node’s interrupt parent.                       |
+------------+---------+---------+------------------------------------------------+
| reg-shift  | O       | <u32>   | Specifies in bytes how far the discrete device |
|            |         |         | registers are separated from each other. The   |
|            |         |         | individual register location is calculated by  |
|            |         |         | using following formula: “registers address”   |
|            |         |         | << reg-shift. If unspecified, the default      |
|            |         |         | value is 0.                                    |
+------------+---------+---------+------------------------------------------------+
| virtual-re | SD      | <u32>   | See section 2.3.7. Specifies an effective      |
| g          |         | or      | address that maps to the first physical        |
|            |         | <u64>   | address specified in the *reg* property. This  |
|            |         |         | property is required if this device node is    |
|            |         |         | the system’s console.                          |
+------------+---------+---------+------------------------------------------------+

Table: Table 6-1 ns16550 properties

Usage legend: R=Required, O=Optional, OR=Optional but Recommended,
SD=See Definition

Note: All other standard properties (section 2.3) are allowed but are
optional.

Network devices
---------------

Network devices are packet oriented communication devices. Devices in
this class are assumed to implement the data link layer (layer 2) of the
seven-layer OSI model and use Media Access Control (MAC) addresses.
Examples of network devices include Ethernet, FDDI, 802.11, and
Token-Ring.

Network Class Binding
~~~~~~~~~~~~~~~~~~~~~

address-bits
^^^^^^^^^^^^

+------------+---------------------------------------------------------------+
| Property   | address-bits                                                  |
+------------+---------------------------------------------------------------+
| Value type | <u32>                                                         |
+------------+---------------------------------------------------------------+
| Descriptio | Specifies number of address bits required to address the      |
| n          | device described by this node. This property specifies number |
|            | of bits in MAC address. If unspecified, the default value is  |
|            | 48.                                                           |
+------------+---------------------------------------------------------------+
| Example    | address-bits = <48>;                                          |
+------------+---------------------------------------------------------------+

local-mac-address
^^^^^^^^^^^^^^^^^

+------------+---------------------------------------------------------------+
| Property   | local-mac-address                                             |
+------------+---------------------------------------------------------------+
| Value type | <prop-encoded-array> encoded as array of hex numbers          |
+------------+---------------------------------------------------------------+
| Descriptio | Specifies MAC address that was assigned to the network device |
| n          | described by the node containing this property.               |
+------------+---------------------------------------------------------------+
| Example    |                                                               |
+------------+---------------------------------------------------------------+

::

    local-mac-address = [ 00 00 12 34 56 78];

mac-address
^^^^^^^^^^^

+------------+---------------------------------------------------------------+
| Property   | mac-address                                                   |
+------------+---------------------------------------------------------------+
| Value type | <prop-encoded-array> encoded as array of hex numbers          |
+------------+---------------------------------------------------------------+
| Descriptio | Specifies the MAC address that was last used by the boot      |
| n          | program. This property should be used in cases where the MAC  |
|            | address assigned to the device by the boot program is         |
|            | different from the local-mac-address property. This property  |
|            | shall be used only if the value differs from                  |
|            | local-mac-address property value.                             |
+------------+---------------------------------------------------------------+
| Example    | mac-address = [ 0x01 0x02 0x03 0x04 0x05 0x06 ];              |
+------------+---------------------------------------------------------------+

max-frame-size
^^^^^^^^^^^^^^

+------------+---------------------------------------------------------------+
| Property   | max-frame-size                                                |
+------------+---------------------------------------------------------------+
| Value type | <u32>                                                         |
+------------+---------------------------------------------------------------+
| Descriptio | Specifies maximum packet length in bytes that the physical    |
| n          | interface can send and receive.                               |
+------------+---------------------------------------------------------------+
| Example    | max-frame-size = <1518>;                                      |
+------------+---------------------------------------------------------------+

Ethernet specific considerations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Network devices based on the IEEE 802.3 collections of LAN standards
(collectively referred to as Ethernet) may be represented in the device
tree using following properties, in addition to properties specified of
the network device class.

The properties listed in this section augment the properties listed in
the network device class.

max-speed
^^^^^^^^^

+------------+---------------------------------------------------------------+
| Property   | max-speed                                                     |
+------------+---------------------------------------------------------------+
| Value type | <u32>                                                         |
+------------+---------------------------------------------------------------+
| Descriptio | Specifies maximum speed (specified in megabits per second)    |
| n          | supported the device.                                         |
+------------+---------------------------------------------------------------+
| Example    | max-speed = \<1000>;                                          |
+------------+---------------------------------------------------------------+

phy-connection-type
^^^^^^^^^^^^^^^^^^^

+------------+---------------------------------------------------------------+
| Property   | phy-connection-type                                           |
+------------+---------------------------------------------------------------+
| Value type | <string>                                                      |
+------------+---------------------------------------------------------------+
| Descriptio | Specifies interface type between the Ethernet device and a    |
| n          | physical layer (PHY) device. The value of this property is    |
|            | specific to the implementation.                               |
|            |                                                               |
|            | Recommended values are shown in the following table.          |
|            |                                                               |
|            | +--------------------------------------+--------------------- |
|            | -----------------+                                            |
|            | | Connection type                      | Value                |
|            |                  |                                            |
|            | +======================================+===================== |
|            | =================+                                            |
|            | | Media Independent Interface          | mii                  |
|            |                  |                                            |
|            | +--------------------------------------+--------------------- |
|            | -----------------+                                            |
|            | | Reduced Media Independent Interface  | rmii                 |
|            |                  |                                            |
|            | +--------------------------------------+--------------------- |
|            | -----------------+                                            |
|            | | Gigabit Media Independent Interface  | rgmii                |
|            |                  |                                            |
|            | +--------------------------------------+--------------------- |
|            | -----------------+                                            |
|            | | Reduced Gigabit Media Independent    | rgmii                |
|            |                  |                                            |
|            | | Interface                            |                      |
|            |                  |                                            |
|            | +--------------------------------------+--------------------- |
|            | -----------------+                                            |
|            | | rgmii with internal delay            | rgmii-id             |
|            |                  |                                            |
|            | +--------------------------------------+--------------------- |
|            | -----------------+                                            |
|            | | rgmii with internal delay on TX only | rgmii-txid           |
|            |                  |                                            |
|            | +--------------------------------------+--------------------- |
|            | -----------------+                                            |
|            | | rgmii with internal delay on RX only | rgmii-rxid           |
|            |                  |                                            |
|            | +--------------------------------------+--------------------- |
|            | -----------------+                                            |
|            | | Ten Bit Interface                    | tbi                  |
|            |                  |                                            |
|            | +--------------------------------------+--------------------- |
|            | -----------------+                                            |
|            | | Reduced Ten Bit Interface            | rtbi                 |
|            |                  |                                            |
|            | +--------------------------------------+--------------------- |
|            | -----------------+                                            |
|            | | Serial Media Independent Interface   | smii                 |
|            |                  |                                            |
|            | +--------------------------------------+--------------------- |
|            | -----------------+                                            |
+------------+---------------------------------------------------------------+
| Example    |                                                               |
+------------+---------------------------------------------------------------+

::

    phy-connection-type = “mii”;

phy-handle
^^^^^^^^^^

+------------+---------------------------------------------------------------+
| Property   | phy-handle                                                    |
+------------+---------------------------------------------------------------+
| Value type | <phandle>                                                     |
+------------+---------------------------------------------------------------+
| Descriptio | Specifies a reference to a node representing a physical layer |
| n          | (PHY) device connected to this Ethernet device. This property |
|            | is required in case where the Ethernet device is connected a  |
|            | physical layer device.                                        |
+------------+---------------------------------------------------------------+
| Example    |                                                               |
+------------+---------------------------------------------------------------+

::

    phy-handle = <&PHY0>;

open PIC Interrupt Controllers
------------------------------

This section specifies the requirements for representing open PIC
compatible interrupt controllers. An open PIC interrupt controller
implements the open PIC architecture (developed jointly by AMD and
Cyrix) and specified in The Open Programmable Interrupt Controller (PIC)
Register Interface Specification Revision 1.2 ?.

Interrupt specifiers in an open PIC interrupt domain are encoded with
two cells. The first cell defines the interrupt number. The second cell
defines the sense and level information.

Sense and level information shall be encoded as follows in interrupt
specifiers:

    ::

        0 = low to high edge sensitive type enabled
        1 = active low level sensitive type enabled
        2 = active high level sensitive type enabled
        3 = high to low edge sensitive type enabled

+------------+---------+---------+------------------------------------------------+
| Property   | Usage   | Value   | Definition                                     |
| Name       |         | Type    |                                                |
+============+=========+=========+================================================+
| compatible | R       | <string | Value shall include “open-pic”.                |
|            |         | >       |                                                |
+------------+---------+---------+------------------------------------------------+
| reg        | R       | <prop-e | Specifies the physical address of the          |
|            |         | ncoded- | registers device within the address space of   |
|            |         | array>  | the parent bus                                 |
+------------+---------+---------+------------------------------------------------+
| interrupt- | R       | <empty> | Specifies that this node is an interrupt       |
| controller |         |         | controller                                     |
+------------+---------+---------+------------------------------------------------+
| #interrupt | R       | <u32>   | Shall be 2.                                    |
| -cells     |         |         |                                                |
+------------+---------+---------+------------------------------------------------+
| #address-c | R       | <u32>   | Shall be 0.                                    |
| ells       |         |         |                                                |
+------------+---------+---------+------------------------------------------------+

Table: Table 6-2 Open-pic properties

Usage legend: R=Required, O=Optional, OR=Optional but Recommended,
SD=See Definition

Note: All other standard properties (section 2.3) are allowed but are
optional.

simple-bus
----------

System-on-a-chip processors may have an internal I/O bus that cannot be
probed for devices. The devices on the bus can be accessed directly
without additional configuration required. This type of bus is
represented as a node with a compatible value of “simple-bus”.

+------------+---------+---------+------------------------------------------------+
| Property   | Usage   | Value   | Definition                                     |
| Name       |         | Type    |                                                |
+============+=========+=========+================================================+
| compatible | R       | <string | Value shall include "simple-bus".              |
|            |         | >       |                                                |
+------------+---------+---------+------------------------------------------------+
| ranges     | R       | <prop-e | This property represents the mapping between   |
|            |         | ncoded- | parent address to child address spaces (see    |
|            |         | array>  | section 2.3.8, ranges).                        |
+------------+---------+---------+------------------------------------------------+

Table: Table 6-3 Simple-bus properties

Usage legend: R=Required, O=Optional, OR=Optional but Recommended,
SD=See Definition

Note: All other standard properties (section 2.3) are allowed but are
optional.


