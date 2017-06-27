<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>

  <!-- Variables defining various style components -->
  <xsl:variable name="standard-font-family" select=" 'font-family: Times serif; font-weight' "/>

  <xsl:variable name="chapter-label-font-size" select=" 'font-size : 48pt' "/>
  <xsl:variable name="chapter-title-font-size" select=" 'font-size : 24pt' "/>
  <xsl:variable name="epigraph-font-size" select=" 'font-size : 10pt' "/>
  <xsl:variable name="sect1-font-size" select=" 'font-size : 18pt' "/>
  <xsl:variable name="sect2-font-size" select=" 'font-size : 14pt' "/>
  <xsl:variable name="normal-font-size" select=" 'font-size : 12pt' "/>

  <xsl:variable name="normal-text-color" select=" 'color: black' "/>
  <xsl:variable name="chapter-title-color" select=" 'color: red' "/>
  
  <xsl:variable name="epigraph-padding" select=" 'padding-top:4; padding-bottom:4' "/>
  
  <xsl:variable name="epigraph-common-style" select="concat($standard-font-family,'; ', $epigraph-font-size, '; ', $epigraph-padding, '; ',$normal-text-color)"/>
  <xsl:variable name="sect-common-style" select="concat($standard-font-family,'; font-weight: bold', '; ',$normal-text-color)"/>

  <!-- Attribute sets -->
  <xsl:attribute-set name="chapter-align">
    <xsl:attribute name="align">right</xsl:attribute> 
  </xsl:attribute-set>

  <xsl:attribute-set name="normal-align">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="chapter-label" use-attribute-sets="chapter-align">
    <xsl:attribute name="style">
      <xsl:value-of select="$standard-font-family"/>; <xsl:value-of select="$chapter-label-font-size"/>; <xsl:value-of select="$chapter-title-color"/>
      <xsl:text>; padding-bottom:10; font-weight: bold</xsl:text>
    </xsl:attribute> 
  </xsl:attribute-set>  

  <xsl:attribute-set name="chapter-title" use-attribute-sets="chapter-align">
    <xsl:attribute name="style">
      <xsl:value-of select="$standard-font-family"/>; <xsl:value-of select="$chapter-title-font-size"/>; <xsl:value-of select="$chapter-title-color"/>
      <xsl:text>; padding-bottom:150; font-weight: bold</xsl:text>
    </xsl:attribute> 
  </xsl:attribute-set>  

  <xsl:attribute-set name="epigraph-para" use-attribute-sets="chapter-align">
    <xsl:attribute name="style">
      <xsl:value-of select="$epigraph-common-style"/><xsl:text>; font-style: italic</xsl:text>
    </xsl:attribute> 
  </xsl:attribute-set>

  <xsl:attribute-set name="epigraph-attribution" use-attribute-sets="chapter-align">
    <xsl:attribute name="style">
      <xsl:value-of select="$epigraph-common-style"/>
    </xsl:attribute> 
  </xsl:attribute-set>

  <xsl:attribute-set name="sect1">
    <xsl:attribute name="align">left</xsl:attribute> 
    <xsl:attribute name="style">
      <xsl:value-of select="$sect-common-style"/>; <xsl:value-of select="$sect1-font-size"/>
    </xsl:attribute> 
  </xsl:attribute-set>

  <xsl:attribute-set name="sect2">
    <xsl:attribute name="align">left</xsl:attribute> 
    <xsl:attribute name="style">
      <xsl:value-of select="$sect-common-style"/>; <xsl:value-of select="$sect2-font-size"/>
    </xsl:attribute> 
  </xsl:attribute-set>

  <xsl:attribute-set name="normal">
    <xsl:attribute name="align">left</xsl:attribute> 
    <xsl:attribute name="style">
      <xsl:value-of select="$standard-font-family"/>; <xsl:value-of select="$normal-font-size"/>; <xsl:value-of select="$normal-text-color"/>
    </xsl:attribute> 
  </xsl:attribute-set>


  <!-- Templates -->
  <xsl:template match="/">
    <html>
      <head>
        <xsl:apply-templates mode="head"/>
        <xsl:call-template name="extra-head-meta-data"/>
      </head>
      <body style="margin-left:100;margin-right:100;margin-top:50;margin-bottom:50">
        <xsl:apply-templates/> 
        <xsl:apply-templates select="chapter/chapterinfo/*" mode="copyright"/> 
      </body>
    </html>
  
  </xsl:template>

  <!-- Head -->
  
  <xsl:template match="chapter/title" mode="head">
        <title><xsl:value-of select="."/></title>
  </xsl:template>

  <xsl:template match="author" mode="head">
        <meta name="author" content="{concat(firstname,' ', surname)}"/>
  </xsl:template>

  <xsl:template match="copyright" mode="head">
        <meta name="copyright" content="{concat(holder,' ',year)}"/>
  </xsl:template>

  <xsl:template match="text()" mode="head"/>

  <!--Overrid in importing styleshhet if necessary -->
  <xsl:template name="extra-head-meta-data"/>
  
<!-- Body -->
  
  <xsl:template match="chapter">
    <div xsl:use-attribute-sets="chapter-label">
      <xsl:value-of select="@label"/>
    </div>
    <xsl:apply-templates/>
  </xsl:template>  

  <xsl:template match="chapter/title">
    <div xsl:use-attribute-sets="chapter-title">
      <xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="epigraph/para">
    <div xsl:use-attribute-sets="epigraph-para">
      <xsl:value-of select="."/>
    </div>
  </xsl:template>

  <xsl:template match="epigraph/attribution">
    <div xsl:use-attribute-sets="epigraph-attribution">
      <xsl:value-of select="."/>
    </div>
  </xsl:template>
  
  
  <xsl:template match="sect1">
    <h1 xsl:use-attribute-sets="sect1">
      <xsl:value-of select="title"/>
    </h1>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect2">
    <h2 xsl:use-attribute-sets="sect2">
    <xsl:value-of select="title"/>
    </h2>
     <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="para">
    <p xsl:use-attribute-sets="normal">
      <xsl:value-of select="."/>
    </p>
  </xsl:template>

  <xsl:template match="text()"/>

<xsl:template match="copyright" mode="copyright">
  <div style="font-size : 10pt; font-family: Times serif; padding-top : 100">
    <xsl:text>Copyright </xsl:text>
    <xsl:value-of select="holder"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="year"/>
    <xsl:text>. All rights reserved.</xsl:text>
  </div>
</xsl:template>   

<xsl:template match="*" mode="copyright"/>

</xsl:stylesheet>
