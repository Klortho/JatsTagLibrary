JatsTagLibrary
==============

Looking for the "permalink" user script for the JATS Tag Library pages?  I've moved
that to its own repository, [here](https://github.com/Klortho/TagLibPermalink).

This repository is a project to improve the JATS
Tag Library documentation, which can be found here:

  * [Archiving and Interchange - NISO JATS
    1.0](http://jats.nlm.nih.gov/archiving/tag-library/1.0/)
  * [Publishing - NISO JATS 1.0](http://jats.nlm.nih.gov/publishing/tag-library/1.0/)
  * [Article Authoring - NISO JATS
    1.0](http://jats.nlm.nih.gov/articleauthoring/tag-library/1.0/)

I am adapting the [jqapi](http://jqapi.com/) documentation framework to work with
the tag library.

Work is being done in [my fork of that
software](https://github.com/Klortho/jqapi/tree/dtdanalyzer), but eventually will
be moved here.




Transforming the tag library documentation
------------------------------------------

These are the steps used to convert the tag library documentation into the form
needed by the documentation framework.  I wasn't given access to the original
XML files used to produce the tag library documentation, so I had to start with
the HTML files downloaded from jats.nlm.nih.gov.

### Get prerequisites

* Get saxon9he.jar and put it into the *scripts* directory.
* Install ruby and the nokogiri gem.

### Downloaded the official JATS Tag Library documentation

Version 1.0 of each of the three main tag sets was downloaded from
[ftp://ftp.ncbi.nlm.nih.gov/pub/jats](ftp://ftp.ncbi.nlm.nih.gov/pub/jats),
extracted, and then imported into this Git repository, with
[this commit](https://github.com/Klortho/JatsTagLibrary/commit/ba87a7309da8f3350a7128a52320183f4c5b177d).

Note that the version I downloaded from the FTP site, on 2013-10-09, does not match the version
served from jats.nlm.nih.gov.  The downloaded version indicates, at the bottom of every page,
"Version of May 2012".  The pages served from the offical website say, "Version of August 2012".


### Use HTML tidy to convert to well-formed XHTML

Ran HTML tidy on all of the HTML files to convert them into well-formed XHTML. For
example,

```
cd archiving-1.0
../scripts/run-tidy.sh
```

I then checked the output of that, `tidy-out.txt`, for any failures.

### Preprocess the TOC

Produce the `toc-xref.xml` file by running `t-2000.html` through the `make-toc-xref.xsl`
stylesheet.  This XML file gives, for each TOC entry, the hash used in the existing
tag set documentation, the title, and a computed slug.  For example,

```xml
<item hash="n-ze42"
      title="%journal-title-elements;"
      slug="pe-journal-title-elements"/>
```

### Generate toc.html

Ran the *t-2000.html* file through the stylesheet *make-toc.xsl*, to produce *jqapi-docs/toc.html*,
which is the source for the left-hand navigation panel of the new docs.

### Generate all the other documentation files

From, for example, the *archiving-1.0* directory, run

```
ruby ../scripts/make-docs.rb
```

This will take quite a long time to convert all of the files.

Public domain
-------------

This work is in the public domain and may be reproduced, published or otherwise
used without permission of the National Library of Medicine (NLM).

Although all reasonable efforts have been taken to ensure the accuracy and
reliability of the software and data, the NLM and the U.S. Government do not
and cannot warrant the performance or results that may be obtained by using
this software or data. The NLM and the U.S. Government disclaim all warranties,
express or implied, including warranties of performance, merchantability or
fitness for any particular purpose.


