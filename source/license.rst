**Copyright**

Copyright © 2008,2011 Power.org. All rights reserved.

The Power Architecture and Power.org word marks and the Power and
Power.org logos and related marks are trademarks and service marks
licensed by Power.org. Implementation of certain elements of this
document may require licenses under third party intellectual property
rights, including without limitation, patent rights. Power.org and its
Members are not, and shall not be held, responsible in any manner for
identifying or failing to identify any or all such third party
intellectual property rights.

THIS POWER.ORG SPECIFICATION PROVIDED “AS IS” AND WITHOUT ANY WARRANTY
OF ANY KIND, INCLUDING, WITHOUT LIMITATION, ANY EXPRESS OR IMPLIED
WARRANTY OF NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
PARTICULAR PURPOSE. IN NO EVENT SHALL POWER.ORG OR ANY MEMBER OF
POWER.ORG BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL, EXEMPLARY,
PUNITIVE, OR CONSEQUENTIAL DAMAGES, INCLUDING, WITHOUT LIMITATION, LOST
PROFITS, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

Questions pertaining to this document, or the terms or conditions of its
provision, should be addressed to:

| IEEE-ISTO
| 445 Hoes Lane
| Piscataway, NJ 08854
| Attn: Power.org Board Secretary

**LICENSE INFORMATION**

© Copyright 2008,2011 Power.org, Inc

© Copyright Freescale Semiconductor, Inc., 2008,2011

© Copyright International Business Machines Corporation, 2008,2011

All Rights Reserved.

**Acknowledgements**

The power.org Platform Architecture Technical Subcommittee would like
thank the many individuals and companies that contributed to the
development this specification through writing, technical discussions
and reviews.

**Individuals**

* Hollis Blanchard
* Dan Bouvier
* Josh Boyer
* Becky Bruce
* Dale Farnsworth
* Kumar Gala
* David Gibson
* Ben Herrenschmidt
* Dan Hettena
* Olof Johansson
* Ashish Kalra
* Grant Likely
* Jon Loeliger
* Hartmut Penner
* Tim Radzykewycz
* Heiko Schick
* Timur Tabi
* John Traill
* John True
* Matt Tyrlik
* Dave Willoughby
* Scott Wood
* Jimi Xenidis
* Stuart Yoder

**Companies**

* Freescale Semiconductor
* Green Hills Software
* IBM
* Montavista
* Wind River

**Other Acknowledgements**

Significant aspects of the |spec-fullname| are based on work done by
the Open Firmware Working Group which developed bindings for IEEE-1275.
We would like to acknowledge their contributions.

We would also like to acknowledge the contribution of the PowerPC Linux
community that initially developed and implemented the flattened device
tree concept.

.. _revision-history:

.. tabularcolumns:: l l J

.. table:: Revision History

   +-------------+-----------+--------------------------------------------------------+
   | Revision    | Date      | Description                                            |
   +=============+===========+========================================================+
   | |epapr| 1.0 | 7/23/2008 | Initial Version                                        |
   +-------------+-----------+--------------------------------------------------------+
   | |epapr| 1.1 | 3/7/2011  | Updates include: virtualization chapter, consolidated  |
   |             |           | representation of cpu nodes, stdin/stdout properties   |
   |             |           | on /chosen, label property, representation of hardware |
   |             |           | threads on cpu nodes, representation of Power ISA      |
   |             |           | categories on cpu nodes, mmu type property, removal of |
   |             |           | some bindings, additional cpu entry requirements for   |
   |             |           | threaded cpus, miscellaneous cleanup and               |
   |             |           | clarifications.                                        |
   +-------------+-----------+--------------------------------------------------------+
   | |spec| 0.1  |           |                                                        |
   +-------------+-----------+--------------------------------------------------------+
