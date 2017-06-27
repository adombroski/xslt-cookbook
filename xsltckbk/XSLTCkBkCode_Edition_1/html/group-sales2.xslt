<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sales="sales">
  
  <sales:region code="NE" name="North East"/>
  <sales:region code="NC" name="North Central"/>
  <sales:region code="NW" name="North West"/>
  <sales:region code="SE" name="South East"/>
  <sales:region code="SC" name="South Central"/>
  <sales:region code="SW" name="South West"/>

 <xsl:variable name="products" select="/sales/product"/>
  
  <xsl:output method="html"/>
    
  <xsl:template match="sales">
    <html>
      <head>
        <title>Sales by Region</title>
      </head>
      <body>
        <h1>Sales by Region</h1>
        <table border="1" cellpadding="3">
          <tbody>
            <tr>
              <th>SKU</th>
              <th>Sales</th>
            </tr>
            <xsl:for-each select="document('')/*/sales:region">
              <tr >
                <th colspan="2"><xsl:value-of select="@name"/> Sales</th>
              </tr>
              <xsl:call-template name="group-region">
                <xsl:with-param name="region" select="@code"/>
              </xsl:call-template>
            </xsl:for-each>
          </tbody>
        </table>
      </body>
    </html>
  </xsl:template>


  <xsl:template name="group-region">
    <xsl:param name="region"/>
        <xsl:apply-templates select="$products[@region=$region]"/>
        <tr style="font-weight:bold">
          <td >Total</td>
          <td align="right"><xsl:value-of select="format-number(sum($products[@region=$region]/@sales),'#.00')"/></td>
        </tr>
  </xsl:template>

  
  <xsl:template match="product">
    <tr>
      <td><xsl:value-of select="@sku"/></td>
      <td align="right"><xsl:value-of select="@sales"/></td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>
