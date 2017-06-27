<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text"/>

<xsl:template match="salesBySalesperson">
	<xsl:text>Total commision = </xsl:text>
	<xsl:call-template name="total-commision">
		<xsl:with-param name="salespeople" select="*"/>
	</xsl:call-template>
</xsl:template>

<!-- By default salespeople get 2% commsison and no base salary -->
<xsl:template match="salesperson" mode="commision">
	<xsl:value-of select="0.02 * sum(product/@totalSales)"/>
</xsl:template>

<!-- salespeople with seniority > 4 get $10000.00 base + 0.5% commsison -->
<xsl:template match="salesperson[@seniority > 4]" mode="commision" priority="1">
	<xsl:value-of select="10000.00 + 0.05 * sum(product/@totalSales)"/>
</xsl:template>

<!-- salespeople with seniority > 8 get (seniority * $2000.00) base + 0.8% commsison -->
<xsl:template match="salesperson[@seniority > 8]" mode="commision" priority="2">
	<xsl:value-of select="@seniority * 2000.00 + 0.08 * 
		sum(product/@totalSales)"/>
</xsl:template>
	
<xsl:template name="total-commision">
	<xsl:param name="salespeople"/>
	<xsl:choose>
	  <xsl:when test="$salespeople">
	    <xsl:variable name="first">
		<xsl:apply-templates select="$salespeople[1]" mode="commision"/>
	    </xsl:variable>
	    <xsl:variable name="rest">
		<xsl:call-template name="total-commision">
		  <xsl:with-param name="salespeople" 
		    select="$salespeople[position()!=1]"/>
		</xsl:call-template>
	    </xsl:variable>
	    <xsl:value-of select="$first + $rest"/>
	  </xsl:when>
	  <xsl:otherwise>0</xsl:otherwise>
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>
