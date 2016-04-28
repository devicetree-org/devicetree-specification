**Copyright**

The devicetree.org word marks and the
devicetree.org logos and related marks are trademarks and service marks
licensed by Linaro Ltd. Implementation of certain elements of this
document may require licenses under third party intellectual property
rights, including without limitation, patent rights. Linaro Ltd and its
Members are not, and shall not be held, responsible in any manner for
identifying or failing to identify any or all such third party
intellectual property rights.

THIS DEVICETREE SPECIFICATION PROVIDED “AS IS” AND WITHOUT ANY WARRANTY
OF ANY KIND, INCLUDING, WITHOUT LIMITATION, ANY EXPRESS OR IMPLIED
WARRANTY OF NON-INFRINGEMENT, MERCHANTABILITY OR FITNESS FOR A
PARTICULAR PURPOSE. IN NO EVENT SHALL LINARO LTD OR ANY MEMBER OF
LINARO LTD BE LIABLE FOR ANY DIRECT, INDIRECT, SPECIAL, EXEMPLARY,
PUNITIVE, OR CONSEQUENTIAL DAMAGES, INCLUDING, WITHOUT LIMITATION, LOST
PROFITS, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

Questions pertaining to this document, or the terms or conditions of its
provision, should be addressed to:

| LINARO LTD
| Harston Mill, 
| Royston Road,
| Harston CB22 7GG
| Attn: Devicetree.org Board Secretary
|

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
|

**LICENSE INFORMATION**

Copyright 2016 Linaro, Ltd.

Copyright 2008,2011 Power.org, Inc.

Copyright 2008,2011 Freescale Semiconductor, Inc.

Copyright 2008,2011 International Business Machines Corporation.

Copyright 2016 ARM Ltd.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

**Acknowledgements**

The power.org Platform Architecture Technical Subcommittee would like
thank the many individuals and companies that contributed to the
development this specification through writing, technical discussions
and reviews.

**Individuals**

* Hollis Blanchard, Dan Bouvier, Josh Boyer, Becky Bruce, Dale Farnsworth, Kumar Gala, Charles Garcia-Tobin, David Gibson, Ben Herrenschmidt, Rob Herring, Dan Hettena, Olof Johansson, Ashish Kalra, Grant Likely, Jon Loeliger, Hartmut Penner, Mark Rutland, Tim Radzykewycz, Heiko Schick, Jeff Scheel, Timur Tabi, John Traill, John True, Matt Tyrlik, Kanta Vekaria, Dave Willoughby, Scott Wood, Jimi Xenidis, Stuart Yoder

**Companies**

* ARM
* Green Hills Software
* IBM
* Linaro
* Montavista
* NXP Semiconductor
* Wind River

**Other Acknowledgements**
We would like to acknowledge Power.org for preparing and publishing the |epapr| specification.

Significant aspects of the |spec-fullname| are based on work done by
the Open Firmware Working Group which developed bindings for IEEE-1275.
We would like to acknowledge their contributions.

We would also like to acknowledge the contribution of the PowerPC and ARM Linux
communities that developed and implemented the flattened device
tree concept.

.. _revision-history:

.. tabularcolumns:: l l J

.. table:: Revision History

   =========== ========== =======================================================
   Revision     Date       Description
   =========== ========== =======================================================
   |epapr| 1.0  7/23/2008  Initial Version
   |epapr| 1.1  3/7/2011   Updates include: virtualization chapter, consolidated
                           representation of cpu nodes, stdin/stdout properties
                           on /chosen, label property, representation of hardware
                           threads on cpu nodes, representation of Power ISA
                           categories on cpu nodes, mmu type property, removal of
                           some bindings, additional cpu entry requirements for
                           threaded cpus, miscellaneous cleanup and
                           clarifications.
   |spec| 0.1
   =========== ========== =======================================================
