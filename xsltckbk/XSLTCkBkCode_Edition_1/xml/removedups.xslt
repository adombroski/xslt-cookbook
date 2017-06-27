<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xt="http://www.jclark.com/xt" xmlns:exslt="http://exslt.org/common"
	extension-element-prefixes="exslt xt">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
		
	<xsl:template match="root">
		<!-- Sort nodes by the criteria that one uses to define a dup. Store the result in a variable.-->
		
		<xsl:variable name="leaves">
			<xsl:for-each select="leaf">
				<xsl:sort select="@value"/>
				<xsl:copy-of select="."/>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:variable name="ns" select="exslt:node-set($leaves)/*"/> 
		
		<root>
			<!-- Loop over sorted set and copy the first elemsnt and subsequent elements 
			that are not the same as the prior element-->
			<xsl:for-each select="$ns">
				<xsl:variable name="pos" select="position()"/>
				<xsl:if test="$pos = 1 or @value != $ns[$pos - 1]/@value">
					<xsl:copy-of select="."/>
				</xsl:if>
			</xsl:for-each>
		</root>
	</xsl:template>
	
</xsl:stylesheet>
