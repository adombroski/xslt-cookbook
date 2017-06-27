<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <xsl:apply-templates mode="head"/>
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

<!-- Body -->
  
  <xsl:template match="chapter">
    <div align="right" style="font-size : 48pt; font-family: Times serif; font-weight : bold; padding-bottom:10; color:red" ><xsl:value-of select="@label"/></div>
    <xsl:apply-templates/>
  </xsl:template>  

  <xsl:template match="chapter/title">
    <div align="right" style="font-size : 24pt; font-family: Times serif; padding-bottom:150; color:red"><xsl:value-of select="."/></div>
  </xsl:template>

  <xsl:template match="epigraph/para">
    <div align="right" style="font-size : 10pt; font-family: Times serif; font-style : italic; padding-top:4; padding-bottom:4"><xsl:value-of select="."/></div>
  </xsl:template>

  <xsl:template match="epigraph/attribution">
    <div align="right" style="font-size : 10pt; font-family: Times serif; padding-top:4; padding-bottom:4"><xsl:value-of select="."/></div>
  </xsl:template>
  
  
  <xsl:template match="sect1">
    <h1 style="font-size : 18pt; font-family: Times serif; font-weight : bold">
      <xsl:value-of select="title"/>
    </h1>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect2">
    <h2 style="font-size : 14pt; font-family: Times serif; font-weight : bold">
    <xsl:value-of select="title"/>
    </h2>
     <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="para">
    <p style="font-size : 12pt; font-family: Times serif">
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
