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
      <xsl:call-template name="area"/>
    </xsl:variable> 
    <td align="right"><xsl:value-of select="format-number($area,'#.000')"/></td>
  </tr>  
</xsl:template>
	
<xsl:template name="area">
  <xsl:choose>
  
    <xsl:when test="@kind='triangle' ">
      <xsl:value-of select="@base * @height"/>
    </xsl:when>
    
    <xsl:when test="@kind='square' " >
      <xsl:value-of select="@side * @side"/> 
    </xsl:when>
    
    <xsl:when test="@kind='rectangle' ">
      <xsl:value-of select="@width * @height"/>
    </xsl:when>
    
    <xsl:when test="@kind='circle' ">
      <xsl:value-of select="3.1415 * @radius * @radius"/> 
    </xsl:when>
    
  </xsl:choose>
  
</xsl:template>

</xsl:stylesheet>
