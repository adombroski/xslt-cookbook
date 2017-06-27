<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="html" />

<xsl:template match="/">
  <html>
    <head>
      <title>Area of Shapes</title>
    </head>
    <body>
      <h1>Area of Shapes</h1>
      <table cellpadding="2" border="1">
        <tbody>
          <tr>
            <th>Shape</th>
            <th>Shape Id</th>
            <th>Area</th>
          </tr>
          <xsl:apply-templates/>
        </tbody>
      </table>
    </body>
  </html>
</xsl:template>

<xsl:template match="shape">
  <tr>
    <td><xsl:value-of select="@kind"/></td>
    <td><xsl:value-of select="@id"/></td>
    <xsl:variable name="area">
      <xsl:apply-templates select="." mode="area"/>
    </xsl:variable> 
    <td align="right"><xsl:value-of select="format-number($area,'#.000')"/></td>
  </tr>  
</xsl:template>
	
<xsl:template match="shape[@kind='triangle']" mode="area">
  <xsl:value-of select="@base * @height"/>
</xsl:template>

<xsl:template match="shape[@kind='square']" mode="area">
  <xsl:value-of select="@side * @side"/> 
</xsl:template>

<xsl:template match="shape[@kind='rectangle']" mode="area">
  <xsl:value-of select="@width * @height"/>
</xsl:template>

<xsl:template match="shape[@kind='circle']" mode="area">
  <xsl:value-of select="3.1415 * @radius * @radius"/> 
</xsl:template>

</xsl:stylesheet>
