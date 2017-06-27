<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
	<!ENTITY % standard SYSTEM "standard.ent">
	%standard;
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
	<xsl:variable name="test" select=" 'The rain in Spain falls mainly in the plain' "/>
	<output>
		<lowercase>
			<xsl:value-of select="translate($test,&UPPER_TO_LOWER;)"/>
		</lowercase>
		<uppercase>
			<xsl:value-of select="translate($test,&LOWER_TO_UPPER;)"/>
		</uppercase>
	</output>
	</xsl:template>

</xsl:stylesheet>
