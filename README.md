# Document master project for the Devicetree Specification #

The latest release of the specification can be found at http://devicetree.org/ or https://github.com/devicetree-org/devicetree-specification-released

This [repository](https://github.com/devicetree-org/devicetree-specification) holds the source for the generation of the Devicetree Specification using Sphinx and LaTeX. 

## Mailing list: devicetree-spec@vger.kernel.org ##
   * Use this mailing list for submitting patches, questions and general discussion
   * Sign up to the mailing list at http://vger.kernel.org/vger-lists.html#devicetree-spec

## Build Instructions [![Build Status](https://travis-ci.org/devicetree-org/devicetree-specification.svg)](https://travis-ci.org/devicetree-org/devicetree-specification) ##

Requirements:
* Sphinx: http://sphinx-doc.org/contents.html
 * version 1.2.3 or later
* LaTeX (and pdflatex, and various LaTeX packages)
* Graphviz (in particular, "dot"): http://www.graphviz.org/

On Debian and Ubuntu:

>```
># apt-get install python-sphinx latexdiff texlive texlive-latex-extra \
>                  texlive-humanities texlive-generic-recommended graphviz \
>                  texlive-generic-extra
>```
>
>If the version of python-sphinx installed is too old, then an additional
>new version can be installed with the Python package installer:
>
>```
>$ apt-get install python-pip
>$ pip install --user --upgrade Sphinx
>$ export SPHINXBUILD=~/.local/bin/sphinx-build
>```
>
>Export SPHINXBUILD (see above) if Sphinx was installed with pip --user, then follow Make commands below

On Mac OS X:

> Install [MacTeX](http://tug.org/mactex/)
>
> Install pip if you do not have it:
>```
>$ sudo easy_install pip
>```
>Install Sphinx
>```
>pip install --user --upgrade Sphinx
>Or
>sudo pip install --upgrade Sphinx
>```
>
>If you are using [brew](http://brew.sh) then you can install graphviz like this:
>```
brew install graphviz
>```
>If you are using [macports](https://www.macports.org/) then you can install graphviz like this:
>```
>$ sudo port install graphviz
>```

Make commands:

>```
>$ make latexpdf # For generating pdf
>$ make html # For generating a hierarchy of html pages
>$ make singlehtml # For generating a single html page
>```

Output goes in ./build subdirectory.

## License ##
This project is licensed under the Apache V2 license. More information can be found 
in the LICENSE and NOTICE file or online at:

http://www.apache.org/licenses/LICENSE-2.0

## Contributions ##
Please submit all patches to the mailing list devicetree-spec@vger.kernel.org.
Contributions to the Devicetree Specification are managed by the gatekeepers,
Grant Likely <grant.likely@secretlab.ca> and Rob Herring <rob.herring@linaro.org>

Anyone can contribute to the Devicetree Specification. Contributions to this project should conform 
to the `Developer Certificate of Origin` as defined at http://elinux.org/Developer_Certificate_Of_Origin. 
Commits to this project need to contain the following line to indicate the submitter accepts the DCO:
```
Signed-off-by: Your Name <your_email@domain.com>
```
By contributing in this way, you agree to the terms as follows:
```
Developer Certificate of Origin
Version 1.1

Copyright (C) 2004, 2006 The Linux Foundation and its contributors.
660 York Street, Suite 102,
San Francisco, CA 94110 USA

Everyone is permitted to copy and distribute verbatim copies of this
license document, but changing it is not allowed.


Developer's Certificate of Origin 1.1

By making a contribution to this project, I certify that:

(a) The contribution was created in whole or in part by me and I
    have the right to submit it under the open source license
    indicated in the file; or

(b) The contribution is based upon previous work that, to the best
    of my knowledge, is covered under an appropriate open source
    license and I have the right under that license to submit that
    work with modifications, whether created in whole or in part
    by me, under the same open source license (unless I am
    permitted to submit under a different license), as indicated
    in the file; or

(c) The contribution was provided directly to me by some other
    person who certified (a), (b) or (c) and I have not modified
    it.

(d) I understand and agree that this project and the contribution
    are public and that a record of the contribution (including all
    personal information I submit with it, including my sign-off) is
    maintained indefinitely and may be redistributed consistent with
    this project or the open source license(s) involved.
```

