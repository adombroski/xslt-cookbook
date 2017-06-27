<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html"/>
<!--Used to specify which document to output-->
<!--INDEX : creates the index document -->
<!--Sales Person's name : creates the page for that salesperson --> 
<xsl:param name="which" select="'INDEX'"/>

<xsl:template match="/">
  <xsl:choose>
    <xsl:when test="$which='INDEX'">
      <xsl:apply-templates select="*" mode="index"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="*/salesperson[@name = $which]" mode="content"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================== -->
<!--            Create index.html  (mode = "index")                 -->
<!-- ============================================================== -->
<xsl:template match="salesBySalesperson" mode="index">
  <html>
   <head>
    <title>Sales By Salesperson Index</title>
  </head>
  
   <body bgcolor="#FFFFFF" text="#000000">
    <h1>Sales By Salesperson</h1>
    <xsl:apply-templates mode="index"/>
   </body>
  </html>
</xsl:template>

<xsl:template match="salesperson" mode="index">
  <h2>
    <a href="{concat(@name,'.html')}">
      <xsl:value-of select="@name"/>
    </a>
  </h2>
</xsl:template>

<!-- ============================================================== -->
<!--            Create @name.html  (mode = "content")               -->
<!-- ============================================================== -->


<xsl:template match="salesperson" mode="content">
  <html>
   <head>
   <title><xsl:value-of select="@name"/> Sales</title>
  </head>
  
   <body bgcolor="#FFFFFF" text="#000000">
    <h1><xsl:value-of select="@name"/> Sales</h1>
    <ol>
        <xsl:apply-templates mode="content"/>
    </ol>
    <h2><a href="index.html">Home</a></h2>
   </body>
  </html>
</xsl:template>

<xsl:template match="product" mode="content">
    <li><xsl:value-of select="@sku"/>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;$<xsl:value-of select="@totalSales"/></li>
</xsl:template>

</xsl:stylesheet>
