<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
	<people>
		<xsl:call-template name="generate">
			<xsl:with-param name="count" select="100000"/>
		</xsl:call-template>
	</people>
</xsl:template>

<xsl:template name="generate">
	<xsl:param name="count"/>
	<xsl:choose>
		<xsl:when test="$count &lt; 1">
			<person name="John Smith" age="32">
				<address line1="123 Main St." line2="Suite 1" city="somewhere" state="NY" zip="11355"/>
			</person>
		</xsl:when>
		<xsl:otherwise>
			<person name="Will Johns" age="24">
				<address line1="456 Broadway" line2="Suite 2" city="anywhere" state="NJ" zip="12345"/>
			</person>
			<xsl:call-template name="generate">
				<xsl:with-param name="count" select="$count - 1"/>
			</xsl:call-template>
		</xsl:otherwise>		
	</xsl:choose>
</xsl:template>

</xsl:stylesheet>

