textreport
============


[![Project Status: Wip - Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](http://www.repostatus.org/badges/0.1.0/wip.svg)](http://www.repostatus.org/#wip)
[![Build
Status](https://travis-ci.org/trinker/textreport.svg?branch=master)](https://travis-ci.org/trinker/textreport)
[![Coverage
Status](https://coveralls.io/repos/trinker/textreport/badge.svg?branch=master)](https://coveralls.io/r/trinker/textreport?branch=master)
<a href="https://img.shields.io/badge/Version-0.0.1-orange.svg"><img src="https://img.shields.io/badge/Version-0.0.1-orange.svg" alt="Version"/></a>
</p>
<img src="inst/textreport_logo/r_textreport.png" width="120" alt="textreport Logo">

**textreport** automatically generates visual, descriptive reports for
text data.

The following code generated
[THIS](https://dl.dropboxusercontent.com/u/61803503/textreport.html)
visual, descriptreport.

    textreport::report(presidential_debates_2012, c("person", "time"))


Table of Contents
============

-   [Installation](#installation)
-   [Contact](#contact)

Installation
============


To download the development version of **textreport**:

Download the [zip
ball](https://github.com/trinker/textreport/zipball/master) or [tar
ball](https://github.com/trinker/textreport/tarball/master), decompress
and run `R CMD INSTALL` on it, or use the **pacman** package to install
the development version:

    if (!require("pacman")) install.packages("pacman")
    pacman::p_load_gh("trinker/textreport")

Contact
=======

You are welcome to: 
* submit suggestions and bug-reports at: <https://github.com/trinker/textreport/issues> 
* send a pull request on: <https://github.com/trinker/textreport/> 
* compose a friendly e-mail to: <tyler.rinker@gmail.com>
