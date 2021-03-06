﻿JatsTagLibrary
==============

<strong><em>
This repository is not maintained anymore. It is kept as an historical
record of the generation of the earlier JATS 1.0 and JATS 1.1d1 versions
of the Tag Libraries in jatsdoc. Newer versions of the Tag Libraries
use the original Tag Library sources, which is a custom XML format,
for the conversion. We hope to have those sources up on GitHub soon.
</em></strong>

Looking for the "permalink" user script for the JATS Tag Library pages?  I've moved
that to its own repository, [here](https://github.com/Klortho/TagLibPermalink).

This repository holds the content for a new-and-improved JATS Tag Set viewer.
The results are deployed to [jatspan.org](http://jatspan.org), at the following locations
(links to the originals, from which the new views were ported, are also given):

  * *Archiving and Interchange*
      * [NISO JATS Version 1.0](http://jatspan.org/niso/archiving-1.0/)
        ([original](http://jats.nlm.nih.gov/archiving/tag-library/1.0/))
      * [NISO JATS Draft Version 1.1d1](http://jatspan.org/niso/archiving-1.1d1/)
        ([original](http://jats.nlm.nih.gov/archiving/tag-library/1.1d1/))
  * *Publishing*
      * [NISO JATS Version 1.0](http://jatspan.org/niso/publishing-1.0/)
        ([original](http://jats.nlm.nih.gov/publishing/tag-library/1.0/))
      * [NISO JATS Draft Version 1.1d1](http://jatspan.org/niso/publishing-1.1d1/)
        ([original](http://jats.nlm.nih.gov/publishing/tag-library/1.1d1/))
  * *Article Authoring*
      * [NISO JATS Version 1.0](http://jatspan.org/niso/authoring-1.0/)
        ([original](http://jats.nlm.nih.gov/articleauthoring/tag-library/1.0/))
      * [NISO JATS Draft Version 1.1d1](http://jatspan.org/niso/authoring-1.1d1/)
        ([original](http://jats.nlm.nih.gov/articleauthoring/tag-library/1.1d1/))
  * *Book Interchange Tag Suite (BITS)*
      * [Version 1.0](http://jatspan.org/nlm/bits-1.0/)
        ([original](http://jats.nlm.nih.gov/extensions/bits/tag-library/1.0/))

These documentation sets use [jatsdoc](https://github.com/Klortho/jatsdoc), a
JS/CSS framework forked form the excellent [jqapi](http://jqapi.com/).

*This* JatsTagLibrary repository contains the *content*, and the various scripts
that were used to convert the original documentation into the proper form for use
with the jatsdoc framework.


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

I then moved the generated HTML files into a subdirectory called *orig-html*, and
added/committed them to the Git repo.
(Of course this is a misnomer, since they aren't really the *original* HTML files;
they have already been processed with tidy.)


### Preprocess the TOC

Produce the `toc-xref.xml` file by running `t-2000.html` through the `make-toc-xref.xsl`
stylesheet.

```
java -jar ../scripts/saxon9he.jar -xsl:../scripts/make-toc-xref.xsl \
  -s:orig-html/t-2000.html -o:toc-xref.xml
```

This XML file gives, for each TOC entry, the hash used in the existing
tag set documentation, the title, and a computed slug.  For example,

```xml
<item hash="n-ze42"
      title="%journal-title-elements;"
      slug="pe-journal-title-elements"/>
```

Then, manually enter the base URL of the original tag library documentation into
the *toc-xref.html* file.  This is used to produce the "Original" link on each of the
individual pages.  Like so:

```xml
<tocXref xmlns:h="http://www.w3.org/1999/xhtml"
         original-base='http://jats.nlm.nih.gov/archiving/tag-library/1.0/'>
```


### Generate toc.html

Run the *t-2000.html* file through the stylesheet *make-toc.xsl*, to produce
*toc.html*, which is the source for the left-hand navigation panel of the new docs:

```
java -jar ../scripts/saxon9he.jar -xsl:../scripts/make-toc.xsl \
  -s:orig-html/t-2000.html -o:toc.html
```

### Manually create the index.html page and taglib.css

These top-level pages for each tag set are written by hand.

In practice, *archiving-1.0/index.html* was written first, and then copied to
the other two, with very minor modifications.

For *taglib.css*, each tag set is customized with its own color scheme.

### Generate all the other documentation files

From, for example, the *archiving-1.0* directory, run

```
ruby ../scripts/make-docs.rb
```

This does several things, in addition to transforming the HTML files.  Run
it with the `-h` option to get more info.

This will take a few minutes to convert all of the files.  The final bundle
of documentation will be self-contained in the *jatsdoc* subdirectory,
and can be moved as a package to the server.

Note that the final converted jatsdoc version of the files do not get
added back into the Git repository.  They are "pure product" files.


Public domain
-------------

The JATS Tag Library documentation was produced for the National Center for
Biotechnology Information (NCBI), National Library of Medicine (NLM), by
Mulberry Technologies, Inc., Rockville, Maryland.

The JATS Tag Library is in the public domain. See the [NCBI Copyright and
Disclaimer](http://www.ncbi.nlm.nih.gov/About/disclaimer.html) page for more
information.

The scripts and transformations developed here by Chris Maloney, in this GitHub
project, to adapt the Tag Library to the jatsdoc framework, are also dedicated
to the [public domain](http://creativecommons.org/publicdomain/zero/1.0/).

