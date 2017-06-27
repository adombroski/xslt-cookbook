<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
		<grossSales>
			<built-in>
				<xsl:value-of select="sum(//product/@totalSales)"/>
			</built-in>
			<recursive>
				<xsl:call-template name="sum">
					<xsl:with-param name="list-of-numbers" select="//product/@totalSales"/>
				</xsl:call-template>
			</recursive>
		</grossSales>
	</xsl:template>
	
	<xsl:template name="sum">
		<xsl:param name="list-of-numbers"/>
		<xsl:param name="partial-sum" select="0"/>
		<xsl:choose>
			<xsl:when test="count($list-of-numbers)=0">
				<xsl:value-of select="$partial-sum"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:variable name="num" select="$list-of-numbers[1]"/>
				<xsl:call-template name="sum">
					<xsl:with-param name="list-of-numbers" select="$list-of-numbers[position()>1]"/>
					<xsl:with-param name="partial-sum" select="$num+$partial-sum"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template> 
	
</xsl:stylesheet>
