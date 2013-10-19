<?xml version="1.0" encoding="UTF-8"?>
<!--
  This stylesheet converts one XHTML documentation file from the JATS Tag Library
  into a form that can be used with the jqapi documentation browser.

  All the templates for this are in doc-templates.xsl, and are shared with make-docs.xsl,
  which is designed to transform all of the files in one go.  This, in contrast, will
  transform just one.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:h='http://www.w3.org/1999/xhtml'
                xmlns:f='http://ncbi.nlm.nih.gov/ns/functions'
                exclude-result-prefixes="xs f"
                version="2.0">
  <xsl:import href="doc-templates.xsl"/>
  
  <!-- 
    In the output spec, indent must be "no", otherwise Saxon adds whitespace around 
    <a> tags.  I haven't investigated thoroughly, but I'd say this is a bug.  See
    http://www.w3.org/TR/xslt-xquery-serialization/#xhtml-output:
    "Whitespace MUST NOT be added or removed adjacent to an inline element"
  -->
  <xsl:output method='xhtml' indent='no'/>
  
  <!-- The base URL of the original JATS Tag Library, http://jats.nlm... -->
  <xsl:param name='original-base' />
  
  <!-- The hash of this file we're transforming -->
  <xsl:param name='hash'/>

  <!-- Read in the toc-xref, so we can resolve inter-page links -->
  <xsl:variable name='baseUri' select='base-uri(/)'/>
  <xsl:variable name='dir' select='replace($baseUri, "/[^/]*$", "")'/>
  <xsl:variable name='xref'
                select='document(concat($dir, "/../", "toc-xref.xml"))'/>
  
  <!-- Set up some keys to access the xref data quickly -->
  <xsl:key name="item-by-hash" match="item" use="@hash"/>
  <xsl:key name='item-by-slug' match='item' use='@slug'/>
  
  <xsl:variable name='slug' select='key("item-by-hash", $hash, $xref)/@slug'/>
  
  <xsl:template match='/'>
    <xsl:apply-templates>
      <xsl:with-param name="hash" select='$hash' tunnel="yes"/>
      <xsl:with-param name="slug" select='$slug' tunnel="yes"/>
      <xsl:with-param name="xref" select='$xref' tunnel="yes"/>
    </xsl:apply-templates>
  </xsl:template>
</xsl:stylesheet>
