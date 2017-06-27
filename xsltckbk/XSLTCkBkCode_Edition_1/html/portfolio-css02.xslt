<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html"/>

  <xsl:attribute-set name="gain-loss">
    <xsl:attribute name="class">
      <xsl:apply-templates select="." mode="gain-loss"/>
    </xsl:attribute>
  </xsl:attribute-set> 	

<xsl:template match="stock" mode="gain-loss">
    <xsl:choose>
      <xsl:when test="(current - paid) * qty >= 0">gain</xsl:when>
      <xsl:otherwise>loss</xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="property" mode="gain-loss">
    <xsl:choose>
      <xsl:when test="appriasal - paid  >= 0">gain</xsl:when>
      <xsl:otherwise>loss</xsl:otherwise>
    </xsl:choose>
</xsl:template>


<xsl:template match="portfolio">
    <html>
     <head>
      <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"/>
      <title>My Portfolio</title>
      <link  rel="stylesheet"  type="text/css"  href="portfolio.css"/>
     </head>
    
     <body bgcolor="#FFFFFF" text="#000000">
      <h1>Portfolio</h1>
      <h2>Stocks</h2>
      <table border="1" cellpadding="2">
        <tbody>
          <tr>
            <th>Symbol</th>
            <th>Current</th>
            <th>Paid</th>
            <th>Qty</th>
            <th>Gain/Loss</th>
          </tr>
          <xsl:apply-templates select="stock"/>
        </tbody>
      </table>

      <h2>Real Estate</h2>
      <table border="1" cellpadding="2">
        <tbody>
          <tr>
            <th>Location</th>
            <th>Cost</th>
            <th>Value</th>
            <th>Gain/Loss</th>
          </tr>
          <xsl:apply-templates select="property"/>
        </tbody>
      </table>
     </body>
    </html>
</xsl:template>

<xsl:template match="stock">
  <tr>
    <td><xsl:value-of select="symbol"/></td>
    <td align="right"><xsl:value-of select="current"/></td>
    <td align="right"><xsl:value-of select="paid"/></td>
    <td align="right"><xsl:value-of select="qty"/></td>
    <td align="right" xsl:use-attribute-sets="gain-loss"><xsl:value-of select="format-number((current - paid) * qty, '#,##0.00')"/></td>
  </tr>
</xsl:template>	

<xsl:template match="property">
  <tr>
    <td><xsl:value-of select="address"/></td>
    <td align="right"><xsl:value-of select="paid"/></td>
    <td align="right"><xsl:value-of select="appriasal"/></td>
    <td align="right" xsl:use-attribute-sets="gain-loss"><xsl:value-of select="format-number(appriasal - paid, '#,##0.00')"/></td>
  </tr>
</xsl:template>	

</xsl:stylesheet>
