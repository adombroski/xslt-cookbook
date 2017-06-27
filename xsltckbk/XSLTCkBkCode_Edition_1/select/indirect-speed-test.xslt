<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:vxd="urn:schemas-microsoft-com:office:visio">
  <xsl:output method="text"/>

<xsl:template match="/">
   <xsl:value-of select="count(//vxd:*)"/>
	<xsl:apply-templates select="//vxd:Shape"/>
</xsl:template>
	
<xsl:template match="vxd:Shape">
  <xsl:if test="@foo">1</xsl:if>
</xsl:template>	

</xsl:stylesheet>
