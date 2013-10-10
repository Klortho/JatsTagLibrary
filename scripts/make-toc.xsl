<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns='http://www.w3.org/1999/xhtml'
                xmlns:h='http://www.w3.org/1999/xhtml'
                xmlns:f='function-namespace'
                exclude-result-prefixes="xs f"
                version="2.0">

  <xsl:output method="xml" indent='yes'/>

  <xsl:variable name='baseUri' select='base-uri(/)'/>
  <xsl:variable name='dir' select='replace($baseUri, "/[^/]*$", "")'/>
  <xsl:variable name='xref' 
    select='document(concat($dir, "/", "toc-xref.xml"))'/>

  <xsl:template match='/'>
    <ul id='categories'>
      
      <xsl:apply-templates 
        select='h:html/h:body/h:div[@class="toc"]/
                h:div[@class="toc-entry" and h:a[@target="main"]]'>
        <xsl:with-param name="level" select="1"/>
      </xsl:apply-templates>
      
    </ul>
  </xsl:template>


  <xsl:template match='h:div[@class="toc-entry"]'>
    <xsl:param name="level"/>
    <xsl:variable name='hash' select='substring-before(h:a[@target="main"]/@href, ".html")'/>
    <xsl:variable name='xrefItem' select='$xref//item[@hash=$hash]'/>
    <xsl:if test='not($xrefItem)'>
      <xsl:message terminate="yes">
        <xsl:text>ERROR, xrefItem not found for '</xsl:text>
        <xsl:value-of select='$hash'/>
        <xsl:text>'.</xsl:text>
      </xsl:message>
    </xsl:if>

    <xsl:variable name='slug' select='$xrefItem/@slug'/>
    <xsl:variable name='title' select='$xrefItem/@title'/>
    <xsl:variable name='liClass'>
      <xsl:choose>
        <xsl:when test="$level=1">
          <xsl:text>top-cat</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:choose>
            <xsl:when test='following-sibling::h:div[1]/@class="toc-section"'>
              <xsl:text>sub-cat</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>entry</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name='spanClass'>
      <xsl:choose>
        <xsl:when test="$liClass='top-cat'">
          <xsl:text>top-cat-name</xsl:text>
        </xsl:when>
        <xsl:when test="$liClass='sub-cat'">
          <xsl:text>sub-cat-name</xsl:text>
        </xsl:when>
        <xsl:when test="$liClass='entry'">
          <xsl:text>title</xsl:text>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
        
    <li class='{$liClass}' data-slug='{$slug}'>
      <span class='{$spanClass}'>
        <xsl:value-of select='$title'/>
      </span>
      <xsl:if test='following-sibling::h:div[1]/@class="toc-section"'>
        <ul class='entries'>
          <xsl:apply-templates select='following-sibling::h:div[1]/h:div'>
            <xsl:with-param name="level" select='$level + 1'/>
          </xsl:apply-templates>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>


  <xsl:template match='@*|node()'/>  
  

</xsl:stylesheet>