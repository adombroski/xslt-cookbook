<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:saxon="http://icl.com/saxon" 
 extension-element-prefixes="saxon">

<xsl:output method="html"/>

<xsl:template match="/">
  <xsl:apply-templates select="*" mode="index"/>
  <xsl:apply-templates select="*" mode="content"/>
</xsl:template>

<!-- ============================================================== -->
<!--            Create index.html  (mode = "index")                 -->
<!-- ============================================================== -->
<xsl:template match="salesBySalesperson" mode="index">
  <!-- Non-standard xsl: saxon:document! -->
  <saxon:output href="index.html" >	
    <html>
     <head>
	    <title>Sales By Salesperson Index</title>
	  </head>
    
     <body bgcolor="#FFFFFF" text="#000000">
      <h1>Sales By Salesperson</h1>
      <xsl:apply-templates mode="index"/>
     </body>
    </html>
  </saxon:output>
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
  <saxon:output href="{concat(@name,'.html')}">	
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
  </saxon:output>
</xsl:template>

<xsl:template match="product" mode="content">
    <li><xsl:value-of select="@sku"/>&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;&#xa0;$<xsl:value-of select="@totalSales"/></li>
</xsl:template>

</xsl:stylesheet>
