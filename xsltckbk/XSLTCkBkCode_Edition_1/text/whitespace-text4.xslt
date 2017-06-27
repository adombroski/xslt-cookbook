<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE stylesheet [
	<!ENTITY NEWLINE "<xsl:text>
</xsl:text>">
]>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="text" encoding="UTF-8"/>

<xsl:strip-space elements="*"/>

<xsl:template match="number">
  <xsl:value-of select="."/><xsl:text>
</xsl:text>
</xsl:template>
	
</xsl:stylesheet>
