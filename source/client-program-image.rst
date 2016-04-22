Client Program Image Format
===========================

This section describes the image format in which an ePAPR client is
encoded in order to boot it from an ePAPR-compliant boot program. Two
variants on the image format are described: variable-address images and
fixed-address images. ePAPR-compliant boot programs shall support client
images in the variable-address format, should support images in the
fixed-address format, and may also support other formats not described
in this document.

Variable Address Image Format
-----------------------------

This ePAPR image format is a constrained form of ELF (Executable and
Linking Format, see ?) executable. That is, an ePAPR client image shall
be a valid ELF file, but also has additional requirements described in
the next sections.

ELF Basics
~~~~~~~~~~

A variable-address client image is a 32-bit ELF client image with the
following ELF header field values:

::

    e_ident[EI_CLASS] ELFCLASS32(0x1)
    e_ident[EI_DATA]  ELFDATA2MSB(0x2)
    e_type            ET_DYN(0x3)
    e_machine         EM_PPC(0x14)

That is, it is a 32-bit Power shared-object image in 2’s complement,
big-endian format.

Every ePAPR image shall have at least one program header of type
PT\_LOAD. It may also have other valid ELF program headers. The client
image shall be arranged so that all its ELF program headers lie within
the first 1024 bytes of the image.

Boot Program Requirements
~~~~~~~~~~~~~~~~~~~~~~~~~

When loading a client image, the boot program need only consider ELF
segments of type PT\_LOAD. Other segments may be present, but should be
ignored by the boot program. In particular, the boot program should not
process any ELF relocations found in the client image.

Processing of PT\_LOAD segments
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The boot program shall load the contents of any PT\_LOAD segments into
RAM, and then pass control to the entry point specified in the ELF
header in the manner specified in section 5.4.

Each PT\_LOAD segments shall be loaded at an address decided by the boot
program, subject to the following constraints.

-  The load address shall be congruent with the program header’s
   p\_paddr value, modulo with the program header’s p\_align value.

-  If there is more than one PT\_LOAD segment, then the difference
   between the loaded address and the address specified in the p\_paddr
   field shall be the same for all segments. That is, the boot program
   shall preserve the relative offsets between PT\_LOAD segments by
   physical address.

The p\_vaddr field is reserved to represent the effective address at
which the segments will appear after the client program has performed
MMU setup. The boot program should not use the program header’s p\_vaddr
field for determining the load address of segments.

Entry point
^^^^^^^^^^^

The program entry point is the address of the first instruction that is
to be executed in a program image. The ELF header e\_entry field gives
the effective address of the program entry point. However, as described
in section 5.4, CPU Entry Point Requirements, the client program shall
be entered either in real mode or with an initial MMU mapping at
effective address 0x0.

Therefore, the boot program shall compute the physical address of the
entry point before entering the client program. To perform this
calculation, it shall locate the program segment containing the entry
point, determine the difference between e\_entry and the p\_vaddr of
that segment, and add this difference to the physical address where the
segment was loaded.

This adjusted address will be the physical address of the first client
program instruction executed after the boot program jumps to the client
program.

Client Program Requirements
~~~~~~~~~~~~~~~~~~~~~~~~~~~

The client program is entered with MMU state as described in section
5.4, CPU Entry Point Requirements. Therefore, the code at the client
program’s entry point shall be prepared to execute in this environment,
which may be different than the MMU environment in which most of the
client program executes. The p\_vaddr fields of the client’s ELF program
headers will reflect this final environment, not the environment in
which the entry point is executed.

The code at the entry point shall be written so that it can be executed
at any address. It shall establish a suitable environment in which the
remainder of the client program executes. The ePAPR does not specify its
method, but the task could involve:

-  Processing ELF relocations to relocate the client’s own image to its
   loaded address. Note that in this case the client image shall be
   specially linked so that the ELF relocation information, plus any
   data required to find that information is contained in both the
   loaded segments and the segments and sections set aside for
   relocation information.

-  Processing other tables of relocation information in some format
   specific to the client program.

-  Physically copying the client image to the address at which it
   prefers to execute.

-  Configuring the MMU so that the client image can execute at its
   preferred effective address, regardless of the physical address at
   which it is loaded.

Fixed Address Image Format
--------------------------

Fixed-address client images are identical to variable-address client
images except for the following changes:

-  The e\_type ELF header field shall have the value ET\_EXEC (0x2).

-  The boot program, instead of loading each PT\_LOAD segment at an
   address of its choosing shall load each PT\_LOAD segment at the
   physical address given in the program header’s p\_paddr field. If it
   cannot load the segment at this address (because memory does not
   exist at that address or is already in use by the boot program
   itself), then it shall refuse to load the image and report an error
   condition.

The fixed-address image format is intended for use by very simple
clients (such as diagnostic programs), avoiding the need for such
clients to physically relocate themselves to a suitable address.

Clients should in general avoid using the fixed-address format, because
creating a usable fixedaddress image requires knowing which physical
areas will be available for client use on the platform in question.

