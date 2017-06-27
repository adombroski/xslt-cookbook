<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html"/>
  
  <xsl:template match="/">
    <html>
      <head>
        <title><xsl:value-of select="chapter/title"/></title>
      </head>
      <body>
        <xsl:apply-templates/> 
      </body>
    </html>
  
  </xsl:template>

  <xsl:template match="chapter">
    <div align="right" style="font-size : 48pt; font-family: Times serif; font-weight : bold; padding-bottom:5"><xsl:value-of select="@label"/></div>
    <div align="right" style="font-size : 24pt; font-family: Times serif; padding-bottom:15"><xsl:value-of select="title"/></div>
    <xsl:apply-templates/>
  </xsl:template>  
  
  <xsl:template match="sect1">
    <h1 style="font-size : 18pt; font-family: Times serif; font-weight : bold"><xsl:value-of select="title"/></h1>
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="sect2">
    <h2 style="font-size : 14pt; font-family: Times serif; font-weight : bold"><xsl:value-of select="title"/></h2>
  </xsl:template>
  
  <xsl:template match="para">
    <p style="font-size : 12pt; font-family: Times serif">
      <xsl:apply-templates/>
    </p>
  </xsl:template>

</xsl:stylesheet>
