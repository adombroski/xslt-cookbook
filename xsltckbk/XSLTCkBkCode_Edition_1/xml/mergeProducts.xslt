<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	
<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:key name="sales_key" match="salesperson" use="product/@sku"/>

<xsl:variable name="products" select="//product"/>
<xsl:variable name="unique-products" select="$products[not(@sku = preceding::product/@sku)]"/>

<xsl:template match="/">
  <salesByProduct>
    <xsl:for-each select="$unique-products">
      <xsl:variable name="sku" select="@sku"/>
      <xsl:copy> 
        <xsl:copy-of select="$sku"/>
        <xsl:attribute name="totalSales">
          <xsl:value-of select="sum($products[@sku=$sku]/@totalSales)"/>
        </xsl:attribute>
        <xsl:for-each select="key('sales_key',$sku)">
          <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:attribute name="sold">
              <xsl:value-of select="product[@sku=$sku]/@totalSales"/>
            </xsl:attribute>
          </xsl:copy>
        </xsl:for-each>
      </xsl:copy>
    </xsl:for-each>
  </salesByProduct>
</xsl:template>

</xsl:stylesheet>
