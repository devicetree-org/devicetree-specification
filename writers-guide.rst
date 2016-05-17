This document uses the Sphinx implementation of reStructured Text (RST). RST is
a flexible markup language with lots of options for laying out text. To keep
thinks simple, this file describes the conventions used by this project. As
much as possible, use these methods for markup.

Source Text Style
=================
The reStructuredText marking is very human-friendly and readable as is,
but most people will read the pdf or html output instead of the source files.
To make changes to the content easier to find,
use "semantic linefeeds" when writing as described by Brian Kernighan:

   Hints for Preparing Documents

   Most documents go through several versions (always more than you expected)
   before they are finally finished.
   Accordingly, you should do whatever possible to make the job of changing them easy.

   First, when you do the purely mechanical operations of typing,
   type so subsequent editing will be easy.
   Start each sentence on a new line.
   Make lines short, and break lines at natural places,
   such as after commas and semicolons, rather than randomly.
   Since most people change documents by rewriting phrases and adding,
   deleting and rearranging sentences,
   these precautions simplify any editing you have to do later.

   Brian W. Kernighan, 1974

Source : http://rhodesmill.org/brandon/2012/one-sentence-per-line/

Tables
======
Use the simplified markup for tables as shown below. Use the tabularcolumns
directive for controlling how tables are layed out in pdf output. For
consistency, tables in this document shoud be specified without internal
vertical columns separators are preferred. (ie. Only use the | specifier on the
outsides of the table, such as with ``.. tabularcolumns:: | l l J|`` instead of
``.. tabularcolumns:: | l | l | J |``. Column specifiers will be one of the
following.

When possible, use only ``l,c,r,L,R,C,J`` specifiers and the renderer will
automatically figure out the columns widths. However, if a table is longer than
a page, or has complex content, then you must manually specify each column
width with the ``p{width}`` specifier. Long tables must also include the
``:class: longtable`` directive as shown below.

=========== ======================================
Specifier   Behaviour
=========== ======================================
l           minimum width left-justified column
c           minimum width centered column
r           minimum width right-justified column
p{'width'}  paragraph column with text vertically aligned at the top
L           flush left column with automatic width
R           flush right column with automatic width
C           centered column with automatic width
J           justified column with automatic width
\|          Vertical line
||          Double vertical  line
=========== ======================================

Use ``:numref:`` to reference a table from the document text. For example:
``:numref:`table_example_simple```

.. tabluarcolumns:: l l J
.. _table_example_simple:
.. table:: Example of simple table

   ========== =============== ==========
   Heading 1  Heading 2       Heading 3
   ========== =============== ==========
   row 1      two row         cell 3
              entry
   row 2      data            more
   ========== =============== ==========

.. tabluarcolumns:: | p{3cm} p{1cm} p{10cm} |
.. _table_example_columns:
.. table:: Example of table needing explicit formatting

   ========== =============== ==========
   Heading 1  Heading 2       Heading 3
   ========== =============== ==========
   row 1      two row         cell 3
              entry
   row 2      data            more

              ::              * embedded
                              * list
                 code         * of
                 block        * items
   ========== =============== ==========

.. tabluarcolumns:: | p{3cm} p{1cm} p{10cm} |
.. _table_example_simple:
.. table:: Example of table that spans multiple pages
   :class: longtable

   ========== =============== ==========
   Heading 1  Heading 2       Heading 3
   ========== =============== ==========
   row 1      two row         cell 3
              entry
   row 2      data            more
   ========== =============== ==========
