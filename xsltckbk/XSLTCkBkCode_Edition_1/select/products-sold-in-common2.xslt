<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>

  <xsl:key name="sp_key" match="salesperson" use="product/@sku"/>
  	
	<xsl:template match="/">
		<xsl:call-template name="process-products">
			<xsl:with-param name="products" select="//product[not(@sku=preceding::product/@sku)]"/>
		</xsl:call-template> 
	</xsl:template>
	

  <xsl:template name="process-products">
    <xsl:param name="products" />
    <xsl:if test="$products">
      <xsl:variable name="product1" select="$products[1]" />
      <xsl:for-each select="$products[position() > 1]">
        <xsl:variable name="product2" select="." />
        <xsl:call-template name="show-products-sold-in-common">
          <xsl:with-param name="product1" select="$product1" />
          <xsl:with-param name="product2" select="$product2" />
        </xsl:call-template>
      </xsl:for-each>
      <xsl:call-template name="process-products">
        <xsl:with-param name="products" select="$products[position() > 1]"/>
      </xsl:call-template> 
    </xsl:if>
  </xsl:template>
	
  <xsl:template name="show-products-sold-in-common">
  	<xsl:param name="product1"/>
  	<xsl:param name="product2"/>
  	<xsl:variable name="who-sold-p1"  select="key('sp_key',$product1/@sku)"/>
  	<xsl:variable name="who-sold-p2"  select="key('sp_key',$product2/@sku)"/>
  	
  	<xsl:if test="count($who-sold-p1|$who-sold-p2) = count($who-sold-p1)">
  		<xsl:text>All the salespeople who sold product </xsl:text>
  		<xsl:value-of select="$product2/@sku"/>
  		<xsl:text> also sold product </xsl:text>
  		<xsl:value-of select="$product1/@sku"/>
  		<xsl:if test="count($who-sold-p1) = count($who-sold-p2)">
  			<xsl:text> and visa versa</xsl:text>
  		</xsl:if>
  		<xsl:text>.&#xa;</xsl:text>
  	</xsl:if>
  </xsl:template>
	
</xsl:stylesheet>
