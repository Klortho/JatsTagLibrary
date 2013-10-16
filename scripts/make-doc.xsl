<?xml version="1.0" encoding="UTF-8"?>

<!--
  This stylesheet converts one XHTML documentation file from the JATS Tag Library
  into a form that can be used with the jqapi documentation browser.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:h='http://www.w3.org/1999/xhtml'
                xmlns:f='http://ncbi.nlm.nih.gov/ns/functions'
                exclude-result-prefixes="xs f"
                version="2.0">

  <xsl:output method='xhtml' indent='yes'/>
  
  <xsl:param name='original-base' />
  <xsl:param name='hash' />

  <!-- Read in the toc-xref, so we can resolve inter-page links -->
  <xsl:variable name='baseUri' select='base-uri(/)'/>
  <xsl:variable name='dir' select='replace($baseUri, "/[^/]*$", "")'/>
  <xsl:variable name='xref' 
    select='document(concat($dir, "/../", "toc-xref.xml"))'/>
  
  
  <xsl:template match='h:html'>
    <xsl:apply-templates select='h:body'/>
  </xsl:template>
  
  <xsl:template match='h:body'>
    <div id='entry-wrapper'>
      <!-- Original link -->
      <a class='original' href='{$original-base}{$hash}.html'>Original</a>
      
      
      <!-- h1 header -->
      <xsl:choose>
        <!-- Example:  How To Use -->
        <xsl:when test='h:h1[@class="sectiontitle"]'>
          <xsl:variable name='header' select='h:h1[@class="sectiontitle"]'/>
          <h1>
            <xsl:copy-of select='$header/node()'/>
          </h1>
          <xsl:for-each select='$header/following-sibling::*'>
            <xsl:apply-templates select='.'/>
          </xsl:for-each>
        </xsl:when>

        <!-- Example:  General Introduction -->
        <xsl:when test='h:div[@class="intro"]/h:h1[@class="header"]'>
          <xsl:variable name='header' select='h:div[@class="intro"]/h:h1[@class="header"]'/>
          <h1>
            <xsl:copy-of select='$header/node()'/>
          </h1>
          <xsl:for-each select="$header/following-sibling::*">
            <xsl:apply-templates select='.'/>
          </xsl:for-each>
        </xsl:when>
        
        <!-- Example:  any element entry, e.g. <abbrev> n-jn00.html -->
        <xsl:when test='h:div[@class="header"]'>
          <xsl:variable name='header' select='h:div[@class="header"]'/>
          
          <h1>
            <xsl:copy-of select='$header/h:h1[@class="elementtag"]/node()'/>
            <xsl:value-of select='" "'/>
            <xsl:copy-of select='$header/h:h1[@class="elementname"]/node()'/>
          </h1>
          
          <xsl:for-each select="$header/following-sibling::*">
            <xsl:apply-templates select='.'/>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </div>
  </xsl:template>
  
  <!-- Fix URLs of images -->  
  <xsl:template match='h:img/@src[starts-with(., "graphics/")]'>
    <xsl:attribute name='src'>
      <xsl:value-of select='concat("resources/", substring-after(., "graphics/"))'/>
    </xsl:attribute>
  </xsl:template>

  <!-- 
    Fix inter-page links.
    To do:  need to come up with a mechanism to link to targets within an
    entry.  Maybe "#p=entry;t=target".  Then the AJAX handler will have to
    scroll to the target after the entry is loaded.
  -->
  <xsl:template match='h:a/@href'>
    <xsl:choose>
      <!-- Does the URL start with something that looks like a tag library hash? -->
      <xsl:when test="matches(., '^[a-z]-[a-z0-9]{4}\.html')">
        <xsl:variable name='hash' select='substring(., 1, 6)'/>
        <xsl:variable name='slug' select='$xref//item[@hash=$hash]/@slug'/>
        <xsl:choose>
          <!-- Did we successfully find the slug? -->
          <xsl:when test="$slug">
            <xsl:attribute name='href'>
              <xsl:value-of select='concat("#p=", $slug)'/>
            </xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:copy/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Drop the pagefooter for each entry.  We'll preserve the index.html
    footer and use it everywhere -->
  <xsl:template match='h:div[@class="pagefooter"]'/>

  <!-- Get rid of some silly classes -->
  <xsl:template match='h:p/@class[.="para"]'/>
  <xsl:template match='h:ul/@class[.="bullist"]'/>
  <xsl:template match='h:h3/@class[.="header"]'/>
    

  <xsl:template match='@*|*|text()'>
    <xsl:copy>
      <xsl:apply-templates select='@*|*|text()'/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>