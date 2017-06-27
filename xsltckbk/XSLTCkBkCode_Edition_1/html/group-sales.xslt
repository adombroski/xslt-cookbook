<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
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
          <xsl:call-template name="group-region">
            <xsl:with-param name="region" select=" 'NE' "/>
            <xsl:with-param name="title" select="'North East Sales'"/>
          </xsl:call-template>
          <xsl:call-template name="group-region">
            <xsl:with-param name="region" select=" 'NW' "/>
            <xsl:with-param name="title" select="'North West Sales'"/>
          </xsl:call-template>
          <xsl:call-template name="group-region">
            <xsl:with-param name="region" select=" 'NC' "/>
            <xsl:with-param name="title" select="'North Central Sales'"/>
          </xsl:call-template>
          <xsl:call-template name="group-region">
            <xsl:with-param name="region" select=" 'SE' "/>
            <xsl:with-param name="title" select="'South East Sales'"/>
          </xsl:call-template>
          <xsl:call-template name="group-region">
            <xsl:with-param name="region" select=" 'SC' "/>
            <xsl:with-param name="title" select="'South Central Sales'"/>
          </xsl:call-template>
          <xsl:call-template name="group-region">
            <xsl:with-param name="region" select=" 'SW' "/>
            <xsl:with-param name="title" select="'South West Sales'"/>
          </xsl:call-template>
        </tbody>
      </table>
    </body>
  </html>
</xsl:template>


<xsl:template name="group-region">
    <xsl:param name="region"/>
    <xsl:param name="title"/>
    <xsl:variable name="products" select="product[@region = $region]" />
    <tr>
      <th colspan="2"><xsl:value-of select="$title" /></th>
    </tr>
    <xsl:apply-templates select="$products"/>
    <tr style="font-weight:bold">
      <td >Total</td>
      <td align="right"><xsl:value-of select="format-number(sum($products/@sales),'#.00')"/></td>
     </tr>
  </xsl:template>
  
  <xsl:template match="product">
    <tr>
      <td><xsl:value-of select="@sku"/></td>
      <td align="right"><xsl:value-of select="@sales"/></td>
    </tr>
  </xsl:template>
  
</xsl:stylesheet>
