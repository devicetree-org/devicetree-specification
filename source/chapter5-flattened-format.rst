.. SPDX-License-Identifier: Apache-2.0

.. _chapter-fdt-structure:

Flattened Devicetree (DTB) Format
==================================

The Devicetree Blob (DTB) format is a flat binary encoding of devicetree data.
It used to exchange devicetree data between software programs.
For example, when booting an operating system, firmware will pass a DTB to the OS kernel.

.. note::

   IEEE1275 Open Firmware [IEEE1275] does not define the DTB format.
   On most Open Firmware compliant platforms the devicetree is extracted by calling firmware methods
   to walk through the tree structure.

The DTB format encodes the devicetree data within a single, linear, pointerless data structure.
It consists of a small header
(see :numref:`sect-fdt-header`),
followed by three variable sized sections:
the memory reservation block (see :numref:`sect-fdt-memory-reservation-block`),
the structure block (see :numref:`sect-fdt-structure-block`),
and the strings block (see :numref:`sect-fdt-strings-block`).
These should be present in the flattened devicetree in that order.
Thus, the devicetree structure as a whole, when loaded into memory at address,
will resemble the diagram in :numref:`figure_device_tree_structure`
(lower addresses are at the top of the diagram).

.. _figure_device_tree_structure:
.. digraph:: tree
   :caption: Devicetree .dtb Structure

   rankdir = LR
   ranksep = "1.5"
   size = "6,8"
   edge [ dir="none" ]
   node [ shape="Mrecord" width="2.5" ]

   "node" [ label = "struct fdt_header |
      (free space) |
      memory reservation block |
      (free space) |
      structure block |
      (free space) |
      strings block |
      (free space)" ]

The (free space) sections may not be present, though in some cases they
might be required to satisfy the alignment constraints of the individual
blocks (see :numref:`sect-fdt-alignment`).

.. _sect-fdt-versioning:

Versioning
----------

Several versions of the flattened devicetree structure have been defined since
the original definition of the format. Fields in the header give the version,
so that the client program can determine if the devicetree is encoded in a
compatible format.

This document describes only version 17 of the format. |spec| compliant boot
programs shall provide a devicetree of version 17 or later, and should provide
a devicetree of a version that is backwards compatible with version 16.
|spec| compliant client programs shall accept devicetrees of any version
backwards compatible with version 17 and may accept other versions as well.

.. note:: The version is with respect to the binary structure of the device
   tree, not its content.

.. _sect-fdt-header:

Header
------

The layout of the header for the devicetree is defined by the following
C structure. All the header fields are 32-bit integers, stored in
big-endian format.

**Flattened Devicetree Header Fields**

.. code-block:: c

        struct fdt_header {
            uint32_t magic;
            uint32_t totalsize;
            uint32_t off_dt_struct;
            uint32_t off_dt_strings;
            uint32_t off_mem_rsvmap;
            uint32_t version;
            uint32_t last_comp_version;
            uint32_t boot_cpuid_phys;
            uint32_t size_dt_strings;
            uint32_t size_dt_struct;
        };

``magic``
    This field shall contain the value 0xd00dfeed (big-endian).

``totalsize``
    This field shall contain the total size in bytes of the devicetree data structure.
    This size shall encompass all sections of the structure:
    the header, the memory reservation block, structure block and
    strings block, as well as any free space gaps between the blocks or
    after the final block.

``off_dt_struct``
    This field shall contain the offset in bytes of the structure block
    (see :numref:`sect-fdt-structure-block`) from the beginning of the header.

``off_dt_strings``
    This field shall contain the offset in bytes of the strings block
    (see :numref:`sect-fdt-strings-block`) from the beginning of the header.

``off_mem_rsvmap``
    This field shall contain the offset in bytes of the memory
    reservation block (see :numref:`sect-fdt-memory-reservation-block`)
    from the beginning of the header.

``version``
    This field shall contain the version of the devicetree data
    structure. The version is 17 if using the structure as defined in
    this document. An |spec| boot program may provide the devicetree of
    a later version, in which case this field shall contain the version
    number defined in whichever later document gives the details of that
    version.

``last_comp_version``
    This field shall contain the lowest version of the devicetree data
    structure with which the version used is backwards compatible. So,
    for the structure as defined in this document (version 17), this
    field shall contain 16 because version 17 is backwards compatible
    with version 16, but not earlier versions. As per
    :numref:`sect-fdt-versioning`, a |spec| boot program should provide a
    devicetree in a format which is backwards compatible with version
    16, and thus this field shall always contain 16.

``boot_cpuid_phys``
    This field shall contain the physical ID of the system’s boot CPU.
    It shall be identical to the physical ID given in the ``reg`` property
    of that CPU node within the devicetree.

``size_dt_strings``
    This field shall contain the length in bytes of the strings block
    section of the devicetree blob.

``size_dt_struct``
    This field shall contain the length in bytes of the structure block
    section of the devicetree blob.


.. FIXME: Add reserved memory node

.. _sect-fdt-memory-reservation-block:

Memory Reservation Block
------------------------

Purpose
~~~~~~~

The *memory reservation block* provides the client program with a list
of areas in physical memory which are *reserved*; that is, which shall
not be used for general memory allocations. It is used to protect vital
data structures from being overwritten by the client program. For
example, on some systems with an IOMMU, the TCE (translation control
entry) tables initialized by a |spec| boot program would need to be
protected in this manner. Likewise, any boot program code or data used
during the client program’s runtime would need to be reserved (e.g.,
RTAS on Open Firmware platforms). |spec| does not require the boot
program to provide any such runtime components, but it does not prohibit
implementations from doing so as an extension.

More specifically, a client program shall not access memory in a
reserved region unless other information provided by the boot program
explicitly indicates that it shall do so. The client program may then
access the indicated section of the reserved memory in the indicated
manner. Methods by which the boot program can indicate to the client
program specific uses for reserved memory may appear in this document,
in optional extensions to it, or in platform-specific documentation.

The reserved regions supplied by a boot program may, but are not
required to, encompass the devicetree blob itself. The client program
shall ensure that it does not overwrite this data structure before it is
used, whether or not it is in the reserved areas.

Any memory that is declared in a memory node and is accessed by the boot
program or caused to be accessed by the boot program after client entry
must be reserved. Examples of this type of access include (e.g.,
speculative memory reads through a non-guarded virtual page).

This requirement is necessary because any memory that is not reserved
may be accessed by the client program with arbitrary storage attributes.

.. FIXME: Power ISA reference to be moved to appendix

Any accesses to reserved memory by or caused by the boot program must be
done as not Caching Inhibited and Memory Coherence Required (i.e., WIMG
= 0bx01x), and additionally for Book III-S implementations as not Write
Through Required (i.e., WIMG = 0b001x). Further, if the VLE storage
attribute is supported, all accesses to reserved memory must be done as
VLE=0.

This requirement is necessary because the client program is permitted to
map memory with storage attributes specified as not Write Through
Required, not Caching Inhibited, and Memory Coherence Required (i.e.,
WIMG = 0b001x), and VLE=0 where supported. The client program may use
large virtual pages that contain reserved memory. However, the client
program may not modify reserved memory, so the boot program may perform
accesses to reserved memory as Write Through Required where conflicting
values for this storage attribute are architecturally permissible.

Format
~~~~~~

The memory reservation block consists of a list of pairs of 64-bit
big-endian integers, each pair being represented by the following C
structure.

.. code-block:: c

    struct fdt_reserve_entry {
        uint64_t address;
        uint64_t size;
    };

Each pair gives the physical address and size in bytes of a reserved memory region.
These given regions shall not overlap each other. The list of
reserved blocks shall be terminated with an entry where both address and
size are equal to 0. Note that the address and size values are always
64-bit. On 32-bit CPUs the upper 32-bits of the value are ignored.

Each uint64_t in the memory reservation block, and thus the memory
reservation block as a whole, shall be located at an 8-byte aligned
offset from the beginning of the devicetree blob (see
:numref:`sect-fdt-alignment`).

Memory Reservation Block and UEFI
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

As with the ``/reserved-memory`` node (:numref:`sect-reserved-memory-uefi`),
when booting via [UEFI]_ entries in the Memory Reservation Block must also be
listed in the system memory map obtained via the GetMemoryMap() to protect against
allocations by UEFI applications.
The memory reservation block entries should be listed with type
``EfiReservedMemoryType``.

.. _sect-fdt-structure-block:

Structure Block
---------------

The structure block describes the structure and contents of the devicetree
itself. It is composed of a sequence of tokens with data, as described below.
These are organized into a linear tree structure, as described below.

Each token in the structure block, and thus the structure block itself,
shall be located at a 4-byte aligned offset from the beginning of the
devicetree blob (see :numref:`sect-fdt-alignment`).

.. _sect-fdt-lexical-structure:

Lexical structure
~~~~~~~~~~~~~~~~~

The structure block is composed of a sequence of pieces, each beginning
with a token, that is, a big-endian 32-bit integer. Some tokens are
followed by extra data, the format of which is determined by the token
value. All tokens shall be aligned on a 32-bit boundary, which may
require padding bytes (with a value of 0x0) to be inserted after the
previous token’s data.

The five token types are as follows:

``FDT_BEGIN_NODE`` (0x00000001)
    The FDT_BEGIN_NODE token marks the beginning of a node’s
    representation. It shall be followed by the node’s unit name as
    extra data. The name is stored as a null-terminated string, and
    shall include the unit address (see :numref:`sect-node-names`), if any.
    The node name is followed by zeroed padding bytes, if necessary for
    alignment, and then the next token, which may be any token except
    FDT_END.

``FDT_END_NODE`` (0x00000002)
    The FDT_END_NODE token marks the end of a node’s representation.
    This token has no extra data; so it is followed immediately by the
    next token, which may be any token except FDT_PROP.

``FDT_PROP`` (0x00000003)
   The FDT_PROP token marks the beginning of the representation of one
   property in the devicetree. It shall be followed by extra data
   describing the property. This data consists first of the property’s
   length and name represented as the following C structure:

   .. code-block:: c

      struct {
          uint32_t len;
          uint32_t nameoff;
      }

   Both the fields in this structure are 32-bit big-endian integers.

   * len gives the length of the property’s value in bytes (which may be
     zero, indicating an empty property, see :numref:`sect-property-values`).

   * nameoff gives an offset into the strings block
     (see :numref:`sect-fdt-strings-block`)
     at which the property’s name is stored as a null-terminated string.

   After this structure, the property’s value is given as a byte string of
   length len. This value is followed by zeroed padding bytes (if
   necessary) to align to the next 32-bit boundary and then the next token,
   which may be any token except FDT_END.

``FDT_NOP`` (0x00000004)
    The FDT_NOP token will be ignored by any program parsing the device
    tree. This token has no extra data; so it is followed immediately by
    the next token, which can be any valid token. A property or node
    definition in the tree can be overwritten with FDT_NOP tokens to
    remove it from the tree without needing to move other sections of
    the tree’s representation in the devicetree blob.

``FDT_END`` (0x00000009)
    The FDT_END token marks the end of the structure block. There shall
    be only one FDT_END token, and it shall be the last token in the
    structure block. It has no extra data; so the byte immediately after
    the FDT_END token has offset from the beginning of the structure
    block equal to the value of the size_dt_struct field in the device
    tree blob header.

Tree structure
~~~~~~~~~~~~~~

The devicetree structure is represented as a linear tree: the
representation of each node begins with an FDT_BEGIN_NODE token and
ends with an FDT_END_NODE token. The node’s properties and subnodes
(if any) are represented before the FDT_END_NODE, so that the
FDT_BEGIN_NODE and FDT_END_NODE tokens for those subnodes are nested
within those of the parent.

The structure block as a whole consists of the root node’s
representation (which contains the representations for all other nodes),
followed by an FDT_END token to mark the end of the structure block as
a whole.

More precisely, each node’s representation consists of the following
components:

* (optionally) any number of FDT_NOP tokens
* FDT_BEGIN_NODE token

   * The node’s name as a null-terminated string
   * [zeroed padding bytes to align to a 4-byte boundary]

* For each property of the node:

   * (optionally) any number of FDT_NOP tokens
   * FDT_PROP token

      * property information as given in :numref:`sect-fdt-lexical-structure`
      * [zeroed padding bytes to align to a 4-byte boundary]

* Representations of all child nodes in this format
* (optionally) any number of FDT_NOP tokens
* FDT_END_NODE token

Note that this process requires that all property definitions for a
particular node precede any subnode definitions for that node. Although
the structure would not be ambiguous if properties and subnodes were
intermingled, the code needed to process a flat tree is simplified by
this requirement.

.. _sect-fdt-strings-block:

Strings Block
-------------

The strings block contains strings representing all the property names
used in the tree. These null terminated strings are simply concatenated
together in this section, and referred to from the structure block by an
offset into the strings block.

The strings block has no alignment constraints and may appear at any
offset from the beginning of the devicetree blob.

.. _sect-fdt-alignment:

Alignment
---------

The devicetree blob shall be located at an 8-byte-aligned address. To maintain
backwards compatibilty for 32-bit machines, 4-byte alignment is supported by
some software, but this is not |spec|-compliant.

For the data in the memory reservation and structure blocks to be used
without unaligned memory accesses, they shall lie at suitably aligned
memory addresses. Specifically, the memory reservation block shall be
aligned to an 8-byte boundary and the structure block to a 4-byte
boundary.

Furthermore, the devicetree blob as a whole can be relocated without
destroying the alignment of the subblocks.

As described in the previous sections, the structure and strings blocks
shall have aligned offsets from the beginning of the devicetree blob.
To ensure the in-memory alignment of the blocks, it is sufficient to
ensure that the devicetree as a whole is loaded at an address aligned
to the largest alignment of any of the subblocks, that is, to an 8-byte
boundary. A |spec| compliant boot
program shall load the devicetree blob at such an aligned address
before passing it to the client program. If an |spec| client program
relocates the devicetree blob in memory, it should only do so to
another 8-byte aligned address.
