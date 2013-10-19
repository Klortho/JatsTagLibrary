<?xml version="1.0" encoding="UTF-8"?>
<!--
  The input to this should be the toc-xref.xml file, in the root directory of the 
  particular tag set project.
  
  All the templates for this are in doc-templates.xsl, and are shared with make-doc.xsl,
  which is designed to transform just a single file.  This, in contrast, will
  transform them all in one go.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:h='http://www.w3.org/1999/xhtml'
                exclude-result-prefixes="xs"
                version="2.0">

  <xsl:import href='doc-templates.xsl'/>
  <xsl:output method='xhtml' indent='no'/>
  
  <!-- The base URL of the original JATS Tag Library, http://jats.nlm... -->
  <xsl:variable name='original-base' select='/tocXref/@original-base'/>

  <!-- Various filesystem directories of interest -->
  <xsl:variable name='tocXrefPath' select='base-uri(/)'/>
  <xsl:variable name='projectRoot' select='replace($tocXrefPath, "/[^/]*$", "")'/>
  <xsl:variable name='origHtml' select='concat($projectRoot, "/orig-html")'/>
  <xsl:variable name='destDir' select='concat($projectRoot, "/jatsdoc/entries")'/>

  <!-- Set up some keys to access the xref data quickly -->
  <xsl:key name="item-by-hash" match="item" use="@hash"/>
  <xsl:key name='item-by-slug' match='item' use='@slug'/>
  
  
  <xsl:template match='/'>
    <xsl:apply-templates select='*/item'/>
  </xsl:template>
  
  <xsl:template match='item'>
    <xsl:if test='@hash != ""'>
      <xsl:variable name='hash' select='@hash'/>
      <xsl:variable name='slug' select='@slug'/>
      
      <xsl:message>Transforming <xsl:value-of select='$hash'/>.html; <xsl:value-of select='$slug'/></xsl:message>
      
      <xsl:variable name="indoc" select='document(concat($origHtml, "/", $hash, ".html"))'/>
      <xsl:result-document href="{$destDir}/{$slug}.html">
        <xsl:apply-templates select='$indoc/h:html'>
          <xsl:with-param name="hash" select='$hash' tunnel="yes"/>
          <xsl:with-param name="slug" select='$slug' tunnel="yes"/>
          <xsl:with-param name="xref" select='/' tunnel="yes"/>
        </xsl:apply-templates>
      </xsl:result-document>
    </xsl:if>
  </xsl:template>
    
</xsl:stylesheet>