<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="text" version="1.0" encoding="UTF-8"/>

<xsl:key name="level" match="//*" use="count(ancestor::*)"/>

<xsl:template match="/">
	<xsl:for-each select="key('level',3)[@sex='female']">
		<xsl:value-of select="concat(@name,count(ancestor::*),'&#x0a;')"/>
	</xsl:for-each>
</xsl:template>

</xsl:stylesheet>

