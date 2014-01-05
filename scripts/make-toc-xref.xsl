<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:h='http://www.w3.org/1999/xhtml'
  xmlns:f='http://ncbi.nlm.nih.gov/ns/functions'
  exclude-result-prefixes="xs f"
  version="2.0">
  
  <xsl:output method="xml" indent='yes'/>
  
  <xsl:template match='/'>
    <xsl:variable name='preprocessed'>
      <tocXref>
        <xsl:apply-templates select='/h:html/h:body/h:div[@class="toc"]/h:div[@class="toc-entry"]'/>
      </tocXref>
    </xsl:variable>
    <!-- 
      Take a pass over the results that we generated, to make sure that all the slugs are 
      unique.
    -->
    <xsl:apply-templates select='$preprocessed' mode='unique-slugs'/>
  </xsl:template>

  <xsl:template match='@*|node()' mode='unique-slugs'>
    <xsl:copy>
      <xsl:apply-templates select='@*|node()' mode='unique-slugs'/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match='@slug' mode='unique-slugs'>
    <xsl:variable name='this-slug' select='string(.)'/>
    <xsl:choose>
      <xsl:when test="preceding::item[@slug = $this-slug]">
        <xsl:attribute name='slug'>
          <xsl:value-of select='concat($this-slug, "-",
            count(preceding::item[@slug = $this-slug]))'/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 
    Template for a toc-entry.
  -->
  <xsl:template match='h:div[@class="toc-entry"]'>
    <xsl:param name='slug-prefix' />
    <xsl:variable name='title'>
      <xsl:choose>
        <xsl:when test="$slug-prefix = 'attr'">
          <xsl:value-of select='concat("@", normalize-space(.))'/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space(.)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name='hash' select='substring-before(h:a[@target="main"]/@href, ".html")'/>
    <xsl:variable name='slug'>
      <xsl:choose>
        <xsl:when test='$slug-prefix != ""'>
          <xsl:value-of select='concat($slug-prefix, "-", f:stripSpecialChars($title))'/>
        </xsl:when>
        <xsl:when test='$title = "Elements"'>
          <xsl:value-of select='"elements"'/>
        </xsl:when>
        <xsl:when test='$title = "Attributes"'>
          <xsl:value-of select='"attributes"'/>
        </xsl:when>
        <xsl:when test='$title = "Parameter Entities"'>
          <xsl:value-of select='"parameter-entities"'/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select='f:makeSlug($title, 3)'/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    
    <item hash='{$hash}' 
          title='{$title}' 
          slug='{$slug}'/>

    <xsl:apply-templates 
      select='following-sibling::h:div[1][@class="toc-section"]/h:div[@class="toc-entry"]'>
      <xsl:with-param name="slug-prefix">
        <xsl:choose>
          <xsl:when test='$slug = "elements"'>
            <xsl:value-of select='"elem"'/>
          </xsl:when>
          <xsl:when test='$slug = "attributes"'>
            <xsl:value-of select='"attr"'/>
          </xsl:when>
          <xsl:when test='$slug = "parameter-entities"'>
            <xsl:value-of select='"pe"'/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select='""'/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:apply-templates>
  </xsl:template>

  <!-- 
    f:stripSpecialChars($s) - simply removes any punctuation characters from
    the string.  Used to extract the words from element ("<abbrev>") or 
    param-entity ("%abbrev-atts;") entries.
  -->
  <xsl:function name='f:stripSpecialChars'>
    <xsl:param name='s'/>
    
    <xsl:variable name='s2' select='replace($s, "[&lt;&gt;%;@]", "")'/>
    <!-- Also convert colons to dashes, since colons aren't legal in filenames
      on Windows -->
    <xsl:value-of select='translate($s2, ":", "-")'/>
  </xsl:function>

  <!--
    f:makeSlug($title, $numWords)
  -->
  <xsl:function name='f:makeSlug'>
    <xsl:param name='title'/>
    <xsl:param name='numWords' as='xs:integer'/>
    
    <!-- Get rid of punctuation - convert to spaces -->
    <xsl:variable name='str1' select='replace($title, "\W", " ")'/>
    <!-- Lowercase and normalize spaces -->
    <xsl:variable name='str2' select='lower-case(normalize-space($str1))'/>
    <!-- Convert into a sequence of tokens -->
    <xsl:variable name='seq1' select='tokenize($str2, " ")'/>
    
    <!-- If the first word is a too-common word, drop it -->    
    <xsl:variable name='word1' select='$seq1[1]'/>
    <xsl:variable name='start' 
      select='if ($word1 = "the" or $word1 = "a" or $word1 = "an") 
              then 2 else 1'/>
    <xsl:variable name='end' select='$start + $numWords'/>
    
    <xsl:variable name='seq2' 
      select='$seq1[position() >= $start and position() &lt; $end]'/>

    <xsl:value-of select='string-join($seq2, "-")'/>
  </xsl:function>

</xsl:stylesheet>