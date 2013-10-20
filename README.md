JatsTagLibrary
==============

Looking for the "permalink" user script for the JATS Tag Library pages?  I've moved
that to its own repository, [here](https://github.com/Klortho/TagLibPermalink).

This repository is a project to improve the JATS
Tag Library documentation.  The original versions can be found on the NLM site here:

  * [Archiving and Interchange - NISO JATS
    1.0](http://jats.nlm.nih.gov/archiving/tag-library/1.0/)
  * [Publishing - NISO JATS 1.0](http://jats.nlm.nih.gov/publishing/tag-library/1.0/)
  * [Article Authoring - NISO JATS
    1.0](http://jats.nlm.nih.gov/articleauthoring/tag-library/1.0/)

I am adapting the [jqapi](http://jqapi.com/) documentation framework to work with
the JATS tag library documentation.  Work on the framework, which is a JS and CSS library,
is being done in my fork of that software, on GitHub at
[Klortho/jatsdoc](https://github.com/Klortho/jatsdoc).

*This* repository contains the *content* that will use that documentation library,
and the scripts used to convert the original documentation into the proper form.




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

I then moved the generated HTML files into a subdirectory called *orig-html*.
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

Run the *t-2000.html* file through the stylesheet *make-toc.xsl*, to produce *jqapi-docs/toc.html*,
which is the source for the left-hand navigation panel of the new docs:

```
java -jar ../scripts/saxon9he.jar -xsl:../scripts/make-toc.xsl \
  -s:orig-html/t-2000.html -o:toc.html
```

### Manually create the index.html page and taglib.css

These top-level pages for each tag set are written by hand.


### Generate all the other documentation files

From, for example, the *archiving-1.0* directory, run

```
ruby ../scripts/make-docs.rb
```

This does several things, in addition to transforming the HTML files.  Run
it with the `-h` option to get more info.

This will take quite a long time to convert all of the files.


### Generate taglib.css

Customize each tag library with its own color scheme.



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