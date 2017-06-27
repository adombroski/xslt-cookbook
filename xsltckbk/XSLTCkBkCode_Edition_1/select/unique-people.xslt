<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.1" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

<xsl:template match="/">
	
<xsl:variable name="people">
	<xsl:for-each select="//person">
		<xsl:sort select="concat(@lastname,@firstname)"/>
		<xsl:copy-of select="."/>
	</xsl:for-each>
</xsl:variable>
	
<products>
	<xsl:for-each select="$people/person">
		<xsl:variable name="pos" select="position()"/>
		<xsl:if test="$pos = 1 or 
			concat(@lastname,@firstname) != 
                          concat(people/person[$pos - 1]/@lastname,
                                 people/person[$pos - 1]/@firstname)">
			<xsl:copy-of select="."/>
		</xsl:if>
	</xsl:for-each>
</products>
	
</xsl:template>

</xsl:stylesheet>
