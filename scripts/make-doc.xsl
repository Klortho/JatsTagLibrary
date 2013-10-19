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

  <!-- 
    In the output spec, indent must be "no", otherwise Saxon adds whitespace around 
    <a> tags.  I haven't investigated thoroughly, but I'd say this is a bug.  See
    http://www.w3.org/TR/xslt-xquery-serialization/#xhtml-output:
    "Whitespace MUST NOT be added or removed adjacent to an inline element"
  -->
  <xsl:output method='xhtml' indent='no'/>
  
  <xsl:param name='original-base' />
  <xsl:param name='hash' select='"n-jn00"'/>

  <!-- Read in the toc-xref, so we can resolve inter-page links -->
  <xsl:variable name='baseUri' select='base-uri(/)'/>
  <xsl:variable name='dir' select='replace($baseUri, "/[^/]*$", "")'/>
  <xsl:variable name='xref' 
    select='document(concat($dir, "/../", "toc-xref.xml"))'/>

  <xsl:variable name='slug' select='$xref//item[@hash=$hash]/@slug'/>

  
  <xsl:template match='h:html'>
    <xsl:apply-templates select='h:body'/>
  </xsl:template>
  
  <xsl:template match='h:body'>
    <div id='entry-wrapper'>
      <span class='original'>
        <a href='{$original-base}{$hash}.html'>Original</a>
        <xsl:if test='starts-with($slug, "elem-") or
                      starts-with($slug, "attr-") or
                      starts-with($slug, "pe-")'>
          <xsl:text> (</xsl:text>
            <a href='{$original-base}?{concat(substring-before($slug, "-"), "=", substring-after($slug, "-"))}'>frames</a>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </span>
      
      
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
          <xsl:for-each select="$header/following-sibling::node()">
            <xsl:apply-templates select='.'/>
          </xsl:for-each>
        </xsl:when>
        
        <!-- Example:  any element entry, e.g. <abbrev> n-jn00.html -->
        <xsl:when test='h:div[@class="header"]'>
          <xsl:variable name='header' select='h:div[@class="header"]'/>
          
          <h1>
            <xsl:copy-of select='$header/h:h1[
              @class="elementtag" or @class="attrtag" or @class="petag"]/node()'/>
            <xsl:text> </xsl:text>
            <xsl:if test='$header/h:h1[@class="attrtag"]'>
              <xsl:text>- </xsl:text>
            </xsl:if>
            <xsl:copy-of select='$header/h:h1[
              @class="elementname" or @class="attrname" or @class="pename"]/node()'/>
          </h1>
          
          <xsl:for-each select="$header/following-sibling::node()">
            <xsl:apply-templates select='.'/>
          </xsl:for-each>
        </xsl:when>
        
        <!-- Example: top-level-element:  n-h2g2.html, body comprises
          <div class='section'>
            <h3 class='header'>...</h3>
            ...
          </div>
        -->
        <xsl:when test='h:div[@class="section"]/*[1][local-name()="h3"][@class="header"]'>
          <h1>
            <xsl:copy-of select='h:div[@class="section"]/*[1]/node()'/>
          </h1>
          <xsl:apply-templates select='h:div[@class="section"]/*[1]/following-sibling::node()'/>
        </xsl:when>

        <!-- Example: sample-citations-for:  n-6en2.html, body comprises 
          <div class='section'>
            <h4 class='header'>...</h4>
            ...
          </div>
        -->
        <xsl:when test='h:div[@class="section"]/*[1][local-name()="h4"][@class="header"]'>
          <h1>
            <xsl:copy-of select='h:div[@class="section"]/*[1]/node()'/>
          </h1>
          <xsl:apply-templates select='h:div[@class="section"]/*[1]/following-sibling::node()'/>
        </xsl:when>
        
        <!-- element-context-table, n-nzd2 -->
        <xsl:when test='h:div[@class="pageheader"]/following-sibling::*[1][local-name()="h1"]'>
          <xsl:variable name='header' select='h:div[@class="pageheader"]/following-sibling::*[1]'/>
          <h1>
            <xsl:copy-of select='$header/node()'/>
          </h1>
          <xsl:for-each select="$header/following-sibling::node()">
            <xsl:apply-templates select='.'/>
          </xsl:for-each>
        </xsl:when>
      </xsl:choose>
    </div>
  </xsl:template>

  <!-- Fix text nodes that are immediate children of <div class='section'>.  I found
    one of these in Tagging Personal Names (text "as illustrated here:").  There might
    be others.  -->
  <xsl:template match='h:div[@class="section"]/text()'>
    <xsl:if test='normalize-space(.) != ""'>
      <p>
        <xsl:copy/>
      </p>
    </xsl:if>
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

  <!-- Rework the attribute lists inside the element entries -->
  <xsl:template match='h:div[@class="attrlist"]'>
    <xsl:copy>
      <xsl:apply-templates select='@*'/>
      <h2>Attributes</h2>
      <ul class='attrlist'>
        <xsl:apply-templates select='h:h5' mode='attrlist'/>
      </ul>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template match='h:h5' mode='attrlist'>
    <li>
      <xsl:apply-templates mode='attrlist'/>
    </li>
  </xsl:template>

  <xsl:template match='h:a[h:span/@class="attrtag"]' mode='attrlist'>
    <xsl:copy>
      <xsl:apply-templates/>
    </xsl:copy>
    <xsl:text> - </xsl:text>
  </xsl:template>

  <xsl:template match='h:a[h:span/@class="attrname"]' mode='attrlist'>
    <xsl:apply-templates select='h:span/node()'/>
  </xsl:template>

  <!-- Fix the list of "subsidiary sections" on a few pages like 
    document-hierarchy-diagrams.  I think they look pretty bad the way they
    were. -->
  <xsl:template match='h:h3[.="Subsidiary sections:"]'>
    <xsl:copy>
      <xsl:apply-templates select='@*|node()'/>
    </xsl:copy>
    <ul>
      <xsl:for-each select="following-sibling::h:h4">
        <li>
          <xsl:apply-templates select='*'/>
        </li>
      </xsl:for-each>
    </ul>
  </xsl:template>

  <xsl:template match='h:h4[preceding-sibling::h:h3[.="Subsidiary sections:"]]'/>

  
  <!-- Drop the pagefooter for each entry.  We'll preserve the index.html
    footer and use it everywhere -->
  <xsl:template match='h:div[@class="pagefooter"]'/>

  <!-- We're not using frames, so get rid of @target="main" -->
  <xsl:template match='h:a/@target[.="main"]'/>
  
  <!-- Get rid of some silly classes -->
  <xsl:template match='h:p/@class[.="para"]'/>
  <xsl:template match='h:ul/@class[.="bullist"]'/>
  <xsl:template match='h:h3/@class[.="header"]'/>
  <xsl:template match='h:h4/@class[.="header"]'/>
  

  <xsl:template match='@*|*|text()'>
    <xsl:copy>
      <xsl:apply-templates select='@*|*|text()'/>
    </xsl:copy>
  </xsl:template>
</xsl:stylesheet>