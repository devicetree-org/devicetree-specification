.. SPDX-License-Identifier: Apache-2.0

.. _chapter-introduction:

Introduction
============

Purpose and Scope
-----------------

To initialize and boot a computer system, various software components
interact. Firmware might perform low-level initialization of the system
hardware before passing control to software such as an operating system,
bootloader, or hypervisor. Bootloaders and hypervisors can, in turn,
load and transfer control to operating systems. Standard, consistent
interfaces and conventions facilitate the interactions between these
software components.  In this document the term *boot program* is used to
generically refer to a software component that initializes the system
state and executes another software component referred to as a *client
program*. Examples of a boot program include: firmware, bootloaders, and
hypervisors. Examples of a client program include: bootloaders,
hypervisors, operating systems, and special purpose programs. A piece of
software may be both a client program and a boot program  (e.g. a hypervisor).

This specification, the |spec-fullname| (|spec|),
provides a complete boot program to client program
interface definition, combined with minimum system requirements that
facilitate the development of a wide variety of systems.

This specification is targeted towards the requirements of embedded
systems. An embedded system typically consists of system hardware, an
operating system, and application software that are custom designed to
perform a fixed, specific set of tasks. This is unlike general purpose
computers, which are designed to be customized by a user with a variety
of software and I/O devices. Other characteristics of embedded systems
may include:

*  a fixed set of I/O devices, possibly highly customized for the
   application
*  a system board optimized for size and cost
*  limited user interface
*  resource constraints like limited memory and limited nonvolatile storage
*  real-time constraints
*  use of a wide variety of operating systems, including Linux,
   real-time operating systems, and custom or proprietary operating
   systems

**Organization of this Document**

* :numref:`Chapter %s <chapter-introduction>` introduces the architecture being
  specified by |spec|.
* :numref:`Chapter %s <chapter-devicetree>` introduces the devicetree concept
  and describes its logical structure and standard properties.
* :numref:`Chapter %s <chapter-device-node-requirements>` specifies the
  definition of a base set of device nodes required by |spec|-compliant
  devicetrees.
* :numref:`Chapter %s <chapter-device-bindings>` describes device bindings for
  certain classes of devices and specific device types.
* :numref:`Chapter %s <chapter-fdt-structure>` specifies the DTB encoding of devicetrees.
* :numref:`Chapter %s <chapter-devicetree-source-format>` specifies the DTS source language.

**Conventions Used in this Document**

The word *shall* is used to indicate mandatory requirements strictly to
be followed in order to conform to the standard and from which no
deviation is permitted (*shall* equals *is required to*).

The word *should* is used to indicate that among several possibilities
one is recommended as particularly suitable, without mentioning or
excluding others; or that a certain course of action is preferred but
not necessarily required; or that (in the negative form) a certain
course of action is deprecated but not prohibited (*should* equals *is
recommended that*).

The word *may* is used to indicate a course of action permissible within
the limits of the standard (*may* equals *is permitted*).

Examples of devicetree constructs are frequently shown in *Devicetree
Syntax* form. See :numref:`chapter-devicetree-source-format` for
an overview of this syntax.

Relationship to IEEE™ 1275 and |epapr|
--------------------------------------

|spec| is loosely related to the IEEE 1275 Open Firmware
standard—\ *IEEE Standard for Boot (Initialization Configuration)
Firmware: Core Requirements and Practices* [IEEE1275]_.

The original IEEE 1275 specification and its derivatives such as CHRP [CHRP]_
and PAPR [PAPR]_ address problems of general purpose computers, such as how a
single version of an operating system can work on several different
computers within the same family and the problem of loading an operating
system from user-installed I/O devices.

Because of the nature of embedded systems, some of these problems faced
by open, general purpose computers do not apply. Notable features of the
IEEE 1275 specification that are omitted from the |spec| include:

* Plug-in device drivers
* FCode
* The programmable Open Firmware user interface based on Forth
* FCode debugging
* Operating system debugging

What is retained from IEEE 1275 are concepts from the devicetree
architecture by which a boot program can describe and communicate system
hardware information to a client program, thus eliminating the need for
the client program to have hard-coded descriptions of system hardware.

This specification partially supersedes the |epapr| [EPAPR]_ specification.
|epapr| documents how devicetree is used by the Power ISA, and covers both
general concepts, as well as Power ISA specific bindings.
The text of this document was derived from |epapr|, but either removes architecture specific bindings, or moves them into an appendix.

32-bit and 64-bit Support
-------------------------

The |spec| supports CPUs with both 32-bit and 64-bit addressing
capabilities. Where applicable, sections of the |spec| describe any
requirements or considerations for 32-bit and 64-bit addressing.


Definition of Terms
-------------------

.. glossary::

   AMP
       Asymmetric Multiprocessing. Computer available CPUs are partitioned into
       groups, each running a distinct operating system image. The CPUs
       may or may not be identical.

   boot CPU
       The first CPU which a boot program directs to a client program’s
       entry point.

   Book III-E
       Embedded Environment. Section of the Power ISA defining supervisor
       instructions and related facilities used in embedded Power processor
       implementations.

   boot program
       Used to generically refer to a software component that initializes
       the system state and executes another software component referred to
       as a client program. Examples of a boot program include: firmware,
       bootloaders, and hypervisors.

   client program
       Program that typically contains application or operating system
       software. Examples of a client program include: bootloaders,
       hypervisors, operating systems, and special purpose programs.

   cell
       A unit of information consisting of 32 bits.

   DMA
       Direct memory access

   DTB
       Devicetree blob. Compact binary representation of the devicetree.

   DTC
       Devicetree compiler. An open source tool used to create DTB files
       from DTS files.

   DTS
       Devicetree syntax. A textual representation of a devicetree
       consumed by the DTC. See Appendix A Devicetree Source Format
       (version 1).

   effective address
       Memory address as computed by processor storage access or branch
       instruction.

   physical address
       Address used by the processor to access external device, typically a
       memory controller.

   Power ISA
       Power Instruction Set Architecture.

   interrupt specifier
       A property value that describes an interrupt. Typically information
       that specifies an interrupt number and sensitivity and triggering
       mechanism is included.

   secondary CPU
       CPUs other than the boot CPU that belong to the client program are
       considered *secondary CPUs*.

   SMP
       Symmetric multiprocessing. A computer architecture where two or more
       identical CPUs can share memory and IO and operate under a single operating
       system.

   SoC
       System on a chip. A single computer chip integrating one or more CPU
       core as well as number of other peripherals.

   unit address
       The part of a node name specifying the node’s address in the address
       space of the parent node.

   quiescent CPU
       A quiescent CPU is in a state where it cannot interfere with the
       normal operation of other CPUs, nor can its state be affected by the
       normal operation of other running CPUs, except by an explicit method
       for enabling or re-enabling the quiescent CPU.
