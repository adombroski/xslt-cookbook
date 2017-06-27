<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>
	
	<xsl:template match="/">
		<xsl:call-template name="process-products">
			<xsl:with-param name="products" select="//product[not(@sku=preceding::product/@sku)]"/>
		</xsl:call-template> 
	</xsl:template>
	

	<xsl:template name="process-products">
		<xsl:param name="products"/>
		<xsl:for-each select="$products">
			<xsl:variable name="product1" select="."/>
			<xsl:for-each select="$products">
				<xsl:variable name="product2" select="."/>
				<xsl:if test="generate-id($product1) != generate-id($product2)">
					<xsl:call-template name="show-products-sold-in-common">
						<xsl:with-param name="product1" select="$product1"/>
						<xsl:with-param name="product2" select="$product2"/>
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
		</xsl:for-each>
	</xsl:template>
	
	<xsl:template name="show-products-sold-in-common">
		<xsl:param name="product1"/>
		<xsl:param name="product2"/>
		<xsl:variable name="who-sold-p1"  select="//salesperson[product/@sku = $product1/@sku]"/>
		<xsl:variable name="who-sold-p2"  select="//salesperson[product/@sku = $product2/@sku]"/>
		
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
