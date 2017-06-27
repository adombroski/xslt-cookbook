<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html"/>

<xsl:param name="URL"/>

<xsl:template match="/">
  <xsl:apply-templates select="*" mode="index"/>
  <xsl:apply-templates select="*" mode="content"/>
</xsl:template>

<!-- ============================================================== -->
<!--                           Create index.html  (mode = "index")                                           -->
<!-- ============================================================== -->
<xsl:template match="salesBySalesperson" mode="index">
  <!-- Non-standard xsl: saxon:document! -->
  <xsl:document href="index.html">	
    <html>
     <head>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
     </head>
    
     <body bgcolor="#FFFFFF" text="#000000">
      <h1>Sales By Salesperson</h1>
      <xsl:apply-templates mode="index"/>
     </body>
    </html>
  </xsl:document>
</xsl:template>

<xsl:template match="salesperson" mode="index">
  <h2>
    <a href="{concat($URL,@name,'.html')}">
      <xsl:value-of select="@name"/>
    </a>
  </h2>
</xsl:template>

<!-- ============================================================== -->
<!--                           Create @name.html  (mode = "content")                                    -->
<!-- ============================================================== -->


<xsl:template match="salesperson" mode="content">
  <xsl:document href="{concat(@name,'.html')}">	
    <html>
     <head>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
     </head>
    
     <body bgcolor="#FFFFFF" text="#000000">
      <h1><xsl:value-of select="@name"/> Sales</h1>
      <table border="1" cellpadding="3">
        <tbody >
          <tr>
            <th>SKU</th>
            <th>Sales (in US $)</th>
          </tr>
          <xsl:apply-templates mode="content"/>
        </tbody>
      </table>
      <h2><a href="{concat($URL,'index.html')}">Home</a></h2>
     </body>
    </html>
  </xsl:document>
</xsl:template>

<xsl:template match="product" mode="content">
    <tr>
      <td><xsl:value-of select="@sku"/></td>
      <td><xsl:value-of select="@totalSales"/></td>
    </tr>
    
</xsl:template>

</xsl:stylesheet>
