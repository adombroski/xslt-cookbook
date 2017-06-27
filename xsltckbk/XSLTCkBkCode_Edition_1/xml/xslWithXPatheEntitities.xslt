<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
	<!ENTITY Path "/root/child1/child2">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>

	<xsl:template match="/">
		<root>
			<xsl:apply-templates/>
		</root>
	</xsl:template>

	<xsl:template match="&Path;">
	<node>
		It worked!
	</node>
	</xsl:template>
	
	
</xsl:stylesheet>
