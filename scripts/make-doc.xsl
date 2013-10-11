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

  
  
  <xsl:template match='h:html'>
    <xsl:apply-templates select='h:body'/>
  </xsl:template>
  
  <xsl:template match='h:body'>
    <div id='entry-wrapper'>
      <xsl:choose>
        <!-- Example:  How To Use -->
        <xsl:when test='h:h1[@class="sectiontitle"]'>
          <xsl:variable name='header' select='h:h1[@class="sectiontitle"]'/>
          <div id='entry-header'>
            <h1>
              <xsl:copy-of select='$header/node()'/>
            </h1>
          </div>
          <xsl:call-template name='entry-content'>
            <xsl:with-param name="content" 
              select='$header/following-sibling::*'/>
          </xsl:call-template>
        </xsl:when>

        <!-- Example:  General Introduction -->
        <xsl:when test='h:div[@class="intro"]/h:h1[@class="header"]'>
          <xsl:variable name='header' select='h:div[@class="intro"]/h:h1[@class="header"]'/>
          <div id='entry-header'>
            <h1>
              <xsl:copy-of select='$header/node()'/>
            </h1>
          </div>
          <xsl:call-template name='entry-content'>
            <xsl:with-param name="content" 
              select='$header/following-sibling::*'/>
          </xsl:call-template>
        </xsl:when>
        
        <xsl:when test='h:div[@class="header"]'>
          <xsl:variable name='header' select='h:div[@class="header"]'/>
          <xsl:variable name='def' select='$header/following-sibling::h:div[@class="definition"]'/>
          
          <div id='entry-header'>
            <h1>
              <xsl:copy-of select='$header/h:h1[@class="elementtag"]/node()'/>
              <xsl:value-of select='" "'/>
              <xsl:copy-of select='$header/h:h1[@class="elementname"]/node()'/>
            </h1>
            <xsl:copy-of select='$def/*'/>
          </div>
          <xsl:call-template name='entry-content'>
            <xsl:with-param name='content' select='$def/following-sibling::*'/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>
    </div>
  </xsl:template>
  
  <xsl:template name='entry-content'>
    <xsl:param name='content'/>
    <ul id='entries'>
      <li class='entry'>
        <div class='longdesc'>
          <xsl:copy-of select='$content'/>
        </div>
      </li>
    </ul>
  </xsl:template>
</xsl:stylesheet>