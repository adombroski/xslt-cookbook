<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sales="sales">
  
  <xsl:output method="html"/>

  <xsl:key name="region-key" match="product" use="@region"/>
  
 <xsl:variable name="products" select="/sales/product"/>
      
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
            <xsl:variable name="unique-regions" 
                                 select="/sales/product[generate-id(.) = generate-id(key('region-key', @region))]/@region"/>
            <xsl:for-each select="$unique-regions">
              <tr >
                <th colspan="2"><xsl:value-of select="."/> Sales</th>
              </tr>
              <xsl:call-template name="group-region">
                <xsl:with-param name="region" select="."/>
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
